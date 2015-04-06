//
//  SideMenuUserCell.m
//  PMSideMenuView
//
//  Created by Peromasamune on 2015/04/05.
//  Copyright (c) 2015年 Peromasamune. All rights reserved.
//

#import "PMSideMenuUserCell.h"

@implementation PMSideMenuUserCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.iconImageView = [[PMCircleImageView alloc] initWithFrame:CGRectMake(0, 0, 118, 118)];
        [self.contentView addSubview:self.iconImageView];
        
        self.userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.iconImageView.frame.origin.y + self.iconImageView.frame.size.height, self.contentView.frame.size.width, 20)];
        self.userNameLabel.backgroundColor = [UIColor clearColor];
        self.userNameLabel.font = [UIFont boldSystemFontOfSize:15];
        self.userNameLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.userNameLabel];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.iconImageView.center = CGPointMake(self.contentView.frame.size.width/2, self.contentView.frame.size.height/2);
    self.userNameLabel.frame = CGRectMake(0, self.iconImageView.frame.origin.y + self.iconImageView.frame.size.height + 5, self.contentView.frame.size.width, 20);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
