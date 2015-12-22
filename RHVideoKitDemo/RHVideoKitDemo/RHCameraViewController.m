//
//  RHCameraViewController.m
//  RHVideoKitDemo
//
//  Created by zhuruhong on 15/11/30.
//  Copyright © 2015年 zhuruhong. All rights reserved.
//

#import "RHCameraViewController.h"
#import "RHCameraPreviewView.h"
#import "RHCamera.h"

@interface RHCameraViewController ()
{
    RHCameraPreviewView *_previewView;
    RHCamera *_camera;
    
    UIButton *_startButton;
    UIButton *_stopButton;
}

@end

@implementation RHCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _previewView = [[RHCameraPreviewView alloc] init];
    _previewView.frame = self.view.bounds;
    [self.view addSubview:_previewView];
    
    _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _startButton.frame = CGRectMake(50, 100, 150, 44);
    [_startButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_startButton setTitle:@"start" forState:UIControlStateNormal];
    [_startButton addTarget:self action:@selector(doStartAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_startButton];
    
    _stopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _stopButton.frame = CGRectMake(50, CGRectGetMaxY(_startButton.frame) + 20, 150, 44);
    [_stopButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_stopButton setTitle:@"stop" forState:UIControlStateNormal];
    [_stopButton addTarget:self action:@selector(doStopAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_stopButton];
    
    _camera = [[RHCamera alloc] init];
    [_camera reset];
    [_previewView setSession:_camera.session];
    
}

- (void)doStartAction
{
    [_camera start];
}

- (void)doStopAction
{
    [_camera stop];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
