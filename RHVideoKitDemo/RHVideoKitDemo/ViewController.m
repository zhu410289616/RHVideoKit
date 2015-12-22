//
//  ViewController.m
//  RHVideoKitDemo
//
//  Created by zhuruhong on 15/11/30.
//  Copyright © 2015年 zhuruhong. All rights reserved.
//

#import "ViewController.h"
#import "RHCameraViewController.h"

@interface ViewController ()
{
    UIButton *_cameraButton;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cameraButton.frame = CGRectMake(50, 100, 150, 44);
    [_cameraButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_cameraButton setTitle:@"camera" forState:UIControlStateNormal];
    [_cameraButton addTarget:self action:@selector(doCamreaAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cameraButton];
    
    
}

- (void)doCamreaAction
{
    RHCameraViewController *camera = [[RHCameraViewController alloc] init];
    [self.navigationController pushViewController:camera animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
