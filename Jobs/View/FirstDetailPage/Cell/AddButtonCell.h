//
//  AddButtonCell.h
//  Jobs
//
//  Created by 王振辉 on 15/9/20.
//  Copyright © 2015年 王振辉. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddButtonCell : UITableViewCell
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIButton *sortButton;

+ (NSString *)reuseIdentifier;
@end
