//
//  AboutViewController.m
//  Jobs
//
//  Created by 锤石 on 15/12/21.
//  Copyright © 2015年 王振辉. All rights reserved.
//

#import "AboutViewController.h"
#import "UIColor+WHColor.h"
#import <Masonry.h>
#import <YYText.h>
#import <WebKit/WebKit.h>
#import <POP.h>
#import "UIView+Jobs.h"

static NSString * const kAboutString = @"Jobs\n \nFor you. For the future.\nDesigned by wongkoo.";
static NSString * const kAboutMeURL = @"http://wongkoo.github.io/about/";

static const CGFloat kLogoHightWidth = 80.0;
static const CGFloat kYYLabelOffset = 20;
static const CGFloat kYYLabelHeight = 100;
static const CGFloat kCloseButtonWidth = 30;

@interface AboutViewController ()
@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) YYLabel *textLabel;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, assign) BOOL webViewOpen;
@end

@implementation AboutViewController



#pragma mark - ViewLifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whBelizeHole];
    self.webViewOpen = NO;
    [self initLogo];
    [self initCloseButton];
    [self initTextView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



#pragma mark - Init

- (void)initLogo {
    self.logoView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.width - kLogoHightWidth)/2, (self.view.height * (1-0.618) - kLogoHightWidth/2), kLogoHightWidth, kLogoHightWidth)];
    self.logoView.layer.cornerRadius = 10;
    self.logoView.image = [UIImage imageNamed:@"icon400"];
    [self.view addSubview:self.logoView];
    [self.logoView.layer pop_addAnimation:[self createScaleXYPOPSpringAnimation] forKey:@"LogoViewZoomInSpringAnimation"];
}

- (void)initTextView {
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:kAboutString];
    
    //highlight
    YYTextBorder *hightlightBorder = [YYTextBorder borderWithFillColor:[UIColor whPeterRiver] cornerRadius:3];
    YYTextHighlight *hightlight = [YYTextHighlight new];
    [hightlight setColor:[UIColor whiteColor]];
    [hightlight setBackgroundBorder:hightlightBorder];
    __weak typeof(self) weakSelf = self;
    hightlight.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        [weakSelf showWebView];
    };
    [attributeString yy_setTextHighlight:hightlight range:[kAboutString rangeOfString:@"wongkoo"]];
    
    //underLine of wongkoo
    [attributeString yy_setUnderlineColor:[UIColor blackColor] range:[kAboutString rangeOfString:@"wongkoo"]];
    [attributeString yy_setUnderlineStyle:NSUnderlineStyleSingle range:[kAboutString rangeOfString:@"wongkoo"]];
    
    //Font of Jobs
    [attributeString yy_setFont:[UIFont systemFontOfSize:30] range:[kAboutString rangeOfString:@"Jobs"]];
    
    //TextLabel
    self.textLabel = [[YYLabel alloc] initWithFrame:CGRectMake(kYYLabelOffset, self.logoView.bottom, self.view.width - 2 * kYYLabelOffset, kYYLabelHeight)];
    self.textLabel.attributedText = attributeString;
    self.textLabel.numberOfLines = 0;
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.textLabel];
    [self.textLabel.layer pop_addAnimation:[self createScaleXYPOPSpringAnimation] forKey:@"TextLabelZoomInSringAnimation"];
}

- (void)initCloseButton {
    self.closeButton = [[UIButton alloc] initWithFrame:CGRectMake(self.logoView.right - kCloseButtonWidth/2, self.logoView.top - kCloseButtonWidth/2, kCloseButtonWidth, kCloseButtonWidth)];
    self.closeButton.layer.cornerRadius = 15;
    self.closeButton.backgroundColor = [UIColor whAlizarin];
    [self.closeButton setTitle:@"✕" forState:UIControlStateNormal];
    [self.closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(closeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.closeButton];
    [self.closeButton.layer pop_addAnimation:[self createScaleXYPOPSpringAnimation] forKey:@"CloseButtonZoomInSpringAnimation"];
}



#pragma mark - Action

- (void)closeButtonAction {
    if (self.webViewOpen) {
        [self hideWebView];
    }else{
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (void)moveCloseButton {
    [self.view bringSubviewToFront:self.closeButton];
    if (self.webViewOpen) {
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
        anim.toValue = [NSValue valueWithCGPoint:CGPointMake(self.logoView.right, self.logoView.top)];
        anim.springBounciness = 10;
        anim.springSpeed = 20;
        [self.closeButton.layer pop_addAnimation:anim forKey:@"CloseButtonMoveOriginSpringAnimation"];
    }else {
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
        anim.toValue = [NSValue valueWithCGPoint:CGPointMake(self.view.width - kCloseButtonWidth/2, 20 + kCloseButtonWidth/2)];
        anim.springBounciness = 10;
        anim.springSpeed = 20;
        [self.closeButton.layer pop_addAnimation:anim forKey:@"CloseButtonMoveTopSpringAnimation"];
    }
    self.webViewOpen = !self.webViewOpen;
}

- (void)showWebView {
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(kCloseButtonWidth/2, 20 + kCloseButtonWidth/2, self.view.width - kCloseButtonWidth, self.view.height - 40 - kCloseButtonWidth/2)];
    [self.view addSubview:self.webView];
    
    POPSpringAnimation *animation = [self createScaleXYPOPSpringAnimation];
    animation.completionBlock = ^(POPAnimation *anim, BOOL finished){
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:kAboutMeURL]]];
    };
    [self.webView.layer pop_addAnimation:animation forKey:@"WebViewZoomInSpringAnimation"];
    
    POPBasicAnimation *basicAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    basicAnim.duration = 0.3;
    basicAnim.toValue = @1.0;
    [self.webView.layer pop_addAnimation:basicAnim forKey:@"WebViewOpacityBasicAnimation"];
    
    [self moveCloseButton];
}

- (void)hideWebView {
    
    POPSpringAnimation *springAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    springAnim.springBounciness = 10;
    springAnim.springSpeed = 20;
    springAnim.fromValue = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
    springAnim.toValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
    springAnim.completionBlock = ^(POPAnimation *anim, BOOL finished){
        [self.webView removeFromSuperview];
        self.webView = nil;
    };
    [self.webView.layer pop_addAnimation:springAnim forKey:@"WebViewZoomOutSpringAnimation"];
    
    [self moveCloseButton];
}



#pragma mark - returnPOPAnimation

- (POPSpringAnimation *)createScaleXYPOPSpringAnimation {
    POPSpringAnimation *springAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    springAnim.springBounciness = 10;
    springAnim.springSpeed = 20;
    springAnim.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
    springAnim.toValue = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
    return springAnim;
}


@end
