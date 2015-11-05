//
//  UIColor+WHColor.h
//  WHChartView
//
//  Created by 王振辉 on 15/8/15.
//  Copyright (c) 2015年 王振辉. All rights reserved.
//

#import <UIKit/UIKit.h>

//rgb取色
#define RGBA(r,g,b,a)   [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]
#define RGB(r,g,b)      RGBA(r,g,b,1)

@interface UIColor (WHColor)

+ (instancetype)whTurquoise;
+ (instancetype)whGreenSea;

+ (instancetype)whEmerald;
+ (instancetype)whNephritis;

+ (instancetype)whPeterRiver;
+ (instancetype)whBelizeHole;

+ (instancetype)whAmethyst;
+ (instancetype)whWisteria;

+ (instancetype)whWetAsphalt;
+ (instancetype)whMidnightBlue;

+ (instancetype)whSunFlower;
+ (instancetype)whOrange;

+ (instancetype)whCarrot;
+ (instancetype)whPumpkin;
+ (instancetype)whPumpkinWithAlpha:(CGFloat)alpha;

+ (instancetype)whAlizarin;
+ (instancetype)whPomegranate;

+ (instancetype)whClouds;
+ (instancetype)whSilver;
+ (instancetype)whSilverWithAlpha:(CGFloat)alpha;

+ (instancetype)whConcrete;
+ (instancetype)whAsbestos;

@end
