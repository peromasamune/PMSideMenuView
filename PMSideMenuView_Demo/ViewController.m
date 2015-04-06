//
//  ViewController.m
//  PMSideMenuView_Demo
//
//  Created by Taku Inoue on 2015/04/06.
//  Copyright (c) 2015年 Taku Inoue. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic) UILabel *titleLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 40)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, CGRectGetHeight(self.view.frame)/2);
    _titleLabel.text = self.title;
    [self.view addSubview:_titleLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
