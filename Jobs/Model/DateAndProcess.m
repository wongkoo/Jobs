//
//  DateAndProcess.m
//  Jobs
//
//  Created by 王振辉 on 15/9/20.
//  Copyright © 2015年 王振辉. All rights reserved.
//

#import "DateAndProcess.h"

@interface DateAndProcess ()<NSCoding, NSCopying>
@end
@implementation DateAndProcess



#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if( (self = [super init]) ) {
        self.string = [aDecoder decodeObjectForKey:@"String"];
        self.date = [aDecoder decodeObjectForKey:@"Date"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.string forKey:@"String"];
    [aCoder encodeObject:self.date forKey:@"Date"];
}



#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    DateAndProcess *copyDateAndProcess = [[DateAndProcess alloc] init];
    copyDateAndProcess.string = self.string;
    copyDateAndProcess.date = self.date;
    return copyDateAndProcess;
}

@end
