//
//  PullDownProcessView.m
//  Jobs
//
//  Created by 锤石 on 15/11/10.
//  Copyright © 2015年 王振辉. All rights reserved.
//

#import "PullDownProcessView.h"
#import "UIColor+WHColor.h"

@interface PullDownProcessView ()
@property (nonatomic, strong) UIColor *pullColor;
@property (nonatomic, strong) CAShapeLayer *pullLayer;
@property (nonatomic, strong) UIBezierPath *pullPath;
@property (nonatomic, strong) UIView *statusBarView;
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
    
    //StatusBar
    self.statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 20)];
    [self addSubview:self.statusBarView];
    
    //PullDownView
    self.pullLayer = [[CAShapeLayer alloc] init];
    self.pullLayer.fillColor = [UIColor whiteColor].CGColor;
    self.pullLayer.shadowOffset = CGSizeMake(4, 4);
    self.pullLayer.shadowColor = [UIColor grayColor].CGColor;
    self.pullLayer.shadowOpacity = 0.1;
    self.pullLayer.shadowRadius = 5;
    self.pullPath = [[UIBezierPath alloc] init];
    [self.layer addSublayer:self.pullLayer];
}

- (void)setPullColor:(UIColor *)pullColor {
    _pullColor = pullColor;
    self.statusBarView.backgroundColor = _pullColor;
    self.pullLayer.fillColor = _pullColor.CGColor;
}

- (void)setPoint:(CGPoint)point {
    
    if (point.y < 0 ) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 20);
        return;
    }
    _point = point;
    [self updatePullLayer];
}

- (void)updatePullLayer {
    self.backgroundColor = [UIColor colorWithRed:(236.0 - _point.y)/255.0 green:(240.0 - _point.y*1.2)/255.0 blue:(241.0 - _point.y*1.3)/255.0 alpha:1.0];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, _point.y + 20);
    
    [self.pullPath removeAllPoints];
    [self.pullPath moveToPoint:CGPointMake(0, 20)];
    [self.pullPath addQuadCurveToPoint:CGPointMake(self.frame.size.width, 20) controlPoint:CGPointMake(_point.x, _point.y + 20)];
    [self.pullPath closePath];
    
    self.pullLayer.path = self.pullPath.CGPath;
//    self.pullLayer.fillColor = self.pullColor.CGColor;
}

- (void)setPureColor:(PureColor)pureColor {
    switch (pureColor) {
        case PureColorColorWhite:
            self.pullColor = RGB(249.0f, 249.0f, 249.0f);
            break;
        case PureColorColorSilver:
            self.pullColor = RGB(202.0f, 202.0f, 202.0f);
            break;
        case PureColorDarkGray:
            self.pullColor = RGB(42.0f, 42.0f, 42.0f);
            break;
        case PureColorConcrete:
            self.pullColor = RGB(84.0f, 84.0f, 84.0f);
            break;
        case PureColorSky:
            self.pullColor = RGB(206.0f, 227.0f, 255.0f);
            break;
        case PureColorVista:
            self.pullColor = RGB(74.0f, 121.0f, 181.0f);
            break;
        case PureColorDenim:
            self.pullColor = RGB(37.0f, 67.0f, 133.0f);
            break;
        case PureColorMidnight:
            self.pullColor = RGB(16.0f, 42.0f, 75.0f);
            break;
        default:
            self.pullColor = RGB(249.0f, 249.0f, 249.0f);
            break;
    }
}

@end
