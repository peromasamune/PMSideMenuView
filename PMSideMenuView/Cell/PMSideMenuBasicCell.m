//
//  PMSidemenuBasicCell.m
//  ExploreMemo
//
//  Created by Peromasamune on 2015/09/27.
//  Copyright (c) 2015年 Tak. All rights reserved.
//

#import "PMSideMenuBasicCell.h"
#import "WMImageUtility.h"

#define INDEX_MARGIN 5.0
#define IMAGE_MARGIN 5.0
#define BADGE_MARGIN 5.0

@interface PMSideMenuBasicCell()

@end

@implementation PMSideMenuBasicCell

@synthesize textLabel = _textLabel;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.indexView = [UIView new];
        self.indexView.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.indexView];
        
        self.colorImageView = [PMTintColorImageView new];
        self.colorImageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.colorImageView];
        
        self.textLabel = [UILabel new];
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.font = [UIFont systemFontOfSize:17];
        [self.contentView addSubview:self.textLabel];
        
        self.badgeView = [LKBadgeView new];
        self.badgeView.horizontalAlignment = LKBadgeViewHorizontalAlignmentRight;
        [self.contentView addSubview:self.badgeView];
        
        self.indicatorImageView = [PMTintColorImageView new];
        self.indicatorImageView.backgroundColor = [UIColor clearColor];
        [self.indicatorImageView setOriginalImage:[UIImage imageNamed:@"desc_arrow_right_gray"]];
        [self.contentView addSubview:self.indicatorImageView];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat offsetX = 0.0;
    CGFloat contentHeight = CGRectGetHeight(self.contentView.frame);
    
    self.indexView.frame = CGRectMake(offsetX, 0, INDEX_MARGIN, contentHeight + 0.5);
    offsetX += CGRectGetWidth(self.indexView.frame) + 2;
    
    self.colorImageView.frame = CGRectInset(CGRectMake(offsetX, 0, contentHeight, contentHeight), IMAGE_MARGIN, IMAGE_MARGIN);
    offsetX += CGRectGetWidth(self.colorImageView.frame) + IMAGE_MARGIN * 2 + 2;
    
    self.textLabel.frame = CGRectMake(offsetX, 0, CGRectGetWidth(self.contentView.frame) - offsetX, contentHeight);
    
    self.badgeView.frame = CGRectMake(CGRectGetWidth(self.contentView.frame) - 50 - BADGE_MARGIN * 2, contentHeight/2 - 10, 50, 20);
    
    CGFloat indicatorSizeUnit = 17;
    self.indicatorImageView.frame = CGRectMake(CGRectGetWidth(self.contentView.frame) - IMAGE_MARGIN * 2 - indicatorSizeUnit, CGRectGetHeight(self.contentView.frame) / 2 - indicatorSizeUnit / 2, indicatorSizeUnit, indicatorSizeUnit);
    
    if (self.badgeView.text.length > 0) {
        self.indicatorImageView.hidden = YES;
    }else{
        self.indicatorImageView.hidden = NO;
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted) {
        [self.colorImageView setImageColor:self.highlightedColor];
        self.textLabel.textColor = self.highlightedColor;
        [self.indicatorImageView setImageColor:self.highlightedColor];
    }else{
        [self updateAppearance];
    }
}

#pragma mark - Private method

-(void)updateAppearance{
    if (self.isCellSelected) {
        [self.colorImageView setImageColor:self.highlightedColor];
        self.textLabel.textColor = self.highlightedColor;
        self.indexView.backgroundColor = self.highlightedColor;
        self.badgeView.badgeColor = self.highlightedColor;
        [self.indicatorImageView setImageColor:self.highlightedColor];
    }else{
        [self.colorImageView setImageColor:nil];
        self.textLabel.textColor = [UIColor blackColor];
        self.indexView.backgroundColor = [UIColor clearColor];
        self.badgeView.badgeColor = [UIColor grayColor];
        [self.indicatorImageView setImageColor:nil];
    }
}

#pragma mark - Property method

-(void)setHighlightedColor:(UIColor *)highlightedColor{
    _highlightedColor = highlightedColor;
}

-(void)setIsCellSelected:(BOOL)isCellSelected{
    _isCellSelected = isCellSelected;
    [self updateAppearance];
}

@end

#pragma mark - PMTintColorImageView

@interface PMTintColorImageView()

@end

@implementation PMTintColorImageView

-(void)setOriginalImage:(UIImage *)originalImage{
    _originalImage = originalImage;
    self.image = originalImage;
}

-(void)setImageColor:(UIColor *)color{
    
    if (!self.image) {
        return;
    }
    
    if (color) {
        self.image = [WMImageUtility imageWithTintColor:self.originalImage color:color];
    }else{
        if (self.originalImage) {
            self.image = self.originalImage;
        }
    }
}

@end
