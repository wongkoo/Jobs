//
//  JobList.h
//  Jobs
//
//  Created by 王振辉 on 15/6/5.
//  Copyright (c) 2015年 王振辉. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JobList : NSObject<NSCoding>
@property (nonatomic,strong )NSMutableArray *items;
@property (nonatomic,copy   )NSString *name;

@property (nonatomic,copy   )NSString *accountOfWebsite;
@property (nonatomic,copy   )NSString *reminderOfPassword;
@property (nonatomic,copy   )NSString *email;

@property (nonatomic,assign )BOOL deletedFlag;
//@property (nonatomic,copy   )NSString *iconName;
- (int)countUncheckedItems;
@end
