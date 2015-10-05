//
//  CountdownView.h
//  Jobs
//
//  Created by 王振辉 on 15/10/5.
//  Copyright © 2015年 王振辉. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountdownView : UIView

@property (nonatomic, copy) NSString *companyNameString;
@property (nonatomic, copy) NSString *jobNameString;
@property (nonatomic, copy) NSString *nextTaskString;
@property (nonatomic, strong) NSDate *dueDate;

@end
