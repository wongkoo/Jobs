//
//  JobsItem.h
//  Jobs
//
//  Created by 王振辉 on 15/6/3.
//  Copyright (c) 2015年 王振辉. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JobsItem : NSObject<NSCoding>

@property (nonatomic,copy) NSString *text;
@property (nonatomic,assign) BOOL checked;
-(void)toggleChecked;
@end
