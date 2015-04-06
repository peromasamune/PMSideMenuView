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
-(void)setSideMenuHidden:(BOOL)hidden animated:(BOOL)animated;
-(void)setSideMenuHiddenWithGesture:(UIPanGestureRecognizer *)gesture;

@end

@protocol PMSideMenuListViewDelegate <NSObject>
-(void)sideMenuListViewDidSelectedItemAtIndex:(NSInteger)index;
-(void)sideMenuListViewDidCancel;
@end

typedef enum {
    SideMenuListItemTypeDefault     = 0,
    SideMenuListItemTypeCircleImage = 1
}SideMenuListItemType;

@interface PMSideMenuListItem : NSObject

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *imageUrl;
@property (nonatomic) SideMenuListItemType type;
@property (nonatomic) CGFloat cellHeight;

+(PMSideMenuListItem *)itemWithTitle:(NSString *)title image:(NSString *)image;
-(id)initWithTitle:(NSString *)title image:(NSString *)image;

@end