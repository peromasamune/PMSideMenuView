//
//  SideMenuListView.h
//  PMSideMenuView
//
//  Created by Peromasamune on 2015/04/05.
//  Copyright (c) 2015年 Peromasamune. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PMSideMenuListViewDelegate;
@class PMSideMenuListItem;
@interface PMSideMenuListView : UIView

@property (nonatomic) UIView *contentsView;
@property (nonatomic, assign) BOOL isVisible, isAnimation;
@property (nonatomic, assign) NSInteger currentSelectedIndex;
@property (nonatomic, assign) id<PMSideMenuListViewDelegate> delegate;
@property (nonatomic, assign, readonly) CGFloat gestureRatio;

-(void)setSideMenuItems:(NSArray *)items;
-(void)setSideMenuSectionTitles:(NSArray *)titles;
-(void)setSideMenuHidden:(BOOL)hidden animated:(BOOL)animated;
-(void)setSideMenuHiddenWithGesture:(UIPanGestureRecognizer *)gesture;

@end

@protocol PMSideMenuListViewDelegate <NSObject>
-(void)PMSideMenuListViewDidSelectedItemAtIndexPath:(NSIndexPath *)indexPath;
-(void)PMSideMenuListViewDidCancel;
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