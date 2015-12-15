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
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *timeButton;
@property (nonatomic, strong) UIButton *saveButton;
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
    
    
    
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(_dialogBackground.frame.size.width/6,
                                                              _dialogBackground.bounds.size.height/7,
                                                              _dialogBackground.bounds.size.width*2/3,
                                                              40)];
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField.placeholder = NSLocalizedString(@"AddProcessView Fill in process", @"填写流程");
    _textField.delegate = self;
    [_dialogBackground addSubview:_textField];

    _timeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _timeButton.frame = CGRectMake(_dialogBackground.bounds.size.width/2 -_dialogBackground.bounds.size.width/4,
                                   _dialogBackground.bounds.size.height/2,
                                   _dialogBackground.bounds.size.width/2,
                                   30);
    [_timeButton setTitle:NSLocalizedString(@"AddProcessView Date*", @"*日期（可选）") forState:UIControlStateNormal];
    [_timeButton addTarget:self action:@selector(showDatePicker) forControlEvents:UIControlEventTouchUpInside];
    [_dialogBackground addSubview:_timeButton];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(_dialogBackground.bounds.origin.x + _dialogBackground.bounds.size.width/6,
                                    _dialogBackground.bounds.size.height * 5/6,
                                    _dialogBackground.bounds.size.width/4,
                                    40);
    cancelButton.backgroundColor = [UIColor grayColor];
    [cancelButton setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
    cancelButton.layer.cornerRadius = 5;
    [cancelButton setTitle: NSLocalizedString(@"AddProcessView Cancel", @"Cancel") forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [_dialogBackground addSubview:cancelButton];
    
    _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _saveButton.frame = CGRectMake(_dialogBackground.bounds.size.width/2 +_dialogBackground.bounds.size.width/12,
                                   _dialogBackground.bounds.size.height *5/6,
                                   _dialogBackground.bounds.size.width/4,
                                   40);
    _saveButton.backgroundColor = [UIColor grayColor];
    [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _saveButton.layer.cornerRadius = 5;
    [_saveButton setTitle:NSLocalizedString(@"AddProcessView Save", @"Save") forState:UIControlStateNormal];
    [_saveButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    _saveButton.enabled = NO;
    [_dialogBackground addSubview:_saveButton];
    
}

#pragma mark - ReWrite Setter
- (void)setString:(NSString *)string {
    _string = [string copy];
    _textField.text = _string;
    if (string.length > 0) {
        _saveButton.enabled = YES;
    }
}

- (void)setDate:(NSDate *)date {
    if (date != NULL) {
        [self showDatePicker];
    }
    _date = date;
    [_datePicker setDate:date animated:YES];
}

#pragma mark - Action
- (void)showDatePicker {
    _timeButton.hidden = YES;
    [self endEditing:YES];
    
    _datePicker = [[UIDatePicker alloc]init];
    _datePicker.frame = CGRectMake(_dialogBackground.bounds.origin.x,
                                   _textField.frame.origin.y + _textField.frame.size.height,
                                   _dialogBackground.frame.size.width,
                                   _saveButton.frame.origin.y - _textField.frame.origin.y - _textField.frame.size.height);
    _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    _datePicker.alpha = 0;
    [_dialogBackground addSubview:_datePicker];
    
    UIButton *close = [UIButton buttonWithType:UIButtonTypeSystem];
    close.frame = CGRectMake(_datePicker.frame.origin.x +_datePicker.frame.size.width - 20,
                             _datePicker.frame.origin.y,
                             20,
                             20);
    [close addTarget:self action:@selector(closeDatePicker:) forControlEvents:UIControlEventTouchUpInside];
    [close setBackgroundImage:[UIImage imageNamed:@"cross"] forState:UIControlStateNormal];
    close.alpha = 1.0;
    [_dialogBackground addSubview:close];
    
    [UIView animateWithDuration:0.4
                     animations:^(void){
                         _datePicker.alpha = 1.0;
                         close.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    
}

- (void)closeDatePicker:(UIButton *)button {
    [UIView animateWithDuration:0.4
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         button.alpha = 0;
                         _datePicker.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [button removeFromSuperview];
                         [_datePicker removeFromSuperview];
                     }];
    
    _datePicker = nil;
    _timeButton.hidden = NO;
}

- (void)cancel {
    [UIView animateWithDuration:0.4
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                        [self removeFromSuperview];
                     }];
    
    [self.delegate addProcrssViewDidCancel];
}

- (void)save {
    [UIView animateWithDuration:0.4
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
    
    [self.delegate addProcrssViewDidSavedWithString:_textField.text Date:_datePicker.date Index:_index];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    _saveButton.enabled = ([newText length]>0);
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self endEditing:YES];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    _saveButton.enabled = NO;
    return YES;
}

@end
