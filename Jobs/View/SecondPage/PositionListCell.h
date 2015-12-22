//
//  PositionListCell.h
//  Jobs
//
//  Created by 锤石 on 15/12/22.
//  Copyright © 2015年 王振辉. All rights reserved.
//

#import <MCSwipeTableViewCell/MCSwipeTableViewCell.h>
#import "JobsItem.h"

@interface PositionListCell : MCSwipeTableViewCell

@property (nonatomic, strong) JobsItem *position;
@property (nonatomic, copy) MCSwipeCompletionBlock deleteCompletionBlock;
@property (nonatomic, copy) MCSwipeCompletionBlock editCompletionBlock;

+ (NSString *)reuseIdentifier;
+ (CGFloat)cellHeight;
- (void)reloadData;

@end
