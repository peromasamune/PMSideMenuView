//
//  PMCircleImageView.m
//  PMSideMenuView
//
//  Created by Peromasamune on 2015/04/05.
//  Copyright (c) 2015年 Peromasamune. All rights reserved.
//

#import "PMCircleImageView.h"

#define BORDER_WIDTH 3

@implementation PMCircleImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
        
        self.imageBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width - BORDER_WIDTH * 2, frame.size.height - BORDER_WIDTH * 2)];
        self.imageBackgroundView.backgroundColor = [UIColor grayColor];
        self.imageBackgroundView.layer.masksToBounds = YES;
        self.imageBackgroundView.layer.cornerRadius = self.imageBackgroundView.frame.size.width/2;
        self.imageBackgroundView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.imageBackgroundView.layer.borderWidth = BORDER_WIDTH;
        [self addSubview:self.imageBackgroundView];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.imageBackgroundView.frame.size.width - BORDER_WIDTH * 3, self.imageBackgroundView.frame.size.height - BORDER_WIDTH * 3)];
        self.imageView.backgroundColor = [UIColor clearColor];
        self.imageView.layer.masksToBounds = YES;
        self.imageView.layer.cornerRadius = self.imageView.frame.size.width/2;
        self.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.imageView.layer.borderWidth = BORDER_WIDTH;
        [self.imageBackgroundView addSubview:self.imageView];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.imageBackgroundView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    self.imageView.center = CGPointMake(self.imageBackgroundView.frame.size.width/2, self.imageBackgroundView.frame.size.height/2);
}

-(void)setImage:(UIImage *)image{
    self.imageView.image = image;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
