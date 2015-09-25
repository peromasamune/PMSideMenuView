//
//  SideMenuListView.m
//  PMSideMenuView
//
//  Created by Peromasamune on 2015/04/05.
//  Copyright (c) 2015年 Peromasamune. All rights reserved.
//

#import "PMSideMenuListView.h"

#import "PMSideMenuUserCell.h"

#define ITEM_HEIGHT 50
#define ITEM_WIDTH 200
#define ITEM_OFFSET 7
#define ANIMATION_DURATION 0.2

static CGPoint previousPoint;
static CGPoint lastMotionDiff;

typedef void (^SideMenuAnimationCompleteBlock)(BOOL completed);

@interface PMSideMenuListView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSArray *itemArray;
@property (nonatomic) NSArray *sectionTitleArray;

-(void)reloadFrame;

@end

@implementation PMSideMenuListView

#pragma mark -- Initialize --

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.0];
        self.alpha = 0.0;
        self.isVisible = NO;
        self.isAnimation = NO;
        self.currentSelectedIndex = 0;
        
        self.contentsView = [UIView new];
        self.contentsView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.9];
        self.contentsView.layer.shadowColor = [UIColor blackColor].CGColor;
        self.contentsView.layer.shadowOffset = CGSizeMake(3.0, 3.0);
        self.contentsView.layer.shadowOpacity = 0.3;
        [self addSubview:self.contentsView];
        
        self.tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
        self.tableView.showsVerticalScrollIndicator = NO;
        [self.contentsView addSubview:self.tableView];

    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self reloadFrame];
}

#pragma mark -- Class Method --

-(void)setSideMenuItems:(NSArray *)items{
    self.itemArray = [NSArray arrayWithArray:items];
    [self reloadFrame];
}

-(void)setSideMenuSectionTitles:(NSArray *)titles{
    self.sectionTitleArray = [NSArray arrayWithArray:titles];
}

-(void)setSideMenuHidden:(BOOL)hidden animated:(BOOL)animated{

    if (self.isAnimation) {
        return;
    }
    
    if (animated) {
        self.isAnimation = YES;
    }

    if (self.tableView) {
        self.tableView.scrollsToTop = !hidden;
    }
    
    __weak PMSideMenuListView *wself = self;
    
    if (hidden) {
        [UIView animateWithDuration:(animated) ? ANIMATION_DURATION : 0.0 animations:^{
            CGRect frame = wself.contentsView.frame;
            frame.origin.x = -frame.size.width;
            wself.contentsView.frame = frame;
            wself.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.0];
        } completion:^(BOOL finished) {
            wself.alpha = 0.0;
            self.isAnimation = NO;
        }];
    }else{
        wself.alpha = 1.0;
        [UIView animateWithDuration:(animated) ? ANIMATION_DURATION : 0.0 animations:^{
            CGRect frame = wself.contentsView.frame;
            frame.origin.x = 0;
            wself.contentsView.frame = frame;
            wself.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.3];
        } completion:^(BOOL finished) {
            self.isAnimation = NO;
        }];
    }

    _gestureRatio = !hidden;
    _isVisible = !hidden;
}

-(void)setSideMenuHiddenWithGesture:(UIPanGestureRecognizer *)gesture{

    if (gesture.state == UIGestureRecognizerStateBegan) {
        previousPoint = [gesture locationInView:self];
        self.alpha = 1.0;
    }

    if (gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint motionPoint = [gesture locationInView:self];

        CGPoint motionDiff = motionPoint;
        motionDiff.x = motionPoint.x - previousPoint.x;
        motionDiff.y = motionPoint.y - previousPoint.y;

        CGRect contentViewRect = self.contentsView.frame;

        CGFloat resultPointX = contentViewRect.origin.x + motionDiff.x;
        if (resultPointX > 0) resultPointX = 0;
        if (resultPointX <= -contentViewRect.size.width) resultPointX = -contentViewRect.size.width;

        contentViewRect.origin.x = resultPointX;
        self.contentsView.frame = contentViewRect;

        _gestureRatio = ((contentViewRect.origin.x + self.contentsView.frame.size.width) / self.contentsView.frame.size.width);
        self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:_gestureRatio * 0.3];

        previousPoint = motionPoint;
        lastMotionDiff = motionDiff;
    }

    if (gesture.state == UIGestureRecognizerStateEnded) {

        BOOL isAnimated = !(self.contentsView.frame.origin.x == -self.contentsView.frame.size.width || self.contentsView.frame.origin.x == 0);
        BOOL isHidden = (self.contentsView.frame.origin.x < -self.contentsView.frame.size.width/2);

        if (lastMotionDiff.x > 10) {
            isHidden = NO;
        }
        if (lastMotionDiff.x < -10) {
            isHidden = YES;
        }

        [self setSideMenuHidden:isHidden animated:isAnimated];
    }
}

#pragma mark -- Private Method --

-(void)reloadFrame{
    self.contentsView.frame = CGRectMake((self.alpha > 0.0) ? 0 : -ITEM_WIDTH, 0, ITEM_WIDTH, self.frame.size.height);
    self.tableView.frame = CGRectMake(0, 0, self.contentsView.frame.size.width, self.contentsView.frame.size.height);
}

-(PMSideMenuListItem *)itemForIndexPath:(NSIndexPath *)indexPath{
    NSArray *rowArray = [self.itemArray objectAtIndex:indexPath.section];
    return [rowArray objectAtIndex:indexPath.row];
}

#pragma mark -- Touch Event --

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (self.isAnimation) {
        return;
    }
    [self.delegate PMSideMenuListViewDidCancel];
}

#pragma mark -- UITableViewDataSource --

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.itemArray count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *rowArray = (NSArray *)[self.itemArray objectAtIndex:section];
    return [rowArray count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (self.sectionTitleArray.count > section) {
        NSString *title = [self.sectionTitleArray objectAtIndex:section];
        return title;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    PMSideMenuListItem *item = [self itemForIndexPath:indexPath];
    if (item.cellHeight) {
        return item.cellHeight;
    }
    return 44.f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    static NSString *UserCellIdentifer = @"UserCell";

    PMSideMenuListItem *item = [self itemForIndexPath:indexPath];

    if (item.type == PMSideMenuListItemTypeDefault) {
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }

        cell.textLabel.text = item.title;
        cell.imageView.image = [UIImage imageNamed:item.imageUrl];

        return cell;
    }

    if (item.type == PMSideMenuListItemTypeCircleImage) {
        PMSideMenuUserCell *userCell = (PMSideMenuUserCell *)[tableView dequeueReusableCellWithIdentifier:UserCellIdentifer];
        if (!userCell) {
            userCell = [[PMSideMenuUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:UserCellIdentifer];
        }

        userCell.userNameLabel.text = item.title;
        [userCell.iconImageView setImage:[UIImage imageNamed:item.imageUrl]];
        userCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return userCell;
    }
    
    return nil;
}

#pragma mark -- UITableViewDelegate --

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegate PMSideMenuListViewDidSelectedItemAtIndexPath:indexPath];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor = [UIColor clearColor];
}

@end

@implementation PMSideMenuListItem

+(PMSideMenuListItem *)itemWithTitle:(NSString *)title image:(NSString *)image{
    PMSideMenuListItem *item = [[PMSideMenuListItem alloc] initWithTitle:title image:image];
    return item;
}

-(id)initWithTitle:(NSString *)title image:(NSString *)image{
    self = [super init];
    if (self) {
        self.title = title;
        self.imageUrl = image;
    }
    return self;
}

@end
