//
//  ShareViewController.m
//  Jobs
//
//  Created by 锤石 on 15/12/1.
//  Copyright © 2015年 王振辉. All rights reserved.
//

#import "ShareViewController.h"
#import "UIColor+WHColor.h"
#import "Masonry.h"

static const CGFloat kCrossButtonWidth = 30;

@interface ShareViewController ()
@property (nonatomic, strong) UIImageView *sharedImageView;
@property (nonatomic, strong) UIView *animationView;
@property (nonatomic, strong) CADisplayLink *displayLink;
@end

@implementation ShareViewController

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whBelizeHole];
    
    _animationView = [[UIView alloc] initWithFrame:CGRectMake(-self.view.bounds.size.width, 0, 10, 10)];
    _animationView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_animationView];
    
    _sharedImageView = [[UIImageView alloc] initWithImage:self.sharedImage];
    _sharedImageView.frame = CGRectMake(0, 60, self.view.frame.size.width - 40, self.view.frame.size.height - 120);
    [self.view addSubview:_sharedImageView];
    
//    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(animationView.mas_left).offset(20);
//        make.top.equalTo(animationView.mas_top).offset(60);
//        make.width.equalTo(self.view).offset(-40);
//    }];
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleDisplayLink)];
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    
    [UIView animateWithDuration:1 delay:0.0 usingSpringWithDamping:0.4 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _animationView.frame = CGRectMake(0, 0, 10, 10);
    } completion:^(BOOL finished) {
        [_displayLink invalidate];
    }];
    
    

//    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.sharedImage];
//    [self.view addSubview:imageView];
    

    
    UIButton *crossButton = [[UIButton alloc] init];
    crossButton.backgroundColor = [UIColor redColor];
    [crossButton setTitle:@"✕" forState:UIControlStateNormal];
    crossButton.layer.cornerRadius = kCrossButtonWidth/2;
    [crossButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:crossButton];
    
    [crossButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_sharedImageView.mas_right).offset(-kCrossButtonWidth/2);
        make.bottom.equalTo(_sharedImageView.mas_top).offset(kCrossButtonWidth/2);
        make.width.height.equalTo(@(kCrossButtonWidth));
    }];
    
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = [UIColor redColor];
    button.layer.cornerRadius = 5;
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-20);
        make.width.equalTo(self.view).offset(-40);
        make.height.equalTo(@50);
    }];
    
}

- (void)handleDisplayLink {
    CGRect frame = _sharedImageView.frame;
    frame.origin.x = _animationView.frame.origin.x;
    _sharedImageView.frame = frame;
}

- (void)close {
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.view.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [self.view removeFromSuperview];
                         [self removeFromParentViewController];
                         self.finishBlock();
                     }];
}

@end
