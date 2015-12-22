//
//  RHCamera.h
//  RHVideoKitDemo
//
//  Created by zhuruhong on 15/11/30.
//  Copyright © 2015年 zhuruhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface RHCamera : NSObject <AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate>

@property (nonatomic, strong) dispatch_queue_t sessionQueue;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, assign) AVCaptureDevicePosition position;

@property (nonatomic, strong) AVCaptureDeviceInput *videoDeviceInput;
@property (nonatomic, strong) AVCaptureDeviceInput *audioDeviceInput;

@property (nonatomic, strong) AVCaptureVideoDataOutput *videoDataOutput;
@property (nonatomic, strong) AVCaptureAudioDataOutput *audioDataOutput;

@property (nonatomic, getter = isDeviceAuthorized) BOOL deviceAuthorized;

@property (nonatomic, strong) AVAssetWriterInput *videoWriterInput;
@property (nonatomic, strong) AVAssetWriterInput *audioWriterInput;
@property (nonatomic, strong) AVAssetWriter *writer;
@property (nonatomic, strong) NSString *moviePath;

@property (nonatomic, assign) BOOL isRecord;

- (void)reset;
- (void)start;
- (void)stop;

@end

@interface RHCamera (Device)

- (BOOL)isSessionRunningAndDeviceAuthorized;
- (void)checkDeviceAuthorizationStatus;

+ (AVCaptureDevice *)deviceWithMediaType:(NSString *)mediaType preferringPosition:(AVCaptureDevicePosition)position;

@end
