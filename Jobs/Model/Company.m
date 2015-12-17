//
//  Company.m
//  Jobs
//
//  Created by 王振辉 on 15/6/5.
//  Copyright (c) 2015年 王振辉. All rights reserved.
//

#import "Company.h"
#import "JobsItem.h"
#import "DateAndProcess.h"

@interface Company () <NSCoding, NSCopying>
@end
@implementation Company

- (id)init {
    if((self = [super init])) {
        self.positions =[[NSMutableArray alloc] initWithCapacity:20];
        self.process = [[NSMutableArray alloc] initWithCapacity:3];
        self.deletedFlag = 0;
    }
    return self;
}

- (int)countUncheckedItems {
    int count =0;
    for(JobsItem *item in self.positions){
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
        self.positions = [aDecoder decodeObjectForKey:@"Positions"];
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
    [aCoder encodeObject:self.positions forKey:@"Positions"];
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
    Company *copyCompany = [[Company alloc] init];
    copyCompany.name = self.name;
    copyCompany.accountOfWebsite = self.accountOfWebsite;
    copyCompany.reminderOfPassword = self.reminderOfPassword;
    copyCompany.email = self.email;
    copyCompany.deletedFlag = self.deletedFlag;
    copyCompany.addPositionBy3DTouch = self.addPositionBy3DTouch;
    copyCompany.cellColor = self.cellColor;
    copyCompany.positions = [[NSMutableArray alloc] initWithArray:self.positions copyItems:YES];
    copyCompany.process = [[NSMutableArray alloc] initWithArray:self.process copyItems:YES];
    return copyCompany;
}


@end

