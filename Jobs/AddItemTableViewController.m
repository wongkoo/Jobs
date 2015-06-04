//
//  AddItemTableViewController.m
//  Jobs
//
//  Created by 王振辉 on 15/6/4.
//  Copyright (c) 2015年 王振辉. All rights reserved.
//

#import "AddItemTableViewController.h"
#import "JobsItem.h"
@interface AddItemTableViewController ()

@end

@implementation AddItemTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}


//3.让对象B在适当的时候向代理对象发送消息,⽐比如当⽤用户触碰cancel或done按钮时
- (IBAction)cancel:(id)sender {
    [self.delegate addItemTableViewControllerdidCancel:self];
   // [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)Save:(id)sender {
    NSLog(@"%@",self.textField.text);
    JobsItem *item = [[JobsItem alloc] init];
    item.text = self.textField.text;
    item.checked = NO;
    
    [self.delegate addItemTableViewController:self didFinishAddingItem:item];
  //  [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.textField becomeFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([newText length]>0) {
        self.saveBarButton.enabled = YES;
    }else{
        self.saveBarButton.enabled = NO;
    }
    return YES;
}
@end

















