//
//  DiffuseButton.m
//  Jobs
//
//  Created by 锤石 on 15/11/24.
//  Copyright © 2015年 王振辉. All rights reserved.
//

#import "MenuButton.h"
#import "UIColor+WHColor.h"
#import <Masonry.h>

static const CGFloat kMenuListButtonHeight = 40;
static const CGFloat kMenuListButtonInterval = 30;
static const NSInteger kTagOffset = 10;
static const CGFloat kGoldenRatio = 0.618;

@interface MenuButton ()

@property (nonatomic, assign) CGRect originFrame;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) CGFloat zoomInScale;

@property (nonatomic, strong) UIColor *circleColor;
@property (nonatomic, strong) UIColor *lineColor;

//Structure
@property (nonatomic, strong) UIControl *control;           ///< Top
@property (nonatomic, strong) CAShapeLayer *menuShapLayer;
@property (nonatomic, strong) UIView *gradualView;
@property (nonatomic, strong) UIView *circleView;
@property (nonatomic, strong) UIView *basicView;            ///< Bottom
@property (nonatomic, strong) UIBezierPath *menuPath;

@property (nonatomic, copy) MenuSelectedIndexBlock block;
@property (nonatomic, strong) NSArray *menuTitles;
@property (nonatomic, strong) NSMutableArray *menuButtonList;
@property (nonatomic, assign) BOOL menuOpen;

@end

@implementation MenuButton



#pragma mark - Init

- (id)initWithRadius:(CGFloat)radius
     backgroundColor:(UIColor *)backgroundColor
           lineColor:(UIColor *)lineColor
          menuTitles:(NSArray *)menuTitles
               frame:(CGRect)frame
       selectedblock:(MenuSelectedIndexBlock)block
                {
    
    if (self = [super initWithFrame:CGRectMake(20, frame.size.height - 60, 40, 40)]) {
        self.radius = radius;
        self.circleColor = backgroundColor;
        self.lineColor = lineColor;
        self.menuTitles = menuTitles;
        self.block = block;
        self.originFrame = frame;
    }
    return self;
}

- (void)drawButton {
    [self initBasicView];
    [self initParams];
    [self initBackgroundCircleView];
    [self initGradualView];
    [self initMenuLine];
    [self initControl];
    [self initMenuLineAnimation];
}

- (void)initParams {
    [self.superview bringSubviewToFront:self];
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = NO;
    self.menuOpen = NO;
    self.zoomInScale = [self diagonalLength]/self.radius + 1;
    self.menuButtonList = [[NSMutableArray alloc] init];
}

- (void)initBasicView {
    self.basicView = [[UIView alloc] init];
    [self addSubview:self.basicView];
    [self.basicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.bottom.equalTo(self);
        make.height.width.equalTo(@40);
    }];
    [self.basicView layoutIfNeeded];
}

- (void)initBackgroundCircleView {
    self.circleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.basicView.frame.size.height, self.basicView.frame.size.width)];
    self.circleView.backgroundColor = self.circleColor;
    self.circleView.layer.cornerRadius = self.radius;
    [self.basicView addSubview:self.circleView];
}

- (void)initGradualView {
    self.gradualView = [[UIView alloc] initWithFrame:self.basicView.bounds];
    self.gradualView.backgroundColor = self.circleColor;
    self.gradualView.layer.cornerRadius = self.radius;
    [self.basicView addSubview:self.gradualView];
}

- (void)initMenuLine {
    self.menuPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.radius, self.radius) radius:self.radius startAngle:0 endAngle:M_1_PI * 2 clockwise:NO];
    
    self.menuShapLayer = [CAShapeLayer layer];
    self.menuShapLayer.strokeColor = self.lineColor.CGColor;
    self.menuShapLayer.fillColor = [UIColor clearColor].CGColor;
    self.menuShapLayer.lineWidth = 2;
    self.menuShapLayer.path = self.menuPath.CGPath;
    
    [self.basicView.layer addSublayer:self.menuShapLayer];
}

- (void)initControl {
    self.control = [[UIControl alloc] initWithFrame:self.basicView.bounds];
    [self.basicView addSubview:self.control];
    [self.control addTarget:self action:@selector(menuTapped) forControlEvents:UIControlEventTouchUpInside];
}



#pragma mark - Action

- (void)menuTapped {
    self.control.enabled = NO;
    if (self.menuOpen) {
        [self closeMenu];
    }else {
        [self openMenu];
    }
}

- (void)openMenu {
    [self updateViewSelfFullScreen:YES];
    [self crossMenuLineAnimation];
    [self zoomInCircleAnimation];
    [self gradualViewShowAnimation];
    [self showMenuList];
    self.menuOpen = YES;
}

- (void)closeMenu {
    [self initMenuLineAnimation];
    [self gradualViewHideAnimation];
    [self zoomOutCircleAnimation];
    [self hideMenuList];
    self.menuOpen = NO;
    [self updateViewSelfFullScreen:NO];
}

- (void)updateViewSelfFullScreen:(BOOL)fullScreen {
    if (fullScreen) {
        self.frame = self.originFrame;
        [self.basicView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.bottom.equalTo(self).offset(-20);
        }];
    }else {
        self.frame = CGRectMake(20, self.frame.size.height - 60, 40, 40);
        [self.basicView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.bottom.equalTo(self);
        }];
    }
}


#pragma mark - CloseMenuAnimation

- (void)zoomOutReload {
    if (self.menuOpen) {
        [self closeMenu];
    }else {
        self.circleView.transform = CGAffineTransformScale(self.circleView.transform, self.zoomInScale, self.zoomInScale);
        [UIView animateWithDuration:1
                              delay:0
             usingSpringWithDamping:0.6
              initialSpringVelocity:8
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                                 self.circleView.transform = CGAffineTransformScale(self.circleView.transform,1/self.zoomInScale,1/self.zoomInScale);
                         } completion:^(BOOL finished) {
                         }];
    }
}

- (void)zoomOutCircleAnimation {
    [UIView animateWithDuration:1
                          delay:0
         usingSpringWithDamping:0.6
          initialSpringVelocity:8
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         if (self.menuOpen) {
                              self.circleView.transform = CGAffineTransformScale(self.circleView.transform,1/self.zoomInScale,1/self.zoomInScale);
                         }
                     } completion:^(BOOL finished) {
                         self.control.enabled = YES;
                         self.menuOpen = NO;
                     }];
    
}

- (void)initMenuLineAnimation {
    
    CGFloat length = self.basicView.frame.size.width / 2;
    CGPoint b = CGPointMake(self.basicView.frame.size.width/4, self.radius);
    CGPoint a = CGPointMake(b.x, b.y - self.basicView.frame.size.height/6);
    CGPoint c = CGPointMake(b.x, b.y + self.basicView.frame.size.height/6);
    
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

- (void)hideMenuList {
    if (!self.menuButtonList || self.menuButtonList.count == 0) {
        return;
    }
    
    for (UIButton *button in self.menuButtonList) {
        [UIView animateWithDuration:0.3 animations:^{
            button.frame = CGRectMake(- self.frame.size.width, button.frame.origin.y, button.frame.size.width, button.frame.size.height);
        }];
        [button removeFromSuperview];
    }
    [self.menuButtonList removeAllObjects];
}

- (void)gradualViewHideAnimation {
    [UIView animateWithDuration:0.3 animations:^{
        self.gradualView.backgroundColor = self.circleColor;
    } completion:^(BOOL finished) {
        self.gradualView.hidden = YES;
    }];
}


#pragma mark - ShowMenuAnimation

- (void)crossMenuLineAnimation {
    CGFloat length = self.basicView.frame.size.width / 2;
    CGPoint b = CGPointMake(self.basicView.frame.size.width/4, self.radius);
    CGPoint a = CGPointMake(b.x, b.y - self.basicView.frame.size.height/6);
    CGPoint c = CGPointMake(b.x, b.y + self.basicView.frame.size.height/6);
    
    UIBezierPath *tempPath = [UIBezierPath bezierPath];
    [tempPath moveToPoint:a];
    [tempPath addLineToPoint:CGPointMake(c.x + length, c.y)];
    [tempPath moveToPoint:c];
    [tempPath addLineToPoint:CGPointMake(a.x + length, a.y)];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.fromValue = (__bridge id _Nullable)(self.menuPath.CGPath);
    animation.toValue = (__bridge id _Nullable)(tempPath.CGPath);
    animation.duration = 0.2;
    [self.menuShapLayer addAnimation:animation forKey:@"MenuEndAnimation"];
    self.menuPath = tempPath;
    self.menuShapLayer.path = self.menuPath.CGPath;
}

- (void)zoomInCircleAnimation {
    [UIView animateWithDuration:0.4
                          delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:10
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         if (!self.menuOpen) {
                             self.circleView.transform = CGAffineTransformScale(self.circleView.transform,self.zoomInScale,self.zoomInScale);
                         }
                     } completion:^(BOOL finished) {
                         self.control.enabled = YES;
                     }];
}

- (void)gradualViewShowAnimation {
    self.gradualView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.gradualView.backgroundColor = [UIColor whPeterRiver];
    }];
}

- (void)showMenuList {
    if (!self.menuTitles || self.menuTitles.count == 0) {
        return;
    }
    
    NSInteger count = self.menuTitles.count;
    CGFloat totalHeight;
    
    if (count == 1) {
        totalHeight = kMenuListButtonHeight;
    }else {
        totalHeight = count * kMenuListButtonHeight + (count - 1) * kMenuListButtonInterval;
    }
    
    CGFloat basicY = (self.frame.size.height - totalHeight)/2;
    CGFloat buttonWidth = self.frame.size.width * kGoldenRatio;
    CGFloat buttonOffset = (self.frame.size.width - buttonWidth) /2;
    for (int i = 0; i < count; ++i) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(- self.frame.size.width,
                                                                      basicY + i * (kMenuListButtonHeight + kMenuListButtonInterval),
                                                                      buttonWidth,
                                                                      kMenuListButtonHeight)];
        button.backgroundColor = [UIColor whClouds];
        button.tag = kTagOffset + i;
        button.layer.cornerRadius = 5;
        [button setTitleColor:[UIColor whBelizeHole] forState:UIControlStateNormal];
        [button setTitle:self.menuTitles[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(menuButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [self.menuButtonList addObject:button];
        
        [UIView animateWithDuration:0.7
                              delay:i*0.1
             usingSpringWithDamping:0.5
              initialSpringVelocity:9
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             button.frame = CGRectMake(buttonOffset,
                                                       button.frame.origin.y,
                                                       button.frame.size.width,
                                                       button.frame.size.height);
                         } completion:^(BOOL finished) {
                             
                         }];
    }
    
}



#pragma mark - MenuListButtonTapped 

- (void)menuButtonTapped:(UIButton *)button {
    self.block(button.tag - kTagOffset);
    [self closeMenu];
}

#pragma mark - CalculateDiagonalLength

- (CGFloat)diagonalLength {
    CGFloat width = self.originFrame.size.width - self.basicView.frame.origin.x;
    CGFloat height = self.originFrame.size.height;
    CGFloat length = sqrt(width * width + height * height);
    return length;
}

@end
