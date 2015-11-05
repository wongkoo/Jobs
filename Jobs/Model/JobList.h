//
//  JobList.h
//  Jobs
//
//  Created by 王振辉 on 15/6/5.
//  Copyright (c) 2015年 王振辉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CellbackgroundVIew.h"

@interface JobList : NSObject<NSCoding>

@property (nonatomic, strong )NSMutableArray *items;
@property (nonatomic, copy   )NSString *name;
@property (nonatomic, copy   )NSString *accountOfWebsite;
@property (nonatomic, copy   )NSString *reminderOfPassword;
@property (nonatomic, copy   )NSString *email;
@property (nonatomic, strong )NSMutableArray *process;
@property (nonatomic, assign )BOOL deletedFlag;
@property (nonatomic, assign )BOOL addPositionBy3DTouch;
@property (nonatomic, assign )CellColor cellColor;

- (int)countUncheckedItems;

@end
