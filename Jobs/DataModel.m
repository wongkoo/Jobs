//
//  DataModel.m
//  Jobs
//
//  Created by 王振辉 on 15/6/6.
//  Copyright (c) 2015年 王振辉. All rights reserved.
//

#import "DataModel.h"
#import "JobList.h"

@implementation DataModel

- (id)init{
    if ((self = [super init])) {
        [self loadJobs];
    }
    return self;
}

- (NSString *)documentsDirectory{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    return documentsDirectory;
}

-(NSString *)dataFilePath{
    return [[self documentsDirectory]stringByAppendingPathComponent:@"Jobs.plist"];
}

- (void)saveJobs{
    NSMutableData *data = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:_jobs forKey:@"Jobs"];
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];
}

- (void)loadJobs{
    NSString *path = [self dataFilePath];
    if ([[NSFileManager defaultManager]fileExistsAtPath:path]) {
        NSData *data = [[NSData alloc]initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
        self.jobs = [unarchiver decodeObjectForKey:@"Jobs"];
        [unarchiver finishDecoding];
    }else{
        self.jobs = [[NSMutableArray alloc]initWithCapacity:20];
    }
}

@end
