//
//  ViewController.m
//  Ball
//
//  Created by yangyunen on 16/5/3.
//  Copyright © 2016年 yangyunen. All rights reserved.
//

#import "ViewController.h"
#import "BallView.h"
#import <CoreMotion/CoreMotion.h>

#define kUpdateInterval (1.60f/60.0f)

@interface ViewController ()

@property (strong, nonatomic) CMMotionManager *motionManager;
@property (strong, nonatomic) NSOperationQueue *queue;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.motionManager = [[CMMotionManager alloc]init];
    self.queue = [[NSOperationQueue alloc]init];
    self.motionManager.deviceMotionUpdateInterval = kUpdateInterval;
    __weak ViewController *weakSelf = self;
    [self.motionManager startDeviceMotionUpdatesToQueue:self.queue withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
        BallView *ballView = (BallView *)weakSelf.view;
        CMAcceleration g;
        g.x = -motion.gravity.x;
        g.y = motion.gravity.y;
        g.z = motion.gravity.z;
        
        [ballView setAcceleration:g];
        dispatch_async(dispatch_get_main_queue(), ^{
            [ballView update];
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
