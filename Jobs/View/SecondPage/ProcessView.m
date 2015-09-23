//
//  ProcessView.m
//  Jobs
//
//  Created by 王振辉 on 15/9/23.
//  Copyright © 2015年 王振辉. All rights reserved.
//

#import "ProcessView.h"
#import "Masonry.h"
#import "DateAndProcess.h"
@interface ProcessView() {
    CGFloat _HEIGHT;
    CGFloat _WIDTH;
    CGFloat _percentage;
    CGFloat _distanceBetweenPoints;
    NSInteger _numberOfLastHappened;
    NSInteger _numberOfPoint;
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
    _HEIGHT = self.frame.size.height;
    _WIDTH = self.frame.size.width;
    _percentage = 0;
    _numberOfLastHappened = -1;
}


#pragma mark - Setter
- (void)setProcess:(NSMutableArray *)process {
    _process = process;
    _numberOfPoint = [process count];
    _distanceBetweenPoints = (_WIDTH - 60.0)/(_numberOfPoint - 1.0);
    if (_numberOfPoint) {
        [self compareDate];
        [self drawProcess];
    }
}

#pragma mark - Compare Date
- (void)compareDate {
    NSDate *date = [NSDate date];
    
    for (DateAndProcess *dateAndProcess in _process) {
        if ([date compare:dateAndProcess.date] == NSOrderedDescending) {
            _numberOfLastHappened = [_process indexOfObject:dateAndProcess];
        }
    }

    if (_numberOfLastHappened < _numberOfPoint - 1 && _numberOfLastHappened != -1) {
        [self percentageBetweenOldDate:[_process[_numberOfLastHappened]  date]andLaterDate:[_process[_numberOfLastHappened+1] date ]aboutNowDate:date];
    }
}

- (void)percentageBetweenOldDate:(NSDate *)oldDate andLaterDate:(NSDate *)laterDate aboutNowDate:(NSDate *)nowDate {
    if (laterDate == NULL) {
        _percentage = 0;
        return;
    }
    double totalLength = [laterDate timeIntervalSinceDate:oldDate];
    double length = [nowDate timeIntervalSinceDate:oldDate];
    _percentage = length/totalLength;
}

#pragma mark - Draw
- (void)drawProcess {
    [self drawLine];
    [self drawPoint];
    [self drawLabel];
}

- (void)drawLine {
    UIBezierPath *totalPath = [[UIBezierPath alloc]init];
    [totalPath moveToPoint:CGPointMake(30, _HEIGHT*2/3)];
    [totalPath addLineToPoint:CGPointMake(_WIDTH-30, _HEIGHT*2/3)];
    
    CAShapeLayer *totalLine = [CAShapeLayer layer];
    totalLine.strokeColor = [UIColor blackColor].CGColor;
    totalLine.fillColor = [UIColor clearColor].CGColor;
    totalLine.lineWidth = 6;
    totalLine.lineJoin = kCALineJoinRound;
    totalLine.lineCap = kCALineCapRound;
    totalLine.path = totalPath.CGPath;
    [self.layer addSublayer:totalLine];
    
    if (_numberOfLastHappened >= 0) {
        UIBezierPath *path = [[UIBezierPath alloc]init];
        [path moveToPoint:CGPointMake(30, _HEIGHT*2/3)];
        [path addLineToPoint:CGPointMake(30 + _distanceBetweenPoints * _numberOfLastHappened + _distanceBetweenPoints*_percentage, _HEIGHT*2/3)];
        CAShapeLayer *line = [CAShapeLayer layer];
        line.strokeColor = [UIColor blueColor].CGColor;
        line.fillColor = [UIColor clearColor].CGColor;
        line.lineWidth = 6;
        line.lineJoin = kCALineJoinRound;
        line.lineCap = kCALineCapRound;
        line.path = path.CGPath;
        [self.layer addSublayer:line];
    }

}

- (void)drawPoint {
    if (_numberOfPoint == 1) {
        CALayer *point = [CALayer layer];
        point.backgroundColor = [UIColor cyanColor].CGColor;
        point.cornerRadius = 4;
        point.position = CGPointMake(_WIDTH - 30, _HEIGHT*2/3);
        point.bounds = CGRectMake(0, 0, 8, 8);
        point.frame = CGRectMake(_WIDTH/2 - 4, _HEIGHT*2/3 - 4, 8, 8);
        [self.layer addSublayer:point];
    }else{
        for (NSInteger i = 0; i < _numberOfPoint; ++i) {
            CALayer *point = [[CALayer alloc]init];
            point.backgroundColor = [UIColor cyanColor].CGColor;
            point.cornerRadius = 4;
            point.position = CGPointMake(30 + i*_distanceBetweenPoints, _HEIGHT*2/3);
            point.bounds = CGRectMake(0, 0, 8, 8);
            [self.layer addSublayer:point];
        }
    }
}

- (void)drawLabel {
    
}


@end
