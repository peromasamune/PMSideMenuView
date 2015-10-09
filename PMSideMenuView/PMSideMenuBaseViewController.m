//
//  SideMenuBaseViewController.m
//  PMSideMenuView
//
//  Created by Peromasamune on 2015/04/05.
//  Copyright (c) 2015年 Peromasamune. All rights reserved.
//

#import "PMSideMenuBaseViewController.h"
#import "PMSideMenuViewController.h"

@interface PMSideMenuBaseViewController ()
-(void)toggleSideMenuButtonDidPush:(id)sender;
@end

@implementation PMSideMenuBaseViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if ([self.navigationController.viewControllers count] <= 1) {
        UIBarButtonItem *sideMenuButton = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(toggleSideMenuButtonDidPush:)];
        self.navigationItem.leftBarButtonItem = sideMenuButton;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Public method

-(void)viewWillTransition{
    
}

#pragma mark -- Button Actions --
-(void)toggleSideMenuButtonDidPush:(id)sender{
    [self.sideMenu toggleSideMenu];
}

@end
