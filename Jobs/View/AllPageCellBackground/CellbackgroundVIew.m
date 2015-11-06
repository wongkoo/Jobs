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
    [self setNeedsDisplay];
}

- (void)configColor:(CellColor)cellColor {
    
    switch (cellColor) {
        case CellColorWhite:
            _startColor = RGB(243.0f, 243.0f, 243.0f);
            _endColor = RGB(249.0f, 249.0f, 249.0f);
            break;
        case CellColorSliver:
            _startColor = RGB(194.0f, 194.0f, 194.0f);
            _endColor = RGB(202.0f, 202.0f, 202.0f);
            break;
        case CellColorDarkGray:
            _startColor = RGB(36.0f, 36.0f, 36.0f);
            _endColor = RGB(42.0f, 42.0f, 42.0f);
            break;
        case CellColorConcrete:
            _startColor = RGB(77.0f, 77.0f, 77.0f);
            _endColor = RGB(84.0f, 84.0f, 84.0f);
            break;
        case CellColorSky:
            _startColor = RGB(212.0f, 237.0f, 255.0f);
            _endColor = RGB(206.0f, 227.0f, 255.0f);
            break;
        case CellColorVista:
            _startColor = RGB(84.0f, 147.0f, 197.0f);
            _endColor = RGB(74.0f, 121.0f, 181.0f);
            break;
        case CellColorDenim:
            _startColor = RGB(43.0f, 101.0f, 148.0f);
            _endColor = RGB(37.0f, 67.0f, 133.0f);
            break;
        case CellColorMidnight:
            _startColor = RGB(16.0f, 62.0f, 67.0f);
            _endColor = RGB(16.0f, 42.0f, 75.0f);
            break;
        default:
            _startColor = RGB(243.0f, 243.0f, 243.0f);
            _endColor = RGB(249.0f, 249.0f, 249.0f);
            break;
    }
    
    
//    if (cellColor == CellColorWhite) {
//        _startColor = RGB(243.0f, 243.0f, 243.0f);
//        _endColor = RGB(249.0f, 249.0f, 249.0f);
//    } else if (cellColor == CellColorDarkGray) {
//        _startColor = RGB(194.0f, 194.0f, 194.0f);
//        _endColor = RGB(202.0f, 202.0f, 202.0f);
//    } else if (cellColor == CellColorDarkGray) {
//        _startColor = RGB(36.0f, 36.0f, 36.0f);
//        _endColor = RGB(42.0f, 42.0f, 42.0f);
//    } else if (cellColor == CellColorConcrete) {
//        _startColor = RGB(77.0f, 77.0f, 77.0f);
//        _endColor = RGB(84.0f, 84.0f, 84.0f);
//    }
}

@end
