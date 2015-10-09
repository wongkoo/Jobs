//
//  JobList.m
//  Jobs
//
//  Created by 王振辉 on 15/6/5.
//  Copyright (c) 2015年 王振辉. All rights reserved.
//

#import "JobList.h"
#import "JobsItem.h"
@implementation JobList

-(id)init{
    if((self = [super init])){
        self.items =[[NSMutableArray alloc] initWithCapacity:20];
        self.process = [[NSMutableArray alloc] initWithCapacity:3];
        self.deletedFlag = 0;
    }
    return self;
}

- (int)countUncheckedItems{
    int count =0;
    for(JobsItem *item in self.items){
        if (!item.checked) {
            count+=1;
        }
    }
    return count;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if ((self = [super init])) {
        self.name = [aDecoder decodeObjectForKey:@"Name"];
        self.items = [aDecoder decodeObjectForKey:@"Items"];
        self.accountOfWebsite = [aDecoder decodeObjectForKey:@"AccountOfWebsite"];
        self.reminderOfPassword = [aDecoder decodeObjectForKey:@"ReminderOfPassword"];
        self.email = [aDecoder decodeObjectForKey:@"Email"];
        self.process = [aDecoder decodeObjectForKey:@"Process"];
        self.deletedFlag = [aDecoder decodeBoolForKey:@"DeletedFlag"];
        self.addPositionBy3DTouch = [aDecoder decodeBoolForKey:@"AddPositionBy3DTouch"];
//耻辱！！！！！！
//        self.name = [aDecoder decodeObjectForKey:@"Name"];
//        self.name = [aDecoder decodeObjectForKey:@"Items"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.name forKey:@"Name"];
    [aCoder encodeObject:self.items forKey:@"Items"];
    [aCoder encodeObject:self.accountOfWebsite forKey:@"AccountOfWebsite"];
    [aCoder encodeObject:self.reminderOfPassword forKey:@"ReminderOfPassword"];
    [aCoder encodeObject:self.email forKey:@"Email"];
    [aCoder encodeObject:self.process forKey:@"Process"];
    [aCoder encodeBool:self.deletedFlag forKey:@"DeletedFlag"];
    [aCoder encodeBool:self.addPositionBy3DTouch forKey:@"AddPositionBy3DTouch"];
}

@end

