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

#import <ShareSDK/NSMutableDictionary+SSDKShare.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

static const CGFloat kCrossButtonWidth = 30;

@interface ShareViewController ()
@property (nonatomic, strong) UIImageView *sharedImageView;
@end

@implementation ShareViewController

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whBelizeHole];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(-self.view.frame.size.width, 50, self.view.frame.size.width - 40, self.view.frame.size.height - 200)];
    
    [self.view addSubview:scrollView];
    
    _sharedImageView = [[UIImageView alloc] initWithImage:self.sharedImage];
    _sharedImageView.contentMode = UIViewContentModeScaleAspectFit;
    _sharedImageView.clipsToBounds = YES;
    [scrollView addSubview:_sharedImageView];
    [_sharedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(scrollView);
        make.width.equalTo(scrollView);
    }];
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width - 40, _sharedImageView.frame.size.height);

    UIButton *crossButton = [[UIButton alloc] init];
    crossButton.backgroundColor = [UIColor redColor];
    [crossButton setTitle:@"✕" forState:UIControlStateNormal];
    crossButton.layer.cornerRadius = kCrossButtonWidth/2;
    [crossButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:crossButton];
    [crossButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scrollView.mas_right).offset(-kCrossButtonWidth/2);
        make.bottom.equalTo(scrollView.mas_top).offset(kCrossButtonWidth/2);
        make.width.height.equalTo(@(kCrossButtonWidth));
    }];
    
    UIButton *sharedButton = [[UIButton alloc] initWithFrame:CGRectMake(-self.view.frame.size.width, self.view.frame.size.height - 100, self.view.frame.size.width - 40, 50)];
    sharedButton.layer.cornerRadius = 5;
    sharedButton.backgroundColor = [UIColor redColor];
    [sharedButton setTitle:@"分享到微信朋友圈" forState:UIControlStateNormal];
    [sharedButton addTarget:self action:@selector(shareWechat) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sharedButton];
    
    [UIView animateWithDuration:1 delay:0.0 usingSpringWithDamping:0.4 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        scrollView.frame = CGRectMake(20, 50, self.view.frame.size.width - 40, self.view.frame.size.height - 200);
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
    
    
    [UIView animateWithDuration:1 delay:0.1 usingSpringWithDamping:0.4 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        sharedButton.frame = CGRectMake(20, self.view.frame.size.height - 100, self.view.frame.size.width - 40, 50);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)shareWechat {

    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];

    [shareParams SSDKSetupShareParamsByText:@"By Jobs"
                                     images:self.sharedImage
                                        url:[NSURL URLWithString:@"https://itunes.apple.com/us/app/jobs/id1016317328?l=zh&ls=1&mt=8"]
                                      title:@"Jobs"
                                       type:SSDKContentTypeImage];
    
    [shareParams SSDKSetupWeChatParamsByText:@"My Jobs."
                                       title:@"Jobs"
                                         url:[NSURL URLWithString:@"https://itunes.apple.com/us/app/jobs/id1016317328?l=zh&ls=1&mt=8"]
                                  thumbImage:nil
                                       image:self.sharedImage
                                musicFileURL:nil
                                     extInfo:nil
                                    fileData:nil
                                emoticonData:nil
                                        type:SSDKContentTypeImage
                          forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
    
    [ShareSDK share:SSDKPlatformSubTypeWechatTimeline
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                     message:nil
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 break;
             }
             case SSDKResponseStateFail:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                     message:[NSString stringWithFormat:@"%@", error]
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 break;
             }
             case SSDKResponseStateCancel:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                                                                     message:nil
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 break;
             }
             default:
                 break;
         }
         
     }];
    
}
- (void)close {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    self.finishBlock();
}

@end
