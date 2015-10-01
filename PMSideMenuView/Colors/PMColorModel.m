//
//  ColorModel.m
//  PMSideMenuView
//
//  Created by Peromasamune on 2015/04/05.
//  Copyright (c) 2015年 Peromasamune. All rights reserved.
//

#import "PMColorModel.h"

@implementation PMColorModel

static UIColor *todayColor;

+(NSArray *)colorList{
    NSArray *colorArray = @[[UIColor colorWithRed:0.749 green:0.220 blue:0.188 alpha:1.000],
                            [UIColor colorWithRed:0.761 green:0.416 blue:0.157 alpha:1.000],
                            [UIColor colorWithRed:0.761 green:0.627 blue:0.090 alpha:1.000],
                            [UIColor colorWithRed:0.553 green:0.788 blue:0.075 alpha:1.000],
                            [UIColor colorWithRed:0.165 green:0.780 blue:0.510 alpha:1.000],
                            [UIColor colorWithRed:0.212 green:0.686 blue:0.776 alpha:1.000],
                            [UIColor colorWithRed:0.200 green:0.442 blue:0.788 alpha:1.000],
                            [UIColor colorWithRed:0.447 green:0.173 blue:0.800 alpha:1.000],
                            [UIColor colorWithRed:0.682 green:0.169 blue:0.800 alpha:1.000],
                            [UIColor colorWithRed:0.951 green:0.212 blue:0.474 alpha:1.000]];
    return colorArray;
}

+(UIColor *)getRandomColor{
    NSArray *colorArray = [PMColorModel colorList];
    
    int random = arc4random() % [colorArray count];
    
    if ([colorArray count] > random) {
        return (UIColor *)[colorArray objectAtIndex:random];
    }
    return [UIColor whiteColor];
}

+(UIColor *)gradientBaseDarkColor{
    return [UIColor colorWithRed:0.275 green:0.275 blue:0.345 alpha:1.000];
}

+(NSArray *)getNearRandomColorsForGradient{
    NSArray *colorArray = [PMColorModel colorList];
    
    int random1 = arc4random() % [colorArray count];
    int random2 = random1 + 1;
    if (random2 >= [colorArray count]) {
        random2 = 0;
    }
    
    UIColor *color1 = (UIColor *)[colorArray objectAtIndex:random1];
    UIColor *color2 = (UIColor *)[colorArray objectAtIndex:random2];
    
    return [NSArray arrayWithObjects:(id)color1.CGColor,(id)color2.CGColor, nil];
}

+(void)setTodayColor{
    todayColor = [self getRandomColor];
}

+(UIColor *)todayColor {
    return todayColor;
}

@end
