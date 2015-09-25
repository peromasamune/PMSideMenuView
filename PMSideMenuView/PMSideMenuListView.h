//
//  SideMenuListView.h
//  PMSideMenuView
//
//  Created by Peromasamune on 2015/04/05.
//  Copyright (c) 2015年 Peromasamune. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SIDE_MENU_ITEM_WIDTH 200

@protocol PMSideMenuListViewDelegate;
@class PMSideMenuListItem;
@interface PMSideMenuListView : UIView

@property (nonatomic) UIView *contentsView;
@property (nonatomic) UITableView *tableView;
@property (nonatomic, assign) id<PMSideMenuListViewDelegate> delegate;

-(void)setSideMenuItems:(NSArray *)items;
-(void)setSideMenuSectionTitles:(NSArray *)titles;

@end

@protocol PMSideMenuListViewDelegate <NSObject>
-(void)PMSideMenuListViewDidSelectedItemAtIndexPath:(NSIndexPath *)indexPath;
@end

typedef enum {
    PMSideMenuListItemTypeDefault     = 0,
    PMSideMenuListItemTypeCircleImage = 1
}PMSideMenuListItemType;

@interface PMSideMenuListItem : NSObject

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *imageUrl;
@property (nonatomic) PMSideMenuListItemType type;
@property (nonatomic) CGFloat cellHeight;

+(PMSideMenuListItem *)itemWithTitle:(NSString *)title image:(NSString *)image;
-(id)initWithTitle:(NSString *)title image:(NSString *)image;

@end