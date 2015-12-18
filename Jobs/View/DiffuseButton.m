//
//  DiffuseButton.m
//  Jobs
//
//  Created by 锤石 on 15/11/24.
//  Copyright © 2015年 王振辉. All rights reserved.
//

#import "DiffuseButton.h"
#import "UIColor+WHColor.h"
#import <Masonry.h>

@interface DiffuseButton ()

@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) CGFloat zoomInScale;

@property (nonatomic, strong) UIColor *circleColor;
@property (nonatomic, strong) UIColor *lineColor;

@property (nonatomic, strong) UIView *circleView;
@property (nonatomic, strong) CAShapeLayer *menuShapLayer;
@property (nonatomic, strong) UIBezierPath *menuPath;

@end

@implementation DiffuseButton



#pragma mark - Init

- (id)initWithRadius:(CGFloat)radius backgroundColor:(UIColor *)backgroundColor lineColor:(UIColor *)lineColor {
    if (self = [super init]) {
        self.radius = radius;
        self.circleColor = backgroundColor;
        self.lineColor = lineColor;
    }
    return self;
}

- (void)drawButton {
    [self layoutIfNeeded];
    [self initParams];
    [self initCircleView];
    [self initMenuLine];
    [self startCircleAnimation];
    [self startMenuLineAnimation];
}

- (void)initParams {
    [self.superview bringSubviewToFront:self];
    
    self.backgroundColor = [UIColor clearColor];
    self.layer.cornerRadius = self.radius;
    self.clipsToBounds = NO;
    self.enabled = NO;
    self.zoomInScale = [self diagonalLength]/self.radius;
}

- (void)initCircleView {
    self.circleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.height, self.frame.size.width)];
    self.circleView.backgroundColor = self.circleColor;
    self.circleView.layer.cornerRadius = self.radius;
    self.circleView.transform = CGAffineTransformScale(self.circleView.transform, self.zoomInScale, self.zoomInScale);
    [self addSubview:self.circleView];
}

- (void)initMenuLine {
    self.menuPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.radius, self.radius) radius:self.radius startAngle:0 endAngle:M_1_PI * 2 clockwise:NO];
    
    self.menuShapLayer = [CAShapeLayer layer];
    self.menuShapLayer.strokeColor = [UIColor redColor].CGColor;
    self.menuShapLayer.fillColor = [UIColor clearColor].CGColor;
    self.menuShapLayer.lineWidth = 2;
    self.menuShapLayer.path = self.menuPath.CGPath;
    
    [self.layer addSublayer:self.menuShapLayer];
}



#pragma mark - StartAnimation

- (void)startCircleAnimation {
    [UIView animateWithDuration:1
                          delay:0
         usingSpringWithDamping:0.6
          initialSpringVelocity:8
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.circleView.transform = CGAffineTransformScale(self.circleView.transform,1/self.zoomInScale,1/self.zoomInScale);
                     } completion:^(BOOL finished) {
                         self.circleView.hidden = YES;
                         self.backgroundColor = self.circleColor;
                         self.enabled = YES;
                     }];
    
}

- (void)startMenuLineAnimation {
    
    CGFloat length = self.frame.size.width / 2;
    CGPoint b = CGPointMake(self.frame.size.width/4, self.radius);
    CGPoint a = CGPointMake(b.x, b.y - self.frame.size.height/6);
    CGPoint c = CGPointMake(b.x, b.y + self.frame.size.height/6);
    
    UIBezierPath *tempPath = [UIBezierPath bezierPath];
    [tempPath moveToPoint:a];
    [tempPath addLineToPoint:CGPointMake(a.x + length, a.y)];
    [tempPath moveToPoint:b];
    [tempPath addLineToPoint:CGPointMake(b.x + length, b.y)];
    [tempPath moveToPoint:c];
    [tempPath addLineToPoint:CGPointMake(c.x + length, c.y)];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.fromValue = (__bridge id _Nullable)(self.menuPath.CGPath);
    animation.toValue = (__bridge id _Nullable)(tempPath.CGPath);
    animation.duration = 0.3;
    [self.menuShapLayer addAnimation:animation forKey:@"MenuStartAnimation"];
    self.menuPath = tempPath;
    self.menuShapLayer.path = self.menuPath.CGPath;

}



#pragma mark - Action

- (void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    self.enabled = NO;
    self.circleView.hidden = NO;
    [self endMenuLineAnimation];
    
    [UIView animateWithDuration:0.4
                          delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:10
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.circleView.transform = CGAffineTransformScale(self.circleView.transform,self.zoomInScale,self.zoomInScale);
                     } completion:^(BOOL finished) {
                         [super sendAction:action to:target forEvent:event];
                         [self removeFromSuperview];
                     }];
}



#pragma mark - EndAnimation

- (void)endMenuLineAnimation {
    CGFloat length = self.frame.size.width / 2;
    CGPoint b = CGPointMake(self.frame.size.width/4, self.radius);
    CGPoint a = CGPointMake(b.x, b.y - self.frame.size.height/6);
    CGPoint c = CGPointMake(b.x, b.y + self.frame.size.height/6);
    
    UIBezierPath *tempPath = [UIBezierPath bezierPath];
    [tempPath moveToPoint:a];
    [tempPath addLineToPoint:CGPointMake(c.x + length, c.y)];
    [tempPath moveToPoint:c];
    [tempPath addLineToPoint:CGPointMake(a.x + length, a.y)];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.fromValue = (__bridge id _Nullable)(self.menuPath.CGPath);
    animation.toValue = (__bridge id _Nullable)(tempPath.CGPath);
    animation.duration = 0.3;
    [self.menuShapLayer addAnimation:animation forKey:@"MenuEndAnimation"];
    self.menuPath = tempPath;
    self.menuShapLayer.path = self.menuPath.CGPath;
}


#pragma mark - CalculateDiagonalLength

- (CGFloat)diagonalLength {
    CGRect rect = [UIScreen mainScreen].bounds;
    CGFloat width = rect.size.width - self.frame.origin.x;
    CGFloat height = self.frame.origin.y;
    CGFloat length = sqrt(width * width + height * height);
    return length;
}

@end
