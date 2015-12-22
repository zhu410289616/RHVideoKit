//
//  RHCamera.m
//  RHVideoKitDemo
//
//  Created by zhuruhong on 15/11/30.
//  Copyright © 2015年 zhuruhong. All rights reserved.
//

#import "RHCamera.h"

@implementation RHCamera

- (instancetype)init
{
    if (self = [super init]) {
        _sessionQueue = dispatch_queue_create("session queue", DISPATCH_QUEUE_SERIAL);
        _session = [[AVCaptureSession alloc] init];
        _position = AVCaptureDevicePositionBack;
    }
    return self;
}

- (void)reset
{
    dispatch_async(_sessionQueue, ^{
        //
        [_session beginConfiguration];
        
        //video input
        AVCaptureDevice *videoDevice = [RHCamera deviceWithMediaType:AVMediaTypeVideo preferringPosition:_position];
        NSError *error = nil;
        _videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
        NSAssert(!error, error.description);
        if ([_session canAddInput:_videoDeviceInput]) {
            [_session addInput:_videoDeviceInput];
        }
        
        //audio input
        AVCaptureDevice *audioDevice = [RHCamera deviceWithMediaType:AVMediaTypeAudio preferringPosition:_position];
        _audioDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:&error];
        NSAssert(!error, error.description);
        if ([_session canAddInput:_audioDeviceInput]) {
            [_session addInput:_audioDeviceInput];
        }
        
        //video data output
        _videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
        _videoDataOutput.videoSettings = @{(id)kCVPixelBufferPixelFormatTypeKey:@(kCVPixelFormatType_32BGRA)};
        [_videoDataOutput setSampleBufferDelegate:self queue:_sessionQueue];
        if ([_session canAddOutput:_videoDataOutput]) {
            [_session addOutput:_videoDataOutput];
        }
        
        //audio data output
        _audioDataOutput = [[AVCaptureAudioDataOutput alloc] init];
        [_audioDataOutput setSampleBufferDelegate:self queue:_sessionQueue];
        if ([_session canAddOutput:_audioDataOutput]) {
            [_session addOutput:_audioDataOutput];
        }
        
        //movie
        NSString *betaCompressionDirectory = [NSTemporaryDirectory() stringByAppendingPathComponent:[@"movie" stringByAppendingPathExtension:@"mov"]];
        NSURL *fileURL = [NSURL fileURLWithPath:betaCompressionDirectory];
        _writer = [[AVAssetWriter alloc] initWithURL:fileURL fileType:AVFileTypeQuickTimeMovie error:&error];
        NSAssert(!error, error.description);
        
        //video
        NSDictionary *videoSettings = @{
                                        AVVideoCodecKey:AVVideoCodecH264,
                                        AVVideoWidthKey:@(640),
                                        AVVideoHeightKey:@(480)
                                        };
        _videoWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:videoSettings];
        _videoWriterInput.expectsMediaDataInRealTime = YES;
        if ([_writer canAddInput:_videoWriterInput]) {
            [_writer addInput:_videoWriterInput];
        }//if
        
        //audio
        AudioChannelLayout acl;
        bzero(&acl, sizeof(acl));
        acl.mChannelLayoutTag = kAudioChannelLayoutTag_Mono;
        
        //
//        NSDictionary *audioOutputSettings = @{
//                                              AVFormatIDKey:@(kAudioFormatAppleLossless),
//                                              AVEncoderBitDepthHintKey:@(16),
//                                              AVSampleRateKey:@(44100),
//                                              AVNumberOfChannelsKey:@(1),
//                                              AVChannelLayoutKey:[NSData dataWithBytes:&acl length:sizeof(acl)]
//                                              };
        NSDictionary *audioOutputSettings = @{
                                              AVFormatIDKey:@(kAudioFormatMPEG4AAC),
                                              AVEncoderBitRateKey:@(64000),
                                              AVSampleRateKey:@(44100),
                                              AVNumberOfChannelsKey:@(1),
                                              AVChannelLayoutKey:[NSData dataWithBytes:&acl length:sizeof(acl)]
                                              };
        _audioWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio outputSettings:audioOutputSettings];
        _audioWriterInput.expectsMediaDataInRealTime = YES;
        if ([_writer canAddInput:_audioWriterInput]) {
            [_writer addInput:_audioWriterInput];
        }
        
        //
        [_session commitConfiguration];
        [_session startRunning];
    });
}

- (void)start
{
    dispatch_async(_sessionQueue, ^{
        [_writer startWriting];
    });
}

- (void)stop
{
    dispatch_async(_sessionQueue, ^{
        [_videoWriterInput markAsFinished];
        [_audioWriterInput markAsFinished];
        [_writer finishWritingWithCompletionHandler:^{
            //
        }];
    });
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    CMTime lastSampleTime = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
    if (!_isRecord && _writer.status != AVAssetWriterStatusWriting) {
        _isRecord = YES;
        [_writer startWriting];
        [_writer startSessionAtSourceTime:lastSampleTime];
    }
    
    if (captureOutput == _videoDataOutput) {
        if (_writer.status > AVAssetWriterStatusWriting) {
            if (_writer.status == AVAssetWriterStatusFailed) {
                return;
            }
        }
        if ([_videoWriterInput isReadyForMoreMediaData]) {
            if ([_videoWriterInput appendSampleBuffer:sampleBuffer]) {
                NSLog(@"already write video...");
            } else {
                NSLog(@"unable to write to video input...");
            }
        }//if
    } else if (captureOutput == _audioDataOutput) {
        if (_writer.status > AVAssetWriterStatusWriting) {
            if (_writer.status == AVAssetWriterStatusFailed) {
                return;
            }
        }
        if ([_audioWriterInput isReadyForMoreMediaData]) {
            if ([_audioWriterInput appendSampleBuffer:sampleBuffer]) {
                NSLog(@"already write audio...");
            } else {
                NSLog(@"unable to write to audio input...");
            }
        }//if
    }//
}

@end

@implementation RHCamera (Device)

- (BOOL)isSessionRunningAndDeviceAuthorized
{
    return [[self session] isRunning] && [self isDeviceAuthorized];
}

- (void)checkDeviceAuthorizationStatus
{
    NSString *mediaType = AVMediaTypeVideo;
    [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
        if (granted) {
            //Granted access to mediaType
            [self setDeviceAuthorized:YES];
        } else {
            //Not granted access to mediaType
            [self setDeviceAuthorized:NO];
        }
    }];
}

+ (AVCaptureDevice *)deviceWithMediaType:(NSString *)mediaType preferringPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:mediaType];
    AVCaptureDevice *captureDevice = [devices firstObject];
    for (AVCaptureDevice *device in devices) {
        if (position == device.position) {
            captureDevice = device;
            break;
        }//if
    }//for
    return captureDevice;
}

@end
