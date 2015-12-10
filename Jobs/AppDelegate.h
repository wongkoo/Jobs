//
//  AppDelegate.h
//  Jobs
//
//  Created by 王振辉 on 15/6/3.
//  Copyright (c) 2015年 王振辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EAIntroView/EAIntroView.h>
@class ShadowNavController;
@interface AppDelegate : UIResponder <UIApplicationDelegate,EAIntroDelegate>
@property (strong, nonatomic) UIWindow *window;

+ (AppDelegate *)sharedInstance;
- (ShadowNavController *)currentNavigationController;

@end

