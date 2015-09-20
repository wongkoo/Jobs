//
//  CellbackgroundVIew.m
//  touch
//
//  Created by 王振辉 on 15/6/8.
//  Copyright (c) 2015年 王振辉. All rights reserved.
//

#import "CellbackgroundVIew.h"
@interface CellbackgroundVIew()

@end
@implementation CellbackgroundVIew

- (void)drawRect:(CGRect)rect
{
    
/*This caused memory leak*/
//    // 创建起点颜色
//    CGColorRef beginColor = CGColorCreate(colorSpaceRef, (CGFloat[]){243.0f/255.0, 243.0f/255.0, 243.0f/255.0,1.0f});
//    // 创建终点颜色
//    CGColorRef endColor = CGColorCreate(colorSpaceRef, (CGFloat[]){249.0f/255.0, 249.0f/255.0, 249.0f/255.0,1.0f});
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorRef startColor = [UIColor colorWithRed:243.0f/255.0 green:243.0f/255.0 blue:243.0f/255.0 alpha:1.0].CGColor;
    CGColorRef endColor = [UIColor colorWithRed:249.0f/255.0 green:249.0f/255.0 blue:249.0f/255.0 alpha:1.0].CGColor;
    CGRect paperRect = self.bounds;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    NSArray *colors = [NSArray arrayWithObjects:(__bridge id)startColor, (__bridge id)endColor, nil];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace,(CFArrayRef) colors, locations);
    CGPoint startPoint = CGPointMake(CGRectGetMidX(paperRect), CGRectGetMinY(paperRect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(paperRect), CGRectGetMaxY(paperRect));
    CGContextSaveGState(context);
    CGContextAddRect(context, paperRect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    
}
@end
