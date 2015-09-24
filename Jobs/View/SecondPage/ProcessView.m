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
#import "UIColor+WHColor.h"

@interface ProcessView() {
    CGFloat _HEIGHT;
    CGFloat _WIDTH;
    CGFloat _percentage;
    CGFloat _distanceBetweenPoints;
    CGFloat _firstPointX;
    CGFloat _yOfLine;
    CGFloat _yOfProcessString;
    CGFloat _yOfDate;
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
    self.backgroundColor = [UIColor clearColor];
    _HEIGHT = self.frame.size.height;
    _WIDTH = self.frame.size.width;
    _yOfProcessString = _HEIGHT/6 - 5;
    _yOfLine = _HEIGHT/2;
    _yOfDate = _HEIGHT/2 + 5;
    _percentage = 0;
    _numberOfLastHappened = -1;
}


#pragma mark - Setter
- (void)setProcess:(NSMutableArray *)process {
    _process = process;
    _numberOfPoint = [process count];
    _distanceBetweenPoints = _WIDTH / _numberOfPoint;
    _firstPointX = _distanceBetweenPoints/2;
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
    [totalPath moveToPoint:CGPointMake(_firstPointX, _yOfLine)];
    [totalPath addLineToPoint:CGPointMake(_WIDTH-_firstPointX, _yOfLine)];
    
    CAShapeLayer *totalLine = [CAShapeLayer layer];
    totalLine.strokeColor = [UIColor whSilver].CGColor;
    totalLine.fillColor = [UIColor clearColor].CGColor;
    totalLine.lineWidth = 6;
    totalLine.lineJoin = kCALineJoinRound;
    totalLine.lineCap = kCALineCapRound;
    totalLine.path = totalPath.CGPath;
    [self.layer addSublayer:totalLine];
    
    if (_numberOfLastHappened >= 0) {
        UIBezierPath *path = [[UIBezierPath alloc]init];
        [path moveToPoint:CGPointMake(_firstPointX, _yOfLine)];
        [path addLineToPoint:CGPointMake(_firstPointX + _distanceBetweenPoints * _numberOfLastHappened + _distanceBetweenPoints*_percentage, _yOfLine)];
        CAShapeLayer *line = [CAShapeLayer layer];
        line.strokeColor = [UIColor whPumpkin].CGColor;
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
        point.backgroundColor = [UIColor whiteColor].CGColor;
        point.cornerRadius = 4;
        point.position = CGPointMake(_WIDTH/2 -4, _yOfLine);
        point.bounds = CGRectMake(0, 0, 8, 8);
        [self.layer addSublayer:point];
    }else{
        for (NSInteger i = 0; i < _numberOfPoint; ++i) {
            CALayer *point = [[CALayer alloc]init];
            point.backgroundColor = [UIColor whiteColor].CGColor;
            point.cornerRadius = 4;
            point.position = CGPointMake(_firstPointX + i*_distanceBetweenPoints, _yOfLine);
            point.bounds = CGRectMake(0, 0, 8, 8);
            [self.layer addSublayer:point];
        }
    }
}

- (void)drawLabel {
    for (NSInteger i = 0; i < _numberOfPoint; ++i) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake( i*_distanceBetweenPoints, _yOfProcessString, _distanceBetweenPoints, _HEIGHT/3)];
        label.backgroundColor = [UIColor clearColor];
        label.text = [_process[i] string];
        label.textAlignment = NSTextAlignmentCenter;
        if (i <= _numberOfLastHappened) {
            label.textColor = [UIColor whConcrete];
        }else{
            label.textColor = [UIColor whWetAsphalt];
        }
        [self addSubview:label];
    }
    
    if (_numberOfLastHappened == -1) {
        return;
    }
    for (NSInteger i = _numberOfLastHappened+1; i < _numberOfPoint; ++i) {
        
        DateAndProcess *dateAndProcess = [_process objectAtIndex:i];
        NSDateFormatter  *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM月dd日"];
        NSString *dateString=[dateFormatter stringFromDate:dateAndProcess.date];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake( i*_distanceBetweenPoints, _yOfDate, _distanceBetweenPoints, _HEIGHT/3)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whMidnightBlue];
        label.text = dateString;
        label.font = [UIFont systemFontOfSize:15];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
    }
}


@end
