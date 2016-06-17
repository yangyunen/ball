//
//  BallView.h
//  Ball
//
//  Created by yangyunen on 16/5/3.
//  Copyright © 2016年 yangyunen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface BallView : UIView

@property (assign, nonatomic) CMAcceleration acceleration;

- (void)update;

@end
