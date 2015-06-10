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
        self.deletedFlag = 0;
        self.iconName = @"Appointments";
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
        self.iconName = [aDecoder decodeObjectForKey:@"IconName"];
        self.deletedFlag = [aDecoder decodeIntegerForKey:@"DeletedFlag"];
//耻辱！！！！！！
//        self.name = [aDecoder decodeObjectForKey:@"Name"];
//        self.name = [aDecoder decodeObjectForKey:@"Items"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.name forKey:@"Name"];
    [aCoder encodeObject:self.items forKey:@"Items"];
    [aCoder encodeObject:self.iconName forKey:@"IconName"];
    [aCoder encodeInteger:self.deletedFlag forKey:@"DeletedFlag"];
}

@end

