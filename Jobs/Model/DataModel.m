//
//  DataModel.m
//  Jobs
//
//  Created by 王振辉 on 15/6/6.
//  Copyright (c) 2015年 王振辉. All rights reserved.
//

#import "DataModel.h"
#import "Company.h"
#import "JobsItem.h"

@implementation DataModel

+ (DataModel *)sharedInstance {
    static DataModel *sharedDataModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDataModel = [[self alloc] init];
    });
    return sharedDataModel;
}

+ (NSInteger)nextJobsItemId {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger itemLd = [userDefaults integerForKey:@"JobsItemId"];
    [userDefaults setInteger:itemLd + 1 forKey:@"JobsItemId"];
    [userDefaults synchronize];
    return itemLd;
}

- (id)init {
    if ((self = [super init])) {
        [self loadJobs];
        [self updateShouldRemind];
        [self registerDefaults];
    }
    return self;
}

- (NSInteger)numberOfDisDeletedCompany {
    NSInteger disDeletedNum=0;
    for(Company *companyTemp in self.companyList){
        if (companyTemp.deletedFlag == 0) {
            disDeletedNum ++;
        }
    }
    return disDeletedNum;
}

- (NSInteger)numberOfUncheckedJobsItem {
    NSInteger tempNum = 0;
    for (Company *company in self.companyList){
        if(company.deletedFlag == 0){
            for(JobsItem *jobsItem in company.positions){
                if (jobsItem.checked == 0) {
                    tempNum ++;
                }
            }
        }
    }
    return tempNum;
}

- (void)cancelLocalNotificationIndexOfJobs:(NSInteger)index {
    Company *company = self.companyList[index];
    for (JobsItem *temp in company.positions){
        if (temp.shouldRemind == YES) {
            UILocalNotification *existingNotification = [temp notificationForThisItem];
            if (existingNotification != nil) {
                [[UIApplication sharedApplication]cancelLocalNotification:existingNotification];
            }
        }
    }
}

- (void)registerDefaults {
    [self setBOOLforPerformActionForShortcutItem:NO];
}

- (void)setBOOLforPerformActionForShortcutItem:(BOOL)bl {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:bl forKey:@"PerformActionForShortcutItem"];
}

- (void)updateShouldRemind {
    for (Company *company in self.companyList){
        for (JobsItem *jobsItem in company.positions) {
            if (jobsItem.shouldRemind == YES && [jobsItem.dueDate timeIntervalSinceNow] <= 0) {
                    jobsItem.shouldRemind = NO;
            }
        }
    }
}

- (NSInteger)indexOfSelectedCompany {
    return [[NSUserDefaults standardUserDefaults]integerForKey:@"JobIndex"];
}

- (void)setIndexOfSelectedCompany:(NSInteger)index {
    [[NSUserDefaults standardUserDefaults]setInteger:index forKey:@"JobIndex"];
}

- (NSString *)documentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    return documentsDirectory;
}

-(NSString *)dataFilePath {
    return [[self documentsDirectory]stringByAppendingPathComponent:@"JobsV20151217.plist"];
}

- (void)saveJobs {
    NSMutableData *data = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:_companyList forKey:@"Jobs"];
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];
}

- (void)loadJobs {
    NSString *path = [self dataFilePath];
    if ([[NSFileManager defaultManager]fileExistsAtPath:path]) {
        NSData *data = [[NSData alloc]initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
        self.companyList = [unarchiver decodeObjectForKey:@"Jobs"];
        [unarchiver finishDecoding];
    }else{
        self.companyList = [[NSMutableArray alloc]initWithCapacity:10];
    }
}

@end
