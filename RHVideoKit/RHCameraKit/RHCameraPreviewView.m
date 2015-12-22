//
//  RHCameraPreviewView.m
//  RHCameraDemo
//
//  Created by zhuruhong on 15/11/19.
//  Copyright © 2015年 zhuruhong. All rights reserved.
//

#import "RHCameraPreviewView.h"
#import <AVFoundation/AVFoundation.h>

@implementation RHCameraPreviewView

+ (Class)layerClass
{
    return [AVCaptureVideoPreviewLayer class];
}

- (AVCaptureSession *)session
{
    return ((AVCaptureVideoPreviewLayer *)self.layer).session;
}

- (void)setSession:(AVCaptureSession *)session
{
    ((AVCaptureVideoPreviewLayer *)self.layer).session = session;
}

@end
