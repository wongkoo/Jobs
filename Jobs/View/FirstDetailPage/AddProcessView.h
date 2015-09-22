//
//  AddProcessView.h
//  Jobs
//
//  Created by 王振辉 on 15/9/17.
//  Copyright © 2015年 王振辉. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddProcessViewDelegate <NSObject>
- (void)addProcrssViewDidSavedWithString:(NSString *)string Date:(NSDate *)date Index:(NSInteger)index;
- (void)addProcrssViewDidCancel;
@end

@interface AddProcessView : UIView <UITextFieldDelegate>
@property (nonatomic, strong)   NSDate *date;
@property (nonatomic, strong)   NSString *string;
@property (nonatomic, assign)   NSInteger index;
@property (nonatomic, weak)     id <AddProcessViewDelegate> delegate;

@end
