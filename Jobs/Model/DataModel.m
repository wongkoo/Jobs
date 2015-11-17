//
//  DataModel.m
//  Jobs
//
//  Created by 王振辉 on 15/6/6.
//  Copyright (c) 2015年 王振辉. All rights reserved.
//

#import "DataModel.h"
#import "JobList.h"
#import "JobsItem.h"

@implementation DataModel

+ (NSInteger)nextJobsItemId {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger itemLd = [userDefaults integerForKey:@"JobsItemId"];
    [userDefaults setInteger:itemLd + 1 forKey:@"JobsItemId"];
    [userDefaults synchronize];
    return itemLd;
}

- (NSInteger)numberOfDisDeletedJobsList {
    NSInteger disDeletedNum=0;
    for(JobList *jobListTemp in self.jobs){
        if (jobListTemp.deletedFlag == 0) {
            disDeletedNum ++;
        }
    }
    return disDeletedNum;
}

- (NSInteger)numberOfUncheckedJobsItem {
    NSInteger tempNum = 0;
    for (JobList *jobList in self.jobs){
        if(jobList.deletedFlag == 0){
            for(JobsItem *jobsItem in jobList.items){
                if (jobsItem.checked == 0) {
                    tempNum ++;
                }
            }
        }
    }
    return tempNum;
}

- (void)cancelLocalNotificationIndexOfJobs:(NSInteger)index {
    JobList *jobList = self.jobs[index];
    for (JobsItem *temp in jobList.items){
        if (temp.shouldRemind == YES) {
            UILocalNotification *existingNotification = [temp notificationForThisItem];
            if (existingNotification != nil) {
                [[UIApplication sharedApplication]cancelLocalNotification:existingNotification];
            }
        }
    }
}

- (void)registerDefaults {
//    NSDictionary *dictionary = @{@"JobIndex":@-1,@"FirstTime":@YES,@"JobsItemId":@0};
//    [[NSUserDefaults standardUserDefaults]registerDefaults:dictionary];
    [self setBOOLforPerformActionForShortcutItem:NO];
}

- (void)setBOOLforPerformActionForShortcutItem:(BOOL)bl {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:bl forKey:@"PerformActionForShortcutItem"];
}

- (void)handleFirstTime {
//    BOOL firstTime = [[NSUserDefaults standardUserDefaults]boolForKey:@"FirstTime"];
//    if(firstTime){
//        JobList *jobList = [[JobList alloc]init];
//        jobList.name = @"List";
//        [self.jobs addObject:jobList];
//        [self setIndexOfSelectedJobList:0];
//        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"FirstTime"];
//    }
}

- (id)init {
    if ((self = [super init])) {
        [self loadJobs];
        [self updateShouldRemind];
        [self registerDefaults];
//        [self handleFirstTime];
    }
    return self;
}

- (void)updateShouldRemind {
    for (JobList *jobList in self.jobs){
        for (JobsItem *jobsItem in jobList.items) {
            if (jobsItem.shouldRemind == YES && [jobsItem.dueDate timeIntervalSinceNow] <= 0) {
                    jobsItem.shouldRemind = NO;
            }
        }
    }
}

- (NSInteger)indexOfSelectedJobList {
    return [[NSUserDefaults standardUserDefaults]integerForKey:@"JobIndex"];
}

- (void)setIndexOfSelectedJobList:(NSInteger)index {
    [[NSUserDefaults standardUserDefaults]setInteger:index forKey:@"JobIndex"];
}

- (NSString *)documentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    return documentsDirectory;
}

-(NSString *)dataFilePath {
    return [[self documentsDirectory]stringByAppendingPathComponent:@"JobsV20151111.plist"];
}

- (void)saveJobs {
    NSMutableData *data = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:_jobs forKey:@"Jobs"];
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];
}

- (void)loadJobs {
    NSString *path = [self dataFilePath];
    if ([[NSFileManager defaultManager]fileExistsAtPath:path]) {
        NSData *data = [[NSData alloc]initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
        self.jobs = [unarchiver decodeObjectForKey:@"Jobs"];
        [unarchiver finishDecoding];
    }else{
        self.jobs = [[NSMutableArray alloc]initWithCapacity:10];
    }
}

@end
