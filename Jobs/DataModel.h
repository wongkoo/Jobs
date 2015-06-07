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
+ (NSInteger)nextJobsItemId;
@end
