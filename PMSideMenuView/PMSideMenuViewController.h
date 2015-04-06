//
//  SideMenuViewController.h
//  PMSideMenuView
//
//  Created by Peromasamune on 2015/04/05.
//  Copyright (c) 2015年 Peromasamune. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMSideMenuListView.h"
#import "PMSideMenuBaseViewController.h"

@protocol PMSideMenuListViewControllerDelegate;
@interface PMSideMenuViewController : UIViewController<PMSideMenuListViewDelegate>

@property (nonatomic, assign) NSInteger currentSideMenuIndex;
@property (nonatomic) id<PMSideMenuListViewControllerDelegate> delegate;

+(PMSideMenuViewController *)sharedController;

-(void)transitionToSepcificViewControllerFromSideMenuType:(NSInteger)type;

-(void)setSideMenuHidden:(BOOL)hidden animated:(BOOL)animated;
-(void)toggleSideMenu;
-(void)reloadData;

@end

@protocol PMSideMenuListViewControllerDelegate <NSObject>
-(NSInteger)PMSideMenuNumberOfSideMenuListItems;
-(PMSideMenuListItem *)PMSideMenuListItemAtIndex:(NSInteger)index;
-(UIViewController *)PMSideMenuViewController:(PMSideMenuViewController *)viewController transitonViewControllerWhenSelectedItemAtIndex:(NSInteger)index;
@end
