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

@interface AppDelegate ()
@end

@implementation AppDelegate{
    DataModel *_dataModel;
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
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
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


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)saveData{
    [_dataModel saveJobs];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self saveData];
    NSInteger tempNum = 0;
    for (JobList *jobList in _dataModel.jobs){
        if(jobList.deletedFlag == 0){
            for(JobsItem *jobsItem in jobList.items){
                if (jobsItem.checked == 0) {
                    tempNum ++;
                }
            }
        }
    }
    [application setApplicationIconBadgeNumber:tempNum];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [self saveData];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
