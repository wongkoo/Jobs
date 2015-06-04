//
//  AddItemTableViewController.h
//  Jobs
//
//  Created by 王振辉 on 15/6/4.
//  Copyright (c) 2015年 王振辉. All rights reserved.
//

#import <UIKit/UIKit.h>
//1.在对象B的.h中定义⼀一个@protocol 代理
@class AddItemTableViewController;
@class JobsItem;
@protocol AddItemTableViewControllerDelegate <NSObject>

- (void) addItemTableViewControllerdidCancel:(AddItemTableViewController *)controller;
- (void) addItemTableViewController:(AddItemTableViewController *)controller didFinishAddingItem:(JobsItem *)item;

@end

@interface AddItemTableViewController : UITableViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveBarButton;
//2.在对象B的.h中声明⼀一个代理协议的属性变量
@property (weak, nonatomic) id <AddItemTableViewControllerDelegate> delegate;

- (IBAction)cancel:(id)sender;
- (IBAction)Save:(id)sender;
@end
