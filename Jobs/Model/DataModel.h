//
//  DataModel.h
//  Jobs
//
//  Created by 王振辉 on 15/6/6.
//  Copyright (c) 2015年 王振辉. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModel : NSObject

@property(nonatomic, strong)NSMutableArray *jobs;

- (void)saveJobs;
- (NSInteger)indexOfSelectedJobList;
- (void)setIndexOfSelectedJobList:(NSInteger)index;
- (void)setBOOLforPerformActionForShortcutItem:(BOOL)bl; //为了解决 当前VC为ViewController，进入后台，再使用3Dtouch的Add Company后，无法跳转到第一页的情况。
- (NSInteger)numberOfUncheckedJobsItem;
- (NSInteger)numberOfDisDeletedJobsList;
- (void)cancelLocalNotificationIndexOfJobs:(NSInteger)index;
+ (NSInteger)nextJobsItemId;

@end
