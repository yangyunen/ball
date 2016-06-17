//
//  BallView.m
//  Ball
//
//  Created by yangyunen on 16/5/3.
//  Copyright © 2016年 yangyunen. All rights reserved.
//

#import "BallView.h"
#import <AudioToolbox/AudioToolbox.h>
@interface BallView()

@property (strong, nonatomic) UIImage *image;
@property (assign, nonatomic) CGPoint currentPoint;
@property (assign, nonatomic) CGPoint previousPoint;
@property (assign, nonatomic) CGFloat ballXVelocity;
@property (assign, nonatomic) CGFloat ballYVelocity;

@end

@implementation BallView

- (void)commonInit
{
    self.image = [UIImage imageNamed:@"ball"];
    self.currentPoint = CGPointMake((self.bounds.size.width / 2.0f) + (self.image.size.width / 2.0f), (self.bounds.size.height / 2.0f) + (self.image.size.height / 2.0f));
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [self.image drawAtPoint:self.currentPoint];
}

///通过获得update方法更新的当前位置，来处理小球的位移动画过程
- (void)setCurrentPoint:(CGPoint)currentPoint
{
    self.previousPoint = self.currentPoint;
    _currentPoint = currentPoint;
    
    //判断小球是否碰撞到了屏幕边缘，并进行处理
    if (self.currentPoint.x < 0) {
        _currentPoint.x = 0;
        self.ballXVelocity = -self.ballXVelocity / 2.0;
    }
    if (self.currentPoint.y < 0) {
        _currentPoint.y = 0;
        self.ballYVelocity = -self.ballYVelocity / 2.0;
    }
    if (self.currentPoint.x > self.bounds.size.width - self.image.size.width) {
        _currentPoint.x = self.bounds.size.width - self.image.size.width;
        self.ballXVelocity = -self.ballXVelocity / 2.0;
    }
    if (self.currentPoint.y > self.bounds.size.height - self.image.size.height) {
        _currentPoint.y = self.bounds.size.height - self.image.size.height;
        self.ballYVelocity = -self.ballYVelocity / 2.0;
    }
    
    CGRect currentRect = CGRectMake(self.currentPoint.x, self.currentPoint.y, self.currentPoint.x + self.image.size.width, self.currentPoint.y + self.image.size.height);
    CGRect previousRect = CGRectMake(self.previousPoint.x, self.previousPoint.y, self.previousPoint.x + self.image.size.width, self.previousPoint.y + self.image.size.height);
    
    //视图上面对小球的当前位置进行更新
    [self setNeedsDisplayInRect:CGRectUnion(currentRect, previousRect)];
}


///update方法通过当前检测到的外力来计算出小球当前的加速度，并计算出位移从而得出时刻的位置
- (void)update
{
    //静态变量
    static NSDate *lastUpdateTime = nil;
    
    NSLog(@"lastUpdateTime:%@", lastUpdateTime);
    
    if (lastUpdateTime != nil) {
        //计算当前时间和上次更新时间的时间间隔
        NSTimeInterval secondsSinceLastDraw = [[NSDate date]timeIntervalSinceDate:lastUpdateTime];
        
        //计算两轴方向的速度
        self.ballYVelocity = self.ballYVelocity - (self.acceleration.y * secondsSinceLastDraw);
        self.ballXVelocity = self.ballXVelocity - (self.acceleration.x * secondsSinceLastDraw);
        //计算两轴方向的位移量
        CGFloat xAccel = secondsSinceLastDraw * self.ballXVelocity * 500;
        CGFloat yAccel = secondsSinceLastDraw * self.ballYVelocity * 500;
        //根据两轴方向的位移量得到更新后点的位置
        self.currentPoint = CGPointMake(self.currentPoint.x + xAccel, self.currentPoint.y + yAccel);
    }
    //用当前时间更新最后时间
    lastUpdateTime = [[NSDate alloc]init];
}

@end
