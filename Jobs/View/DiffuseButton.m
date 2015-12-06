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

@interface DiffuseButton () {
    SEL _action;
    id _target;
    UIEvent *_event;
}
@property (nonatomic, strong) CAShapeLayer *circle;
@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, strong) UILabel *centerTitleLabel;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, strong) UIColor *color;

@property (nonatomic, strong) UIView *animationView;

@end

@implementation DiffuseButton

- (id)initWithTitle:(NSString *)title radius:(CGFloat)radius color:(UIColor *)color {
    if (self = [super init]) {
        self.title = title;
        self.radius = radius;
        self.color = color;
    }
    return self;
}

- (void)drawButton {
    [self layoutIfNeeded];
    [self.superview bringSubviewToFront:self];
    self.layer.cornerRadius = self.radius;
    self.clipsToBounds = NO;
    self.enabled = NO;
    
    self.circle = [[CAShapeLayer alloc] init];
    self.path = [UIBezierPath bezierPath];
    self.path = [self bigCirclePath];
    self.circle.path = self.path.CGPath;
    self.circle.fillColor = self.color.CGColor;
    self.circle.strokeColor = self.color.CGColor;
    self.circle.backgroundColor = self.color.CGColor;
    [self.layer addSublayer:self.circle];

    self.animationView = [[UIView alloc] initWithFrame:CGRectMake([self diagonalLength], 0, 0, 0)];
    [self addSubview:self.animationView];
    
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(doAnimation)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:8 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.animationView.frame = CGRectMake(0, 0, 0, 0);
    } completion:^(BOOL finished) {
            [displayLink invalidate];
            self.enabled = YES;
    }];
    
    
    self.centerTitleLabel = [[UILabel alloc] init];
    self.centerTitleLabel.text = self.title;
    self.centerTitleLabel.textColor = [UIColor whClouds];
    [self addSubview:self.centerTitleLabel];
    [self.centerTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
}

- (void)doAnimation {
    CALayer *animationLayer = [self.animationView.layer presentationLayer];
    CGRect rect = [[animationLayer valueForKeyPath:@"frame"]CGRectValue];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) radius:self.radius + rect.origin.x startAngle:0 endAngle:2*M_PI clockwise:NO];
    self.circle.path = path.CGPath;
}

- (void)sendAction:(SEL)action to:(nullable id)target forEvent:(nullable UIEvent *)event {
    UIBezierPath *path = [self bigCirclePath];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.duration = 0.3;
    animation.fromValue = (__bridge id _Nullable)(self.circle.path);
    animation.toValue = (__bridge id _Nullable)(path.CGPath);
    animation.delegate = self;
    [self.circle addAnimation:animation forKey:@"animation"];
    self.path = path;
    self.circle.path = self.path.CGPath;

    _action = action;
    _target = target;
    _event = event;
    self.enabled = NO;;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    self.centerTitleLabel.hidden = YES;
    [super sendAction:_action to:_target forEvent:_event];
    [self removeFromSuperview];
}

- (UIBezierPath *)bigCirclePath {
    CGFloat length = [self diagonalLength];
    return  [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) radius:length startAngle:0 endAngle:6.29 clockwise:NO];
}

- (CGFloat)diagonalLength {
    CGRect rect = [UIScreen mainScreen].bounds;
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGFloat length = sqrt(width * width + height * height);
    return length;
}

@end
