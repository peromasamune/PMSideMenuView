//
//  AppDelegate.m
//  PMSideMenuView_Demo
//
//  Created by Taku Inoue on 2015/04/06.
//  Copyright (c) 2015年 Taku Inoue. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

#import "PMSideMenuViewController.h"

@interface AppDelegate ()<PMSideMenuListViewControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];

    PMSideMenuViewController *sideMenuViewController = [PMSideMenuViewController new];
    sideMenuViewController.delegate = self;
    sideMenuViewController.currentSideMenuIndex = 1;
    self.window.rootViewController = sideMenuViewController;

    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - PMSideMenuViewControllerDelegate

-(NSInteger)PMSideMenuNumberOfSideMenuListItems{
    return 4;
}

-(PMSideMenuListItem *)PMSideMenuListItemAtIndex:(NSInteger)index{
    if (index == 0) {
        PMSideMenuListItem *item = [PMSideMenuListItem itemWithTitle:@"PMSideMenuView" image:@"icon"];
        item.type = PMSideMenuListItemTypeCircleImage;
        item.cellHeight = 200;
        return item;
    }

    if (index == 1) {
        return [[PMSideMenuListItem alloc] initWithTitle:@"Menu 1" image:@"menu"];
    }
    if (index == 2) {
        return [[PMSideMenuListItem alloc] initWithTitle:@"Menu 2" image:@"menu"];
    }
    if (index == 3) {
        return [[PMSideMenuListItem alloc] initWithTitle:@"Menu 3" image:@"menu"];
    }

    return nil;
}

-(PMSideMenuBaseViewController *)PMSideMenuViewController:(PMSideMenuViewController *)viewController transitonViewControllerWhenSelectedItemAtIndex:(NSInteger)index{

    if (index == 0) {
        return nil;
    }

    ViewController *itemViewController = [ViewController new];
    itemViewController.title = [NSString stringWithFormat:@"Menu %ld",(long)index];

    return itemViewController;
}

@end
