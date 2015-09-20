//
//  AddProcessView.h
//  Jobs
//
//  Created by 王振辉 on 15/9/17.
//  Copyright © 2015年 王振辉. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddProcessViewDelegate <NSObject>
- (void)addProcrssViewDidSavedWithString:(NSString *)string Date:(NSDate *)date;
- (void)cancel;
@end

@interface AddProcessView : UIView <UITextFieldDelegate>
@property (nonatomic, strong)   NSDate *date;
@property (nonatomic, copy)     NSString *string;
@property (nonatomic, weak) id <AddProcessViewDelegate> delegate;

@end
