//
//  PMCircleImageView.h
//  PMSideMenuView
//
//  Created by Peromasamune on 2015/04/05.
//  Copyright (c) 2015年 Peromasamune. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PMCircleImageView : UIView

@property (nonatomic) UIView *imageBackgroundView;
@property (nonatomic) UIImageView *imageView;

-(void)setImage:(UIImage *)image;

@end
