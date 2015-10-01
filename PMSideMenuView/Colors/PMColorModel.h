//
//  ColorModel.h
//  PMSideMenuView
//
//  Created by Peromasamune on 2015/04/05.
//  Copyright (c) 2015年 Peromasamune. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PMColorModel : NSObject

+(NSArray *)colorList;
+(UIColor *)getRandomColor;
+(UIColor *)gradientBaseDarkColor;
+(NSArray *)getNearRandomColorsForGradient;

+(void)setTodayColor;
+(UIColor *)todayColor;

@end
