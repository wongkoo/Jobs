//
//  CellbackgroundVIew.m
//  touch
//
//  Created by 王振辉 on 15/6/8.
//  Copyright (c) 2015年 王振辉. All rights reserved.
//

#import "CellbackgroundVIew.h"
#import "UIColor+WHColor.h"

@interface CellbackgroundVIew()
@property (nonatomic, strong) UIColor *startColor;
@property (nonatomic, strong) UIColor *endColor;
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
//    CGColorRef startColor = [UIColor colorWithRed:243.0f/255.0 green:243.0f/255.0 blue:243.0f/255.0 alpha:1.0].CGColor;
//    CGColorRef endColor = [UIColor colorWithRed:249.0f/255.0 green:249.0f/255.0 blue:249.0f/255.0 alpha:1.0].CGColor;
    CGColorRef startColor = _startColor.CGColor;
    CGColorRef endColor = _endColor.CGColor;
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

- (id)initWithColor:(CellColor)cellColor {
    self = [super init];
    if (self) {
        [self configColor:cellColor];
    }
    return self;
}

- (void)setColor:(CellColor)cellColor {
    [self configColor:cellColor];
    [self.layer needsDisplay];
}

- (void)configColor:(CellColor)cellColor {
    
    if (cellColor == CellColorWhite) {
        _startColor = RGB(243.0f, 243.0f, 243.0f);
        _endColor = RGB(249.0f, 249.0f, 249.0f);
    } else if (cellColor == CellColorDarkGray) {
        _startColor = RGB(194.0f, 194.0f, 194.0f);
        _endColor = RGB(202.0f, 202.0f, 202.0f);
    } else if (cellColor == CellColorDarkGray) {
        _startColor = RGB(36.0f, 36.0f, 36.0f);
        _endColor = RGB(42.0f, 42.0f, 42.0f);
    }
}

@end
