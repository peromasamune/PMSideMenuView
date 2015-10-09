//
//  SideMenuViewController.m
//  PMSideMenuView
//
//  Created by Peromasamune on 2015/04/05.
//  Copyright (c) 2015年 Peromasamune. All rights reserved.
//

#import "PMSideMenuViewController.h"
#import "PMColorGradientView.h"
#import "WMNavigationBar.h"

#define ANIMATION_DURATION 0.2

static CGPoint previousPoint;
static CGPoint lastMotionDiff;

@interface PMSideMenuViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic) UINavigationController *contentsNavigationController;
@property (nonatomic) PMSideMenuListView *sideMenuListView;
@property (nonatomic) PMColorGradientView *gradientView;

@property (nonatomic, assign) BOOL isAnimation, isVisible;
@property (nonatomic) UIView *coverView;

-(void)createView;
-(UIViewController *)getViewControllerFromSideMenuIndexPath:(NSIndexPath *)indexPath;
-(void)setContentViewController:(UIViewController *)viewController;
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

//    self.gradientView = [[PMColorGradientView alloc] initWithFrame:self.view.bounds];
//    self.gradientView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    self.gradientView.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:self.gradientView];
//
//    UIToolbar *bulrView = [[UIToolbar alloc] initWithFrame:self.view.bounds];
//    bulrView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    bulrView.alpha = 1.0;
//    [self.view addSubview:bulrView];

    self.sideMenuListView = [[PMSideMenuListView alloc] initWithFrame:self.view.bounds];
    self.sideMenuListView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.sideMenuListView.delegate = self;
    self.sideMenuListView.currentSideMenuIndexPath = self.currentSideMenuIndexPath;
    [self.view addSubview:self.sideMenuListView];
    
    UIViewController *vc = [self getViewControllerFromSideMenuIndexPath:self.currentSideMenuIndexPath];
    [self setContentViewController:vc];
    
    self.coverView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.coverView.backgroundColor = [UIColor clearColor];
    [self.contentsNavigationController.view addSubview:self.coverView];
    self.coverView.hidden = !self.isVisible;

    UIPanGestureRecognizer *rightSwipeGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(detectPanGesture:)];
    rightSwipeGesture.delegate = self;
    [self.view addGestureRecognizer:rightSwipeGesture];

    UIPanGestureRecognizer *leftSwipeGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(detectPanGesture:)];
    leftSwipeGesture.delegate = self;
    [self.view addGestureRecognizer:leftSwipeGesture];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detectTapGesture:)];
    tapGesture.delegate = self;
    [self.contentsNavigationController.view addGestureRecognizer:tapGesture];

    [self reloadData];
}

#pragma mark - Class Method

-(void)transitionToSepcificViewControllerFromSideMenuIndexPath:(NSIndexPath *)indexPath{
    UIViewController *vc = [self getViewControllerFromSideMenuIndexPath:indexPath];

    if (!vc) {
        return;
    }

    if (self.isVisible) {
        [self setSideMenuHidden:YES animated:YES];
    }
    [self setContentViewController:vc];

    self.currentSideMenuIndexPath = indexPath;
    self.sideMenuListView.currentSideMenuIndexPath = indexPath;
}

-(void)setSideMenuHidden:(BOOL)hidden animated:(BOOL)animated{

    if (self.isAnimation) {
        return;
    }
    
    if (animated) {
        self.isAnimation = YES;
    }
    
    if (self.sideMenuListView.tableView) {
        self.sideMenuListView.tableView.scrollsToTop = !hidden;
    }
    
    __weak UIView *wContentsView = self.contentsNavigationController.view;
    
    
    if (hidden) {
        if (animated) {
            [UIView animateWithDuration:ANIMATION_DURATION animations:^{
                wContentsView.frame = self.view.bounds;
            } completion:^(BOOL finished) {
                self.isAnimation = NO;
            }];
        }else{
            wContentsView.frame = self.view.bounds;
        }
    }else{
        [self reloadData];
        
        CGRect targetFrame = wContentsView.bounds;
        targetFrame.origin.x = SIDE_MENU_ITEM_WIDTH;
        
        if (animated) {
            [UIView animateWithDuration:ANIMATION_DURATION delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                wContentsView.frame = targetFrame;
            } completion:^(BOOL finished) {
                self.isAnimation = NO;
            }];
        }else{
            wContentsView.frame = targetFrame;
        }
    }
    
    _isVisible = !hidden;
    self.coverView.hidden = hidden;
}

-(void)toggleSideMenu{

    if (self.isAnimation) {
        return;
    }

    [self setSideMenuHidden:self.isVisible animated:YES];
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
    [self.sideMenuListView.tableView reloadData];
}

#pragma mark - Private method

-(PMSideMenuBaseViewController *)getViewControllerFromSideMenuIndexPath:(NSIndexPath *)indexPath{
    PMSideMenuBaseViewController* vc = [self.delegate PMSideMenuViewController:self transitonViewControllerWhenSelectedItemAtIndexPath:indexPath];
    return vc;
}

-(void)setContentViewController:(PMSideMenuBaseViewController *)viewController{
    
    if (!viewController) {
        return;
    }
    
    if (!self.contentsNavigationController) {
        self.contentsNavigationController = [[UINavigationController alloc] initWithNavigationBarClass:[WMNavigationBar class] toolbarClass:nil];
        self.contentsNavigationController.view.frame = self.view.bounds;
        self.contentsNavigationController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.contentsNavigationController.view.layer.shadowColor = [UIColor blackColor].CGColor;
        self.contentsNavigationController.view.layer.shadowOffset = CGSizeMake(-1.0, 1.0);
        self.contentsNavigationController.view.layer.shadowRadius = 5.0;
        self.contentsNavigationController.view.layer.shadowOpacity = 0.3;
        
        [self addChildViewController:self.contentsNavigationController];
        [self.view addSubview:self.contentsNavigationController.view];
    }

    viewController.sideMenu = self;
    self.contentsNavigationController.viewControllers = @[viewController];
    [viewController viewWillTransition];
}

#pragma mark -- Button Actions --

#pragma mark -- SideMenu View Transform --

-(void)transformContentViewScaleWithGesture:(UIPanGestureRecognizer *)gesture{
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        previousPoint = [gesture locationInView:self.view];
    }
    
    if (gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint motionPoint = [gesture locationInView:self.view];
        
        CGPoint motionDiff = motionPoint;
        motionDiff.x = motionPoint.x - previousPoint.x;
        motionDiff.y = motionPoint.y - previousPoint.y;
        
        CGRect contentViewRect = self.contentsNavigationController.view.frame;
        
        CGFloat resultPointX = contentViewRect.origin.x + motionDiff.x;
        if (resultPointX >= SIDE_MENU_ITEM_WIDTH) resultPointX = SIDE_MENU_ITEM_WIDTH;
        if (resultPointX <= 0) resultPointX = 0;
        
        contentViewRect.origin.x = resultPointX;
        self.contentsNavigationController.view.frame = contentViewRect;
        
        previousPoint = motionPoint;
        lastMotionDiff = motionDiff;
    }

    if (gesture.state == UIGestureRecognizerStateEnded) {
        CGRect contentViewRect = self.contentsNavigationController.view.frame;
        BOOL isAnimated = !(contentViewRect.origin.x == 0 || contentViewRect.origin.x == SIDE_MENU_ITEM_WIDTH);
        BOOL isHidden = (contentViewRect.origin.x  < SIDE_MENU_ITEM_WIDTH / 2);
        
        if (lastMotionDiff.x > 10) isHidden = NO;
        if (lastMotionDiff.x < -10) isHidden = YES;
        
        [self setSideMenuHidden:isHidden animated:isAnimated];
    }
}

#pragma mark - SideMenuListViewDelegate

-(void)PMSideMenuListViewDidSelectedItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([indexPath compare:self.currentSideMenuIndexPath] == NSOrderedSame) {
        [self setSideMenuHidden:YES animated:YES];
        return;
    }
    
    [self transitionToSepcificViewControllerFromSideMenuIndexPath:indexPath];
}

#pragma mark - Gesture Action

-(void)detectTapGesture:(UITapGestureRecognizer *)gesture{
    [self setSideMenuHidden:YES animated:YES];
}

-(void)detectPanGesture:(UIPanGestureRecognizer *)gesture{
    [self transformContentViewScaleWithGesture:gesture];
}

#pragma mark - UISwipeGestureRecognizerDelegate

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{

    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        if (self.isVisible) {
            return YES;
        }
        return NO;
    }
    
    if (!self.isVisible) {
        CGPoint touchPoint = [touch locationInView:self.view];
        if (touchPoint.x < 20) {
            return YES;
        }
    }

    if (self.isVisible) {
        CGPoint touchPoint = [touch locationInView:self.view];
        if (CGRectContainsPoint(self.contentsNavigationController.view.frame, touchPoint)) {
            return YES;
        }
    }

    return NO;
}

@end
