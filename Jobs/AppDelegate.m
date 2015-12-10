//
//  AppDelegate.m
//  Jobs
//
//  Created by 王振辉 on 15/6/3.
//  Copyright (c) 2015年 王振辉. All rights reserved.
//

#import "AppDelegate.h"
#import "AllListsViewController.h"
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
@end

@implementation AppDelegate{
    DataModel *_dataModel;
}

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
        AllListsViewController *controller = navigationController.viewControllers[0];
        controller.dataModel = _dataModel;
        self.window.rootViewController = navigationController;
        [controller performSegueWithIdentifier:@"AddJobList" sender:nil];
    }
    [_dataModel setBOOLforPerformActionForShortcutItem:YES];
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

    _dataModel = [[DataModel alloc]init];
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        IntroPageViewController *introPageViewController = [[IntroPageViewController alloc]init];
        introPageViewController._dataModel = _dataModel;
        self.window.rootViewController = introPageViewController;
    }else{
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UINavigationController *navigationController = [storyBoard instantiateViewControllerWithIdentifier:@"FirstNavigationController"];
        
        AllListsViewController *controller = navigationController.viewControllers[0];
        controller.dataModel = _dataModel;
        self.window.rootViewController = navigationController;
    }
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)createDynamicShortcutItems {
    
    UIApplicationShortcutIcon *icon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeAdd];
    
    // create several (dynamic) shortcut items
    UIApplicationShortcutItem *item1 = [[UIApplicationShortcutItem alloc]initWithType:@"Item 1" localizedTitle:@"Item 1"];
    UIApplicationShortcutItem *item2 = [[UIApplicationShortcutItem alloc]initWithType:@"Type2"
                                                                       localizedTitle:@"Hello"
                                                                    localizedSubtitle:@"Go hello"
                                                                                 icon:icon
                                                                             userInfo:NULL];
    
    // add all items to an array
    NSArray *items = @[item1, item2];
    
    // add the array to our app
    [UIApplication sharedApplication].shortcutItems = items;
}

- (void)saveData{
    [_dataModel saveJobs];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self saveData];
    [application setApplicationIconBadgeNumber:[_dataModel numberOfUncheckedJobsItem]];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [self saveData];
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

@end
