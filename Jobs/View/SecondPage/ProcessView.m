//
//  ProcessView.m
//  Jobs
//
//  Created by 王振辉 on 15/9/23.
//  Copyright © 2015年 王振辉. All rights reserved.
//

#import "ProcessView.h"
#import "Masonry.h"

@interface ProcessView() {
    CGFloat HEIGHT;
    CGFloat WIDTH;
    NSInteger numberOfPoint;
}
@end

@implementation ProcessView

- (id)init {
    self = [super init];
    if (self) {
        [self defaultInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self defaultInit];
    }
    
    return self;
}

- (void)defaultInit {
    self.backgroundColor = [UIColor redColor];
    HEIGHT = self.frame.size.height;
    WIDTH = self.frame.size.width;
}


#pragma mark - Setter
- (void)setProcess:(NSMutableArray *)process {
    _process = process;
    numberOfPoint = [process count];
    if (numberOfPoint) {
        [self drawProcess];
    }
}


#pragma mark - Draw
- (void)drawProcess {
    [self drawLine];
    [self drawPoint];
}

- (void)drawLine {
    UIBezierPath *path = [[UIBezierPath alloc]init];
    [path moveToPoint:CGPointMake(30, HEIGHT*2/3)];
    [path addLineToPoint:CGPointMake(WIDTH-30, HEIGHT*2/3)];
    
    CAShapeLayer *line = [CAShapeLayer layer];
    line.strokeColor = [UIColor blackColor].CGColor;
    line.fillColor = [UIColor clearColor].CGColor;
    line.lineWidth = 6;
    line.lineJoin = kCALineJoinRound;
    line.lineCap = kCALineCapRound;
    line.path = path.CGPath;
    [self.layer addSublayer:line];
}

- (void)drawPoint {
    if (numberOfPoint == 1) {
        CALayer *point = [CALayer layer];
        point.backgroundColor = [UIColor cyanColor].CGColor;
        point.cornerRadius = 4;
        point.position = CGPointMake(WIDTH - 30, HEIGHT*2/3);
        point.bounds = CGRectMake(0, 0, 8, 8);
        point.frame = CGRectMake(WIDTH/2 - 4, HEIGHT*2/3 - 4, 8, 8);
        [self.layer addSublayer:point];
    }else{
        CGFloat distance = (WIDTH - 60.0)/(numberOfPoint - 1.0);
        for (NSInteger i = 0; i < numberOfPoint; ++i) {
            CALayer *point = [[CALayer alloc]init];
            point.backgroundColor = [UIColor cyanColor].CGColor;
            point.cornerRadius = 4;
            point.position = CGPointMake(30 + i*distance, HEIGHT*2/3);
            point.bounds = CGRectMake(0, 0, 8, 8);
            [self.layer addSublayer:point];
        }
    }
}


@end
