//
//  SideMenuListView.m
//  PMSideMenuView
//
//  Created by Peromasamune on 2015/04/05.
//  Copyright (c) 2015年 Peromasamune. All rights reserved.
//

#import "PMSideMenuListView.h"

#import "PMSideMenuUserCell.h"
#import "PMSideMenuBasicCell.h"

#define SIDE_MENU_ITEM_HEIGHT 50
#define SIDE_MENU_ITEM_OFFSET 7
#define SIDE_MENU_ANIMATION_DURATION 0.2

typedef void (^SideMenuAnimationCompleteBlock)(BOOL completed);

@interface PMSideMenuListView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic) NSArray *itemArray;
@property (nonatomic) NSArray *sectionTitleArray;

-(void)reloadFrame;

@end

@implementation PMSideMenuListView

#pragma mark - Initializer

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.0];
        
        self.contentsView = [UIView new];
        self.contentsView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.0];
        [self addSubview:self.contentsView];
        
        self.tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.separatorColor = [UIColor clearColor];
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

#pragma mark - Class method

-(void)setSideMenuItems:(NSArray *)items{
    self.itemArray = [NSArray arrayWithArray:items];
    [self reloadFrame];
}

-(void)setSideMenuSectionTitles:(NSArray *)titles{
    self.sectionTitleArray = [NSArray arrayWithArray:titles];
}

#pragma mark - Property Method

-(void)setCurrentSideMenuIndexPath:(NSIndexPath *)currentSideMenuIndexPath{
    _currentSideMenuIndexPath = currentSideMenuIndexPath;
    [self.tableView reloadData];
}

#pragma mark - Private method

-(void)reloadFrame{
    self.contentsView.frame = CGRectMake((self.alpha > 0.0) ? 0 : -SIDE_MENU_ITEM_WIDTH, 0, SIDE_MENU_ITEM_WIDTH, self.frame.size.height);
    self.tableView.frame = CGRectMake(0, 0, self.contentsView.frame.size.width, self.contentsView.frame.size.height);
}

-(PMSideMenuListItem *)itemForIndexPath:(NSIndexPath *)indexPath{
    NSArray *rowArray = [self.itemArray objectAtIndex:indexPath.section];
    return [rowArray objectAtIndex:indexPath.row];
}

#pragma mark - UITableViewDataSource

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

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
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
        PMSideMenuBasicCell *cell = (PMSideMenuBasicCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[PMSideMenuBasicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }

        cell.textLabel.text = item.title;
        cell.colorImageView.originalImage = [UIImage imageNamed:item.imageUrl];
        cell.highlightedColor = item.tintColor;
        cell.isCellSelected = ([self.currentSideMenuIndexPath compare:indexPath] == NSOrderedSame);
        cell.badgeView.text = (item.badgeCount) ? [NSString stringWithFormat:@"%ld",item.badgeCount] : nil;

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

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegate PMSideMenuListViewDidSelectedItemAtIndexPath:indexPath];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //cell.backgroundColor = [UIColor clearColor];
}

@end

@implementation PMSideMenuListItem

+(PMSideMenuListItem *)itemWithTitle:(NSString *)title image:(NSString *)image tintColor:(UIColor *)tintColor{
    PMSideMenuListItem *item = [[PMSideMenuListItem alloc] initWithTitle:title image:image tintColor:tintColor];
    return item;
}

-(id)initWithTitle:(NSString *)title image:(NSString *)image tintColor:(UIColor *)tintColor{
    self = [super init];
    if (self) {
        self.title = title;
        self.imageUrl = image;
        self.tintColor = (tintColor) ? tintColor : [UIColor lightGrayColor];
    }
    return self;
}

@end
