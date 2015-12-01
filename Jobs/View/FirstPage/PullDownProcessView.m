//
//  PullDownProcessView.m
//  Jobs
//
//  Created by 锤石 on 15/11/10.
//  Copyright © 2015年 王振辉. All rights reserved.
//

#import "PullDownProcessView.h"

@interface PullDownProcessView ()
@property (nonatomic, strong) CAShapeLayer *pullLayer;
@property (nonatomic, strong) UIBezierPath *pullPath;
@end

@implementation PullDownProcessView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initPullLayer];
    }
    return self;
}

- (void)initPullLayer {
    self.clipsToBounds = YES;
    self.pullLayer = [[CAShapeLayer alloc] init];
    self.pullLayer.fillColor = [UIColor whiteColor].CGColor;
    self.pullLayer.shadowOffset = CGSizeMake(4, 4);
    self.pullLayer.shadowColor = [UIColor grayColor].CGColor;
    self.pullLayer.shadowOpacity = 0.1;
    self.pullLayer.shadowRadius = 5;
    self.pullPath = [[UIBezierPath alloc] init];
    [self.layer addSublayer:self.pullLayer];
}


- (void)setPoint:(CGPoint)point {
    
    if (point.y < 0 ) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 0);
        return;
    }
    _point = point;
    [self updatePullLayer];
}

- (void)updatePullLayer {
    self.backgroundColor = [UIColor colorWithRed:(236.0 - _point.y)/255.0 green:(240.0 - _point.y*1.2)/255.0 blue:(241.0 - _point.y*1.3)/255.0 alpha:1.0];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, _point.y);
    
    [self.pullPath removeAllPoints];
    [self.pullPath moveToPoint:CGPointMake(0, 0)];
    [self.pullPath addQuadCurveToPoint:CGPointMake(self.frame.size.width, 0) controlPoint:CGPointMake(_point.x, _point.y)];
    [self.pullPath closePath];
    
    self.pullLayer.path = self.pullPath.CGPath;
    self.pullLayer.fillColor = self.pullColor.CGColor;
}

@end
