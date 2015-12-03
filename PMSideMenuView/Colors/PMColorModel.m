//
//  ColorModel.m
//  PMSideMenuView
//
//  Created by Peromasamune on 2015/04/05.
//  Copyright (c) 2015年 Peromasamune. All rights reserved.
//

#import "PMColorModel.h"
#import "UserDefaultManager.h"

@implementation PMColorModel

static UIColor *todayColor;

+(NSArray *)colorList{
    NSArray *colorArray = @[[UIColor colorWithWhite:0.000 alpha:1.000],
                            [UIColor colorWithRed:0.694 green:0.196 blue:0.176 alpha:1.000],
                            [UIColor colorWithRed:0.929 green:0.549 blue:0.157 alpha:1.000],
                            [UIColor colorWithRed:0.980 green:0.820 blue:0.157 alpha:1.000],
                            [UIColor colorWithRed:0.549 green:0.741 blue:0.098 alpha:1.000],
                            [UIColor colorWithRed:0.333 green:0.690 blue:0.416 alpha:1.000],
                            [UIColor colorWithRed:0.212 green:0.686 blue:0.776 alpha:1.000],
                            [UIColor colorWithRed:0.200 green:0.442 blue:0.788 alpha:1.000],
                            [UIColor colorWithRed:0.447 green:0.173 blue:0.800 alpha:1.000],
                            [UIColor colorWithRed:0.533 green:0.208 blue:0.624 alpha:1.000],
                            [UIColor colorWithRed:0.835 green:0.267 blue:0.435 alpha:1.000]];
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
    NSInteger colorType = [[UserDefaultManager getObjectForKey:DEFAULT_THEME_COLOR_TYPE] integerValue];
    if (colorType == 0) {
        todayColor = [self getRandomColor];
    }else{
        NSArray *colorList = [PMColorModel colorList];
        if (colorType - 1 < [colorList count]) {
            todayColor = [[PMColorModel colorList] objectAtIndex:colorType - 1];
        }else{
            todayColor = [self getRandomColor];
        }
    }
}

+(UIColor *)todayColor {
    return todayColor;
}

@end
