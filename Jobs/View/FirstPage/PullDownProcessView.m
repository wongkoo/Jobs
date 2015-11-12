//
//  PullDownProcessView.m
//  Jobs
//
//  Created by 锤石 on 15/11/10.
//  Copyright © 2015年 王振辉. All rights reserved.
//

#import "PullDownProcessView.h"
#define LABEL_HEIGHT 40
@interface PullDownProcessView ()
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) CAShapeLayer *pullLayer;
@property (nonatomic, strong) UIBezierPath *pullPath;
@end

@implementation PullDownProcessView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initLabel];
    }
    return self;
}

- (void)initLabel {
    self.label = [[UILabel alloc] init];
    self.label.text = @"▽ Add Company";
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.alpha = 0.0;
    [self addSubview:self.label];
    self.clipsToBounds = YES;
    
    self.pullLayer = [[CAShapeLayer alloc] init];
    self.pullLayer.fillColor = [UIColor whiteColor].CGColor;
    self.pullPath = [[UIBezierPath alloc] init];
    [self.layer addSublayer:self.pullLayer];
}

- (void)setPoint:(CGPoint)point {
    if (point.y < 0) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 0);
        return;
    }
    
    self.backgroundColor = [UIColor colorWithRed:(236.0 - point.y)/255.0 green:(240.0 - point.y*1.2)/255.0 blue:(241.0 - point.y*1.3)/255.0 alpha:1.0];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, point.y);
    
    _point = point;
    self.label.frame = CGRectMake(0, self.frame.size.height - LABEL_HEIGHT - 60 + point.y, self.frame.size.width, LABEL_HEIGHT);
    self.label.alpha = point.y/100;
    
    [self.pullPath removeAllPoints];
    [self.pullPath moveToPoint:CGPointMake(0, 0)];
    [self.pullPath addQuadCurveToPoint:CGPointMake(self.frame.size.width, 0) controlPoint:CGPointMake(point.x, point.y)];
    [self.pullPath closePath];
    self.pullLayer.path = self.pullPath.CGPath;
    self.pullLayer.fillColor = self.pullColor.CGColor;
}

@end
