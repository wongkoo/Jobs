//
//  JobList.m
//  Jobs
//
//  Created by 王振辉 on 15/6/5.
//  Copyright (c) 2015年 王振辉. All rights reserved.
//

#import "JobList.h"

@implementation JobList

-(id)init{
    if((self = [super init])){
        self.items =[[NSMutableArray alloc] initWithCapacity:20];
    }
    return self;
}

@end

