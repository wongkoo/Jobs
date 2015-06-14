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
#import "JVFloatingDrawerViewController.h"
#import "JVFloatingDrawerSpringAnimator.h"
static NSString * const drawersStoryboardName = @"Main";
static NSString * const leftDrawerStoryboardID = @"LeftDrawerViewController";
static NSString * const firstNavigationControllerID = @"FirstNavigationController";
@interface AppDelegate ()
@property (nonatomic, strong, readonly) UIStoryboard *drawersStoryboard;
@end

@implementation AppDelegate{
    DataModel *_dataModel;
}
@synthesize drawersStoryboard = _drawersStoryboard;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    float sysVersion=[[UIDevice currentDevice]systemVersion].floatValue;
    if (sysVersion>=8.0) {
        UIUserNotificationType type=UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound;
        UIUserNotificationSettings *setting=[UIUserNotificationSettings settingsForTypes:type categories:nil];
        [[UIApplication sharedApplication]registerUserNotificationSettings:setting];
    }
//    else{
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
//    }
    _dataModel = [[DataModel alloc]init];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.drawerViewController;
    [self configureDrawerViewController];
    AllListsViewController *controller = self.firstNavigationController.viewControllers[0];
    controller.dataModel = _dataModel;
    [self.window makeKeyAndVisible];
    return YES;
}



- (void)configureDrawerViewController {
    self.drawerViewController.leftViewController = self.leftDrawerViewController;
    self.drawerViewController.centerViewController = self.firstNavigationController;
    self.drawerViewController.animator = self.drawerAnimator;
    self.drawerViewController.backgroundImage = [UIImage imageNamed:@"launch－background"];
}

#pragma mark - Drawer View Controllers

- (JVFloatingDrawerViewController *)drawerViewController {
    if (!_drawerViewController) {
        _drawerViewController = [[JVFloatingDrawerViewController alloc] init];
    }
    
    return _drawerViewController;
}

#pragma mark Sides

- (UINavigationController *)firstNavigationController {
    if (!_firstNavigationController) {
        _firstNavigationController = [self.drawersStoryboard instantiateViewControllerWithIdentifier:firstNavigationControllerID];
        self.firstNavigationController.navigationBar.layer.shadowColor = [UIColor blackColor].CGColor; //shadowColor阴影颜色
        self.firstNavigationController.navigationBar.layer.shadowOffset = CGSizeMake(2.0f , 2.0f); //shadowOffset阴影偏移x，y向(上/下)偏移(-/+)2
        self.firstNavigationController.navigationBar.layer.shadowOpacity = 0.25f;//阴影透明度，默认0
        self.firstNavigationController.navigationBar.layer.shadowRadius = 4.0f;//阴影半径
    }
    return _firstNavigationController;
}

- (UITableViewController *)leftDrawerViewController {
    if (!_leftDrawerViewController) {
        _leftDrawerViewController = [self.drawersStoryboard instantiateViewControllerWithIdentifier:leftDrawerStoryboardID];
    }
    
    return _leftDrawerViewController;
}



#pragma mark Center



- (JVFloatingDrawerSpringAnimator *)drawerAnimator {
    if (!_drawerAnimator) {
        _drawerAnimator = [[JVFloatingDrawerSpringAnimator alloc] init];
    }
    
    return _drawerAnimator;
}

- (UIStoryboard *)drawersStoryboard {
    if(!_drawersStoryboard) {
        _drawersStoryboard = [UIStoryboard storyboardWithName:drawersStoryboardName bundle:nil];
    }
    
    return _drawersStoryboard;
}



#pragma mark - Global Access Helper

+ (AppDelegate *)globalDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void)toggleLeftDrawer:(id)sender animated:(BOOL)animated {
    [self.drawerViewController toggleDrawerWithSide:JVFloatingDrawerSideLeft animated:animated completion:nil];
}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)saveData{
//    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
//    AllListsViewController *controller = navigationController.viewControllers[0];
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
