//
//  RHCameraPreviewView.h
//  RHCameraDemo
//
//  Created by zhuruhong on 15/11/19.
//  Copyright © 2015年 zhuruhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AVCaptureSession;

@interface RHCameraPreviewView : UIView

@property (nonatomic, strong) AVCaptureSession *session;

@end
