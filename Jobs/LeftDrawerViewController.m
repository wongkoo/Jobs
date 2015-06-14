//
//  LeftDrawerViewController.m
//  Jobs
//
//  Created by 王振辉 on 15/6/13.
//  Copyright (c) 2015年 王振辉. All rights reserved.
//

#import "LeftDrawerViewController.h"

@interface LeftDrawerViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textiew;
@property (weak, nonatomic) IBOutlet UISwitch *textSwitch;

@end

@implementation LeftDrawerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.textiew.layer setCornerRadius:10];
    CGRect textFrame= CGRectMake(16, 61, 245, 391);
    self.textiew.frame = textFrame;
    self.textiew.editable = NO;
    self.textiew.scrollEnabled = YES;
    self.textiew.layoutManager.allowsNonContiguousLayout = NO;
    self.textSwitch.onTintColor = [UIColor colorWithRed:107.0/255.0 green:163.0/255.0 blue:187.0/255.0 alpha:1];
    self.textSwitch.on = NO;
    //注册通知,监听键盘弹出事件
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    //注册通知,监听键盘消失事件
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHidden:) name:UIKeyboardDidHideNotification object:nil];

    // Do any additional setup after loading the view.
}
- (IBAction)textSwitch:(id)sender {
    if (self.textSwitch.on == YES) {
        self.textiew.editable = YES;
        [self.textiew becomeFirstResponder];
    }else{
        self.textiew.editable = NO;
    }
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    //self.textiew.bounds.size.height = self.
    CGRect rect = self.textiew.bounds;
    rect.size.height = 100;
    self.textiew.bounds = rect;
    return YES;
}

- (void)keyboardDidShow:(NSNotification *)aNotification{
    CGRect textFrame= CGRectMake(16, 61, 245, 230);
    self.textiew.frame = textFrame;
}

- (void)keyboardDidHidden:(NSNotification *)aNotification{
    CGRect textFrame= CGRectMake(16, 61, 245, 391);
    self.textiew.frame = textFrame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
