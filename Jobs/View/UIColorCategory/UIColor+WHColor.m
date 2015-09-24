//
//  UIColor+WHColor.m
//  WHChartView
//
//  Created by 王振辉 on 15/8/15.
//  Copyright (c) 2015年 王振辉. All rights reserved.
//

#import "UIColor+WHColor.h"

@implementation UIColor (WHColor)

+ (instancetype)whTurquoise {
    return [UIColor colorWithRed:26.0/255.0 green:188.0/255.0 blue:156.0/255.0 alpha:1.0];
    //rgb(26, 188, 156)
}
+ (instancetype)whGreenSea {
    return [UIColor colorWithRed:22.0/255.0 green:160.0/255.0 blue:133.0/255.0 alpha:1.0];
    //rgb(22, 160, 133)
}


+ (instancetype)whEmerald{
    return [UIColor colorWithRed:46.0/255.0 green:204.0/255.0 blue:113.0/255.0 alpha:1.0];
    //rgb(46, 204, 113)
}
+ (instancetype)whNephritis{
    return [UIColor colorWithRed:39.0/255.0 green:174.0/255.0 blue:96.0/255.0 alpha:1.0];
    //rgb(39, 174, 96)
}


+ (instancetype)whPeterRiver{
    return [UIColor colorWithRed:52.0/255.0 green:152.0/255.0 blue:219.0/255.0 alpha:1.0];
    //rgba(52, 152, 219,1.0)
}
+ (instancetype)whBelizeHole{
    return [UIColor colorWithRed:41.0/255.0 green:128.0/255.0 blue:185.0/255.0 alpha:1.0];
    //rgba(41, 128, 185,1.0)
}


+ (instancetype)whAmethyst {
    return [UIColor colorWithRed:155.0/255.0 green:89.0/255.0 blue:182.0/255.0 alpha:1.0];
    //rgb(155, 89, 182)
}
+ (instancetype)whWisteria {
    return [UIColor colorWithRed:142.0/255.0 green:68.0/255.0 blue:173.0/255.0 alpha:1.0];
    //rgb(142, 68, 173)
}


+ (instancetype)whWetAsphalt {
    return [UIColor colorWithRed:52.0/255.0 green:73.0/255.0 blue:94.0/255.0 alpha:1.0];
    //rgb(52, 73, 94)
}
+ (instancetype)whMidnightBlue {
    return [UIColor colorWithRed:44.0/255.0 green:62.0/255.0 blue:80.0/255.0 alpha:1.0];
    //rgb(44, 62, 80)
}


+ (instancetype)whSunFlower {
    return [UIColor colorWithRed:241.0/255.0 green:196.0/255.0 blue:15.0/255.0 alpha:1.0];
    //rgb(241, 196, 15)
}
+ (instancetype)whOrange{
    return [UIColor colorWithRed:243.0/255.0 green:156.0/255.0 blue:18.0/255.0 alpha:1.0];
    //rgb(243, 156, 18)
}


+ (instancetype)whCarrot{
    return [UIColor colorWithRed:230.0/255.0 green:126.0/255.0 blue:34.0/255.0 alpha:1.0];
    //rgb(230, 126, 34)
}
+ (instancetype)whPumpkin {
    return [UIColor colorWithRed:211.0/255.0 green:84.0/255.0 blue:0 alpha:1.0];
    //rgb(211, 84, 0)
}
+ (instancetype)whPumpkinWithAlpha:(CGFloat)alpha {
    return [UIColor colorWithRed:211.0/255.0 green:84.0/255.0 blue:0 alpha:(alpha > 0 && alpha <= 1.0) ? alpha:1.0];
}


+ (instancetype)whAlizarin{
    return [UIColor colorWithRed:231.0/255.0 green:76.0/255.0 blue:60.0/255.0 alpha:1.0];
    //rgb(231, 76, 60)
}
+ (instancetype)whPomegranate {
    return [UIColor colorWithRed:192.0/255.0 green:57.0/255.0 blue:43.0/255.0 alpha:1.0];
    //rgb(192, 57, 43)
}


+ (instancetype)whClouds{
    return [UIColor colorWithRed:236.0/255.0 green:240.0/255.0 blue:241.0/255.0 alpha:1.0];
    //rgb(236, 240, 241)
}
+ (instancetype)whSilver{
    return [UIColor colorWithRed:189.0/255.0 green:195.0/255.0 blue:199.0/255.0 alpha:1.0];
    //rgb(189, 195, 199)
}
+ (instancetype)whSilverWithAlpha:(CGFloat)alpha {
    return [UIColor colorWithRed:189.0/255.0 green:195.0/255.0 blue:199.0/255.0 alpha:(alpha > 0 && alpha <= 1.0) ? alpha:1.0];
}


+ (instancetype)whConcrete {
    return [UIColor colorWithRed:149.0/255.0 green:165.0/255.0 blue:166.0/255.0 alpha:1.0];
    //rgb(149, 165, 166)
}
+ (instancetype)whAsbestos{
    return [UIColor colorWithRed:127.0/255.0 green:140.0/255.0 blue:141.0/255.0 alpha:1.0];
    //rgb(127, 140, 141)
}




@end
