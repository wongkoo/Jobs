//
//  JobsItem.m
//  Jobs
//
//  Created by 王振辉 on 15/6/3.
//  Copyright (c) 2015年 王振辉. All rights reserved.
//

#import "JobsItem.h"

@implementation JobsItem


- (void)toggleChecked{
    self.checked = !self.checked;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if( (self = [super init]) ) {
        self.text = [aDecoder decodeObjectForKey:@"Text"];
        self.checked =[aDecoder decodeBoolForKey:@"Checked"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.text forKey:@"Text"];
    [aCoder encodeBool:self.checked forKey:@"Checked"];
}

@end
