//
//  DiffuseButton.m
//  Jobs
//
//  Created by 锤石 on 15/11/24.
//  Copyright © 2015年 王振辉. All rights reserved.
//

#import "DiffuseButton.h"
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
    
    self.circle = [[CAShapeLayer alloc] init];
    self.path = [UIBezierPath bezierPath];
    self.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) radius:self.radius startAngle:0 endAngle:2*M_PI clockwise:NO];
    self.circle.path = self.path.CGPath;
    self.circle.fillColor = self.color.CGColor;
    self.circle.strokeColor = self.color.CGColor;
    self.circle.backgroundColor = self.color.CGColor;
    [self.layer addSublayer:self.circle];
    
    self.centerTitleLabel = [[UILabel alloc] init];
    self.centerTitleLabel.text = self.title;
    [self addSubview:self.centerTitleLabel];
    [self.centerTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
}

- (void)sendAction:(SEL)action to:(nullable id)target forEvent:(nullable UIEvent *)event {
    UIWindow *window = self.window;
    CGFloat width = window.frame.size.width;
    CGFloat height = window.frame.size.height;
    CGFloat length =sqrt(width * width + height * height);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) radius:length startAngle:0 endAngle:6.29 clockwise:NO];
    
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
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    self.centerTitleLabel.hidden = YES;
    [self removeFromSuperview];
    [super sendAction:_action to:_target forEvent:_event];
}


@end
