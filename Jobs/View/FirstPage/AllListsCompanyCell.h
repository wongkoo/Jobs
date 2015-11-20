//
//  AllListsCompanyCell.h
//  Jobs
//
//  Created by 锤石 on 15/11/18.
//  Copyright © 2015年 王振辉. All rights reserved.
//

#import "MCSwipeTableViewCell.h"
#import "JobList.h"

@interface AllListsCompanyCell : MCSwipeTableViewCell

@property (nonatomic, strong) JobList *jobList;
@property (nonatomic, copy) MCSwipeCompletionBlock listCompletetionBlock;
@property (nonatomic, copy) MCSwipeCompletionBlock stickCompletetionBlock;
@property (nonatomic, copy) MCSwipeCompletionBlock crossCompletetionBlock;
@property (nonatomic, copy) MCSwipeCompletionBlock checkCompletetionBlock;

- (void)reloadData;

@end
