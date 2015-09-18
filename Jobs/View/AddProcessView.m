//
//  AddProcessView.m
//  Jobs
//
//  Created by 王振辉 on 15/9/17.
//  Copyright © 2015年 王振辉. All rights reserved.
//

#import "AddProcessView.h"

@interface AddProcessView () {
    CGFloat WIDTH;
    CGFloat HEIGHT;
}

@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIButton *timeButton;
@property (nonatomic, strong) UIView *dialogBackground;

@end

@implementation AddProcessView


- (id)init {
    self = [self initWithFrame:[UIScreen mainScreen].bounds];
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self defaultInit];
    }
    
    return self;
}

- (void)defaultInit {
    
    WIDTH = [UIScreen mainScreen].bounds.size.width;
    HEIGHT = [UIScreen mainScreen].bounds.size.height;
    
    UIView *background = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    background.backgroundColor = [UIColor grayColor];
    background.alpha = 0;
    [self addSubview:background];
    
    _dialogBackground = [[UIView alloc]initWithFrame:CGRectMake(WIDTH/10, HEIGHT/2 - HEIGHT/3, WIDTH*4/5, HEIGHT/2)];
    _dialogBackground.backgroundColor = [UIColor lightTextColor];
    _dialogBackground.layer.cornerRadius = 8;
    [self addSubview:_dialogBackground];
    
    self.alpha = 0.1;
    
    [UIView animateWithDuration:0.4
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         background.alpha = 1;
                         self.alpha = 1;
                     }
                     completion:^(BOOL finished) {}];
    
    
    
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(_dialogBackground.frame.size.width/6, _dialogBackground.bounds.size.height/7, _dialogBackground.bounds.size.width*2/3, 40)];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.placeholder = @"填写流程";
    [_dialogBackground addSubview:textField];

    _timeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _timeButton.frame = CGRectMake(_dialogBackground.bounds.size.width/2 -_dialogBackground.bounds.size.width/4, _dialogBackground.bounds.size.height/2, _dialogBackground.bounds.size.width/2, 30);
    [_timeButton setTitle:@"*Time(Optional)" forState:UIControlStateNormal];
    [_timeButton addTarget:self action:@selector(showDatePicker) forControlEvents:UIControlEventTouchUpInside];
    [_dialogBackground addSubview:_timeButton];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelButton.frame = CGRectMake(_dialogBackground.bounds.origin.x + _dialogBackground.bounds.size.width/6, _dialogBackground.bounds.size.height * 5/6, _dialogBackground.bounds.size.width/4, 40);
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [_dialogBackground addSubview:cancelButton];
    
    
}

- (void)showDatePicker {
    _timeButton.hidden = YES;
    _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(_dialogBackground.bounds.origin.x, _dialogBackground.bounds.size.height/3, _dialogBackground.frame.size.width, _dialogBackground.frame.size.height/2)];
    _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [_dialogBackground addSubview:_datePicker];
    
    UIButton *close = [UIButton buttonWithType:UIButtonTypeSystem];
    close.frame = CGRectMake(_datePicker.frame.origin.x +_datePicker.frame.size.width - 20, _datePicker.frame.origin.y, 20, 20);
    [close addTarget:self action:@selector(closeDatePicker:) forControlEvents:UIControlEventTouchUpInside];
    [close setBackgroundImage:[UIImage imageNamed:@"cross"] forState:UIControlStateNormal];
    [_dialogBackground addSubview:close];
    
}

- (void)cancel {
    [self removeFromSuperview];
}

- (void)closeDatePicker:(UIButton *)button {
    [button removeFromSuperview];
    [_datePicker removeFromSuperview];
    _timeButton.hidden = NO;
}


@end
