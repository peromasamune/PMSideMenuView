//
//  SideMenuViewController.m
//  PMSideMenuView
//
//  Created by Peromasamune on 2015/04/05.
//  Copyright (c) 2015年 Peromasamune. All rights reserved.
//

#import "PMSideMenuViewController.h"
#import "PMColorGradientView.h"

#define ANIMATION_DURATION 0.2

@interface PMSideMenuViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic) UINavigationController *contentsNavigationController;
@property (nonatomic) PMSideMenuListView *sideMenuListView;
@property (nonatomic) PMColorGradientView *gradientView;

-(void)createView;
-(UIViewController *)getViewControllerFromSideMenuIndexPath:(NSIndexPath *)indexPath;
-(void)setContentViewController:(UIViewController *)viewController;

-(void)transformContentViewScaleWithSideMenuHidden:(BOOL)hidden animated:(BOOL)animated;

-(void)detectRightSwipe:(UISwipeGestureRecognizer *)gesture;
-(void)detectLeftSwipe:(UISwipeGestureRecognizer *)gesture;

@end

@implementation PMSideMenuViewController

#pragma mark - Initialize

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View Management

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self createView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Create View

-(void)createView{

    self.gradientView = [[PMColorGradientView alloc] initWithFrame:self.view.bounds];
    self.gradientView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.gradientView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.gradientView];

    UIToolbar *bulrView = [[UIToolbar alloc] initWithFrame:self.gradientView.bounds];
    bulrView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    bulrView.alpha = 0.5;
    [self.view addSubview:bulrView];

    UIViewController *vc = [self getViewControllerFromSideMenuIndexPath:self.currentSideMenuIndexPath];
    [self setContentViewController:vc];
    
    self.sideMenuListView = [[PMSideMenuListView alloc] initWithFrame:self.view.bounds];
    self.sideMenuListView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.sideMenuListView.delegate = self;
    [self.view addSubview:self.sideMenuListView];

    UIPanGestureRecognizer *rightSwipeGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(detectRightSwipe:)];
    rightSwipeGesture.delegate = self;
    [self.view addGestureRecognizer:rightSwipeGesture];

    UIPanGestureRecognizer *leftSwipeGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(detectLeftSwipe:)];
    leftSwipeGesture.delegate = self;
    [self.view addGestureRecognizer:leftSwipeGesture];

    [self reloadData];
}

#pragma mark - Class Method

-(void)transitionToSepcificViewControllerFromSideMenuIndexPath:(NSIndexPath *)indexPath{
    UIViewController *vc = [self getViewControllerFromSideMenuIndexPath:indexPath];

    if (!vc) {
        return;
    }

    if (self.sideMenuListView.isVisible) {
        [self setSideMenuHidden:YES animated:YES];
    }
    [self setContentViewController:vc];

    self.currentSideMenuIndexPath = indexPath;
}

-(void)setSideMenuHidden:(BOOL)hidden animated:(BOOL)animated{

    if (hidden) {
        [self.sideMenuListView setSideMenuHidden:hidden animated:animated];
        double delayInSeconds = ANIMATION_DURATION;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self transformContentViewScaleWithSideMenuHidden:hidden animated:animated];
        });
    }else{
        [self transformContentViewScaleWithSideMenuHidden:hidden animated:animated];
        double delayInSeconds = ANIMATION_DURATION;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.sideMenuListView setSideMenuHidden:hidden animated:animated];
        });
    }
}

-(void)toggleSideMenu{

    if (self.sideMenuListView.isAnimation) {
        return;
    }

    BOOL isSidemenuVisible = self.sideMenuListView.isVisible;

    [self setSideMenuHidden:isSidemenuVisible animated:YES];
}

-(void)reloadData{
    NSMutableArray *sideMenuItemArray = [NSMutableArray array];
    NSMutableArray *sectionTitleArray = [NSMutableArray array];

    for (NSInteger i = 0 ; i < [self.delegate PMSideMenuNumberOfSections]; i++) {
        //Items
        NSMutableArray *sectionItems = [NSMutableArray array];
        for (NSInteger j = 0; j < [self.delegate PMSideMenuNumberOfSideMenuListItemsAtSection:i]; j++) {
            PMSideMenuListItem *item = [self.delegate PMSideMenuListItemAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
            if(item) [sectionItems addObject:item];
        }
        [sideMenuItemArray addObject:sectionItems];
        
        //Secton Titles
        if ([self.delegate respondsToSelector:@selector(PMSideMenuViewController:titleForSection:)]) {
            NSString *title = [self.delegate PMSideMenuViewController:self titleForSection:i];
            [sectionTitleArray addObject:(title) ? title : @""];
        }
    }
    [self.sideMenuListView setSideMenuItems:sideMenuItemArray];
    [self.sideMenuListView setSideMenuSectionTitles:sectionTitleArray];
}

#pragma mark - Private Method

-(PMSideMenuBaseViewController *)getViewControllerFromSideMenuIndexPath:(NSIndexPath *)indexPath{
    PMSideMenuBaseViewController* vc = [self.delegate PMSideMenuViewController:self transitonViewControllerWhenSelectedItemAtIndexPath:indexPath];
    return vc;
}

-(void)setContentViewController:(PMSideMenuBaseViewController *)viewController{
    
    if (!viewController) {
        return;
    }
    
    if (!self.contentsNavigationController) {
        self.contentsNavigationController = [[UINavigationController alloc] init];
        self.contentsNavigationController.view.frame = self.view.bounds;
        self.contentsNavigationController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.contentsNavigationController.view.layer.shadowColor = [UIColor blackColor].CGColor;
        self.contentsNavigationController.view.layer.shadowOffset = CGSizeMake(3.0, 3.0);
        self.contentsNavigationController.view.layer.shadowOpacity = 0.3;
        
        [self addChildViewController:self.contentsNavigationController];
        [self.view addSubview:self.contentsNavigationController.view];
    }

    viewController.sideMenu = self;
    self.contentsNavigationController.viewControllers = @[viewController];
}

#pragma mark -- Button Actions --

#pragma mark -- SideMenu View Transform --

-(void)transformContentViewScaleWithSideMenuHidden:(BOOL)hidden animated:(BOOL)animated{
    
    __weak UIView *wContentsView = self.contentsNavigationController.view;


    if (hidden) {
        if (animated) {
            [UIView animateWithDuration:ANIMATION_DURATION animations:^{
                wContentsView.transform = CGAffineTransformIdentity;
                wContentsView.frame = self.gradientView.frame;
            } completion:^(BOOL finished) {

            }];
        }else{
            wContentsView.transform = CGAffineTransformIdentity;
            wContentsView.frame = self.gradientView.frame;
        }
    }else{
        if (animated) {
            [UIView animateWithDuration:ANIMATION_DURATION animations:^{
                wContentsView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
            } completion:^(BOOL finished) {
                
            }];
        }else{
            wContentsView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        }
    }
}

-(void)transformContentViewScaleWithGesture:(UIPanGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateChanged) {
        CGFloat ratio = self.sideMenuListView.gestureRatio;
        CGFloat cRatio = (1 - ratio) * 0.1 + 0.9;

        self.contentsNavigationController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, cRatio, cRatio);
    }

    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self transformContentViewScaleWithSideMenuHidden:!self.sideMenuListView.isVisible animated:YES];
    }
}

#pragma mark -- SideMenuListViewDelegate --

-(void)PMSideMenuListViewDidSelectedItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([indexPath compare:self.currentSideMenuIndexPath] == NSOrderedSame) {
        [self setSideMenuHidden:YES animated:YES];
        return;
    }
    
    [self transitionToSepcificViewControllerFromSideMenuIndexPath:indexPath];
}

-(void)PMSideMenuListViewDidCancel{
    [self setSideMenuHidden:YES animated:YES];
}

#pragma mark - Gesture Action

-(void)detectRightSwipe:(UIPanGestureRecognizer *)gesture{
    [self.sideMenuListView setSideMenuHiddenWithGesture:gesture];
    [self transformContentViewScaleWithGesture:gesture];
}

-(void)detectLeftSwipe:(UIPanGestureRecognizer *)gesture{
    [self.sideMenuListView setSideMenuHiddenWithGesture:gesture];
    [self transformContentViewScaleWithGesture:gesture];
}

#pragma mark - UISwipeGestureRecognizerDelegate

-(BOOL)gestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{

    if (!self.sideMenuListView.isVisible) {
        CGPoint touchPoint = [touch locationInView:self.view];
        if (touchPoint.x < 20) {
            return YES;
        }
    }

    if (self.sideMenuListView.isVisible) {
        CGPoint touchPoint = [touch locationInView:self.view];
        if (CGRectContainsPoint(self.sideMenuListView.contentsView.frame, touchPoint)) {
            return YES;
        }
    }

    return NO;
}

@end
