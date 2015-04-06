//
//  ColorGradientView.m
//  PMSideMenuView
//
//  Created by Taku Inoue on 2015/04/05.
//  Copyright (c) 2015年 Taku Inoue. All rights reserved.
//

#import "PMColorGradientView.h"
#import "PMColorModel.h"

@implementation PMColorGradientView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.gradientLayer = [CAGradientLayer layer];
        self.gradientLayer.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
        self.gradientLayer.colors = [PMColorModel getNearRandomColorsForGradient];
        [self.gradientLayer setStartPoint:CGPointMake(0.5, 0.0)];
        [self.gradientLayer setEndPoint:CGPointMake(0.5, 1.0)];
        [self.layer insertSublayer:self.gradientLayer atIndex:0];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];

    self.gradientLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}

@end
