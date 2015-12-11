//
//  JobList.m
//  Jobs
//
//  Created by 王振辉 on 15/6/5.
//  Copyright (c) 2015年 王振辉. All rights reserved.
//

#import "JobList.h"
#import "JobsItem.h"
#import "DateAndProcess.h"

@interface JobList () <NSCoding, NSCopying>
@end
@implementation JobList

- (id)init {
    if((self = [super init])) {
        self.items =[[NSMutableArray alloc] initWithCapacity:20];
        self.process = [[NSMutableArray alloc] initWithCapacity:3];
        self.deletedFlag = 0;
    }
    return self;
}

- (int)countUncheckedItems {
    int count =0;
    for(JobsItem *item in self.items){
        if (!item.checked) {
            count+=1;
        }
    }
    return count;
}



#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super init])) {
        self.name = [aDecoder decodeObjectForKey:@"Name"];
        self.items = [aDecoder decodeObjectForKey:@"Items"];
        self.accountOfWebsite = [aDecoder decodeObjectForKey:@"AccountOfWebsite"];
        self.reminderOfPassword = [aDecoder decodeObjectForKey:@"ReminderOfPassword"];
        self.email = [aDecoder decodeObjectForKey:@"Email"];
        self.process = [aDecoder decodeObjectForKey:@"Process"];
        self.deletedFlag = [aDecoder decodeBoolForKey:@"DeletedFlag"];
        self.addPositionBy3DTouch = [aDecoder decodeBoolForKey:@"AddPositionBy3DTouch"];
        self.cellColor = [aDecoder decodeIntegerForKey:@"CellColor"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"Name"];
    [aCoder encodeObject:self.items forKey:@"Items"];
    [aCoder encodeObject:self.accountOfWebsite forKey:@"AccountOfWebsite"];
    [aCoder encodeObject:self.reminderOfPassword forKey:@"ReminderOfPassword"];
    [aCoder encodeObject:self.email forKey:@"Email"];
    [aCoder encodeObject:self.process forKey:@"Process"];
    [aCoder encodeBool:self.deletedFlag forKey:@"DeletedFlag"];
    [aCoder encodeBool:self.addPositionBy3DTouch forKey:@"AddPositionBy3DTouch"];
    [aCoder encodeInteger:self.cellColor forKey:@"CellColor"];
}



#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    JobList *copyJobList = [[JobList alloc] init];
    copyJobList.name = self.name;
    copyJobList.accountOfWebsite = self.accountOfWebsite;
    copyJobList.reminderOfPassword = self.reminderOfPassword;
    copyJobList.email = self.email;
    copyJobList.deletedFlag = self.deletedFlag;
    copyJobList.addPositionBy3DTouch = self.addPositionBy3DTouch;
    copyJobList.cellColor = self.cellColor;
    copyJobList.items = [[NSMutableArray alloc] initWithArray:self.items copyItems:YES];
    copyJobList.process = [[NSMutableArray alloc] initWithArray:self.process copyItems:YES];
    return copyJobList;
}


@end

