//
//  PMSidemenuBasicCell.h
//  ExploreMemo
//
//  Created by Peromasamune on 2015/09/27.
//  Copyright (c) 2015年 Tak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKBadgeView.h"

@class PMTintColorImageView;
@interface PMSideMenuBasicCell : UITableViewCell

@property (nonatomic) UIView *indexView;
@property (nonatomic) PMTintColorImageView *colorImageView;
@property (nonatomic) UILabel *textLabel;
@property (nonatomic) LKBadgeView *badgeView;
@property (nonatomic) PMTintColorImageView *indicatorImageView;

@property (nonatomic) UIColor *highlightedColor;
@property (nonatomic, assign) BOOL isCellSelected;

@end

@interface PMTintColorImageView : UIImageView

@property (nonatomic) UIImage *originalImage;

-(void)setImageColor:(UIColor *)color;

@end