//
//  AllListsCompanyCell.h
//  Jobs
//
//  Created by 锤石 on 15/11/18.
//  Copyright © 2015年 王振辉. All rights reserved.
//

#import "MCSwipeTableViewCell.h"
#import "Company.h"

@interface CompanyListCell : MCSwipeTableViewCell

@property (nonatomic, strong) Company *company;
@property (nonatomic, copy) MCSwipeCompletionBlock editCompletetionBlock;
@property (nonatomic, copy) MCSwipeCompletionBlock stickCompletetionBlock;
@property (nonatomic, copy) MCSwipeCompletionBlock crossCompletetionBlock;
@property (nonatomic, copy) MCSwipeCompletionBlock checkCompletetionBlock;

+ (NSString *)reuseIdentifier;
- (void)reloadData;

@end
