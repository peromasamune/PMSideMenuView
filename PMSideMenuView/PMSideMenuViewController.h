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

@property (nonatomic) NSIndexPath *currentSideMenuIndexPath;
@property (nonatomic) id<PMSideMenuListViewControllerDelegate> delegate;

-(void)moveToViewControllerAtIndexPath:(NSIndexPath *)indexPath params:(NSDictionary *)params;
-(void)moveToViewControllerAtIndexPath:(NSIndexPath *)indexPath;

-(void)setSideMenuHidden:(BOOL)hidden animated:(BOOL)animated;
-(void)toggleSideMenu;
-(void)reloadData;

@end

@protocol PMSideMenuListViewControllerDelegate <NSObject>
-(NSInteger)PMSideMenuNumberOfSideMenuListItemsAtSection:(NSInteger)section;
-(NSInteger)PMSideMenuNumberOfSections;
-(PMSideMenuListItem *)PMSideMenuListItemAtIndexPath:(NSIndexPath*)indexPath;
-(PMSideMenuBaseViewController *)PMSideMenuViewController:(PMSideMenuViewController *)viewController transitonViewControllerWhenSelectedItemAtIndexPath:(NSIndexPath *)indexPath;
@optional
-(NSString *)PMSideMenuViewController:(PMSideMenuViewController *)viewController titleForSection:(NSInteger)section;
@end
