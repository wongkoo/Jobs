//
//  CellbackgroundVIew.m
//  touch
//
//  Created by 王振辉 on 15/6/8.
//  Copyright (c) 2015年 王振辉. All rights reserved.
//

#import "CellbackgroundVIew.h"
@interface CellbackgroundVIew(){
    CGFloat begin[4];
    CGFloat end[4];
}

@end
@implementation CellbackgroundVIew
- (id)initWithBeginRGBAFloatArray:(CGFloat *)beginRGBAFloatArray andEndRGBAFloatArray:(CGFloat *)endRGBAFloatArray{
    if (self = [super init]) {
        for (int i=0; i<4; ++i) {
            begin[i] = beginRGBAFloatArray[i];
            end[i] = endRGBAFloatArray[i];
        }
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    // 创建起点颜色 白色
    CGColorRef beginColor = CGColorCreate(colorSpaceRef,begin);
    // 创建终点颜色 灰色 RGB(212,212,212) 这个色值我们可以从chroma扩展插件中选择
    //    <pre class="brush:cpp; toolbar: true; auto-links: false;">
    //(CGFloat[]){0.83f, 0.83f, 0.83f, 1.0f} 0.83是 212/255的值</pre>
    CGColorRef endColor = CGColorCreate(colorSpaceRef,end);

//    CGRect paperRect = self.bounds;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = {0.0,1.0};
    NSArray *colors = [NSArray arrayWithObjects:(__bridge id)beginColor,(__bridge id)endColor, nil];
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)CFBridgingRetain(colors), locations);
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    CGContextSaveGState(context);
    CGContextAddRect(context, rect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    //add line stroke
//    CGRect strokeRect = CGRectInset(paperRect, 5.0, 5.0);
//    CGColorRef lineColor = CGColorCreate(colorSpaceRef, (CGFloat[]){0.83f, 0.83f, 0.83f, 1.0f});
//    CGContextSetStrokeColorWithColor(context, lineColor);
//    CGContextSetLineWidth(context, 1.0);
//    CGContextStrokeRect(context, strokeRect);
}
@end
