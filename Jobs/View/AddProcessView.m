//
//  AddProcessView.m
//  Jobs
//
//  Created by 王振辉 on 15/9/17.
//  Copyright © 2015年 王振辉. All rights reserved.
//

#import "AddProcessView.h"

@interface AddProcessView ()
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIButton *timeButton;
@end

@implementation AddProcessView


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self defaultInit];
    }
    
    return self;
}

- (void)defaultInit {
    
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(self.bounds.origin.x + self.frame.size.width/6, self.bounds.size.height/6 -15, self.bounds.size.width*2/3, 40)];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //textField.backgroundColor = [UIColor blueColor];
    textField.placeholder = @"填写流程";
    
    [self addSubview:textField];

    _timeButton = [[UIButton alloc]initWithFrame:CGRectMake(self.bounds.size.width/2 -self.bounds.size.width/8, self.bounds.size.height/2, self.bounds.size.width/4, 30)];
    [_timeButton setTitle:@"Time(Optional)" forState:UIControlStateNormal];
    [_timeButton addTarget:self action:@selector(showDatePicker) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_timeButton];
    
    
    self.backgroundColor = [UIColor lightTextColor];
    

    
}

- (void)showDatePicker {
    [_timeButton removeFromSuperview];
    _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.size.height/3, self.frame.size.width, self.frame.size.height/2)];
    _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [self addSubview:_datePicker];
}



@end
