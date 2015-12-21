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

@interface AboutViewController ()
@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) YYLabel *textLabel;
@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whBelizeHole];
    [self initLogo];
    [self initTextView];
    [self initTapAction];
}

- (void)initLogo {
    self.logoView = [[UIImageView alloc] init];
    UIImage *logo = [UIImage imageNamed:@"icon400"];
    self.logoView.layer.cornerRadius = 10;
    self.logoView.image = logo;
    [self.view addSubview:self.logoView];
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view.mas_top).offset(self.view.frame.size.height * (1-0.618));
        make.width.height.equalTo(@80);
    }];
}

- (void)initTextView {
    
    NSString *string = @"Jobs\n \nFor you. For the future.\n \nDesigned by wongkoo.";
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:string];
    
    //highlight
    YYTextBorder *hightlightBorder = [YYTextBorder borderWithFillColor:[UIColor whPeterRiver] cornerRadius:3];
    YYTextHighlight *hightlight = [YYTextHighlight new];
    [hightlight setColor:[UIColor whiteColor]];
    [hightlight setBackgroundBorder:hightlightBorder];
    hightlight.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        NSLog(@"tap text range");
    };
    [attributeString yy_setTextHighlight:hightlight range:[string rangeOfString:@"wongkoo"]];
    
    //underLine of wongkoo
    [attributeString yy_setUnderlineColor:[UIColor blackColor] range:[string rangeOfString:@"wongkoo"]];
    [attributeString yy_setUnderlineStyle:NSUnderlineStyleSingle range:[string rangeOfString:@"wongkoo"]];
    
    //Font of Jobs
    [attributeString yy_setFont:[UIFont systemFontOfSize:30] range:[string rangeOfString:@"Jobs"]];
    
    //TextLabel
    self.textLabel = [YYLabel new];
    self.textLabel.attributedText = attributeString;
    self.textLabel.numberOfLines = 0;
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.textLabel];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoView.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.view).offset(-40);
        make.height.equalTo(@100);
    }];
}

- (void)initTapAction {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popSelf)];
    [self.view addGestureRecognizer:tap];
}

- (void)popSelf {
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
