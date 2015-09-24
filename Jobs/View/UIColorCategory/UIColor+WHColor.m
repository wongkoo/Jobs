//
//  UIColor+WHColor.m
//  WHChartView
//
//  Created by 王振辉 on 15/8/15.
//  Copyright (c) 2015年 王振辉. All rights reserved.
//

#import "UIColor+WHColor.h"

@implementation UIColor (WHColor)

+ (instancetype)whLightBlue{
    return [UIColor colorWithRed:52.0/255.0 green:152.0/255.0 blue:219.0/255.0 alpha:1.0];
    //rgba(52, 152, 219,1.0)
}

+ (instancetype)whBlue{
    return [UIColor colorWithRed:41.0/255.0 green:128.0/255.0 blue:185.0/255.0 alpha:1.0];
    //rgba(41, 128, 185,1.0)
}

+ (instancetype)whGreen{
    return [UIColor colorWithRed:39.0/255.0 green:174.0/255.0 blue:96.0/255.0 alpha:1.0];
    //rgb(39, 174, 96)
}

+ (instancetype)whLightGreen{
    return [UIColor colorWithRed:46.0/255.0 green:204.0/255.0 blue:113.0/255.0 alpha:1.0];
    //rgb(46, 204, 113)
}

+ (instancetype)whSilver{
    return [UIColor colorWithRed:189.0/255.0 green:195.0/255.0 blue:199.0/255.0 alpha:1.0];
    //rgb(189, 195, 199)
}

+ (instancetype)whSilverWithAlpha:(CGFloat)alpha {
    return [UIColor colorWithRed:189.0/255.0 green:195.0/255.0 blue:199.0/255.0 alpha:(alpha > 0 && alpha <= 1.0) ? alpha:1.0];
}

+ (instancetype)whClouds{
    return [UIColor colorWithRed:236.0/255.0 green:240.0/255.0 blue:241.0/255.0 alpha:1.0];
    //rgb(236, 240, 241)
}

+ (instancetype)whAlizarin{
    return [UIColor colorWithRed:231.0/255.0 green:76.0/255.0 blue:60.0/255.0 alpha:1.0];
    //rgb(231, 76, 60)
}

+ (instancetype)whPomegranate {
    return [UIColor colorWithRed:192.0/255.0 green:57.0/255.0 blue:43.0/255.0 alpha:1.0];
    //rgb(192, 57, 43)
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

+ (instancetype)whOrange{
    return [UIColor colorWithRed:243.0/255.0 green:156.0/255.0 blue:18.0/255.0 alpha:1.0];
    //rgb(243, 156, 18)
}

+ (instancetype)whAsbestos{
    return [UIColor colorWithRed:127.0/255.0 green:140.0/255.0 blue:141.0/255.0 alpha:1.0];
    //rgb(127, 140, 141)
}

+ (instancetype)whConcrete {
    return [UIColor colorWithRed:149.0/255.0 green:165.0/255.0 blue:166.0/255.0 alpha:1.0];
    //rgb(149, 165, 166)
}

+ (instancetype)whWetAsphalt {
    return [UIColor colorWithRed:52.0/255.0 green:73.0/255.0 blue:94.0/255.0 alpha:1.0];
    //rgb(52, 73, 94)
}

+ (instancetype)whMidnightBlue {
    return [UIColor colorWithRed:44.0/255.0 green:62.0/255.0 blue:80.0/255.0 alpha:1.0];
    //rgb(44, 62, 80)
}
@end
