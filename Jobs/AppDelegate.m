//
//  AppDelegate.m
//  Jobs
//
//  Created by 王振辉 on 15/6/3.
//  Copyright (c) 2015年 王振辉. All rights reserved.
//

#import "AppDelegate.h"
#import "CompanyListViewController.h"
#import "DataModel.h"
#import "JobList.h"
#import "JobsItem.h"
#import "IntroPageViewController.h"
#import "ShadowNavController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "WXApi.h"

static NSString * const WechatAppID = @"wxa3f12a36193aaecf";
static NSString * const WechatAppSecret = @"abea2564dc23436212b01036d53c21fa";

@interface AppDelegate ()
@property (nonatomic, strong) DataModel *dataModel;
@end

@implementation AppDelegate

+ (AppDelegate *)sharedInstance {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void(^)(BOOL succeeded))completionHandler NS_AVAILABLE_IOS(9_0) {
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]){
        return;
    }
    
    if([shortcutItem.type isEqualToString:@"AddJobList"]){
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UINavigationController *navigationController = [storyBoard instantiateViewControllerWithIdentifier:@"FirstNavigationController"];
        CompanyListViewController *controller = navigationController.viewControllers[0];
        self.window.rootViewController = navigationController;
        [controller performSegueWithIdentifier:@"AddJobList" sender:nil];
    }
    [self.dataModel setBOOLforPerformActionForShortcutItem:YES];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self registerShareSDK];
    
    UIApplicationShortcutItem *item = [launchOptions valueForKey:UIApplicationLaunchOptionsShortcutItemKey];
    if (item) {
        NSLog(@"We've launched from shortcut item: %@", item.localizedTitle);
    } else {
        NSLog(@"We've launched properly.");
    }
    
    float sysVersion=[[UIDevice currentDevice]systemVersion].floatValue;
    if (sysVersion>=8.0) {
        UIUserNotificationType type=UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound;
        UIUserNotificationSettings *setting=[UIUserNotificationSettings settingsForTypes:type categories:nil];
        [[UIApplication sharedApplication]registerUserNotificationSettings:setting];
    }

    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        IntroPageViewController *introPageViewController = [[IntroPageViewController alloc]init];
        self.window.rootViewController = introPageViewController;
    }else{
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UINavigationController *navigationController = [storyBoard instantiateViewControllerWithIdentifier:@"FirstNavigationController"];
        self.window.rootViewController = navigationController;
    }
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self.dataModel saveJobs];
    [application setApplicationIconBadgeNumber:[self.dataModel numberOfUncheckedJobsItem]];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [self.dataModel saveJobs];
    [application setApplicationIconBadgeNumber:[self.dataModel numberOfUncheckedJobsItem]];
}

- (void)registerShareSDK {
    [ShareSDK registerApp:@"cfd0b3db4733"
          activePlatforms:@[@(SSDKPlatformSubTypeWechatTimeline),
                            @(SSDKPlatformSubTypeWechatSession),@(SSDKPlatformTypeWechat)]
                 onImport:^(SSDKPlatformType platformType) {
                     switch (platformType) {
                         case SSDKPlatformTypeWechat:
                             [ShareSDKConnector connectWeChat:[WXApi class]];
                             break;
                             
                         default:
                             break;
                     }
                 }

          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
              switch (platformType) {
                  case SSDKPlatformTypeWechat:
                      [appInfo SSDKSetupWeChatByAppId:WechatAppID appSecret:WechatAppSecret];
                      break;
                      
                  default:
                      break;
              }
          }];
}

- (ShadowNavController *)currentNavigationController {
    UIViewController *rootController = [UIApplication sharedApplication].keyWindow.rootViewController;
    ShadowNavController *nav = nil;
    if ([rootController isKindOfClass:[ShadowNavController class]]) {
        nav = (ShadowNavController *)rootController;
    } else if ([rootController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabbarController = (UITabBarController *)rootController;
        if ([tabbarController.selectedViewController isKindOfClass:[ShadowNavController class]]) {
            nav = (ShadowNavController *)tabbarController.selectedViewController;
        }
    }
    if (nav.topViewController.presentedViewController) {
        UIViewController *presentedVC = nav.topViewController.presentedViewController;
        if ([presentedVC isKindOfClass:[ShadowNavController class]]) {
            nav = (ShadowNavController *)presentedVC;
        }
    }
    return nav;
}



#pragma mark - Getter 

- (DataModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [DataModel sharedInstance];
    }
    return _dataModel;
}

@end
