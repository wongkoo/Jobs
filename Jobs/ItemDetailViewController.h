//
//  ItemDetailViewController.h
//  Jobs
//
//  Created by 王振辉 on 15/6/4.
//  Copyright (c) 2015年 王振辉. All rights reserved.
//

#import <UIKit/UIKit.h>
//1.在对象B的.h中定义⼀一个@protocol 代理
@class ItemDetailViewController;
@class JobsItem;
@protocol ItemDetailViewControllerDelegate <NSObject>

- (void) itemDetailViewControllerdidCancel:(ItemDetailViewController *)controller;
- (void) itemDetailViewController:(ItemDetailViewController *)controller didFinishAddingItem:(JobsItem *)item;
- (void) itemDetailViewController:(ItemDetailViewController *)controller didFinishEditingItem:(JobsItem *)item;
@end

@interface ItemDetailViewController : UITableViewController<UITextFieldDelegate>

@property (strong, nonatomic) JobsItem *itemToEdit;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *nextTaskTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveBarButton;
@property (weak, nonatomic) IBOutlet UISwitch *switchControl;
@property (weak, nonatomic) IBOutlet UILabel *dueDateLabel;
//2.在对象B的.h中声明⼀一个代理协议的属性变量
@property (weak, nonatomic) id <ItemDetailViewControllerDelegate> delegate;

- (IBAction)cancel:(id)sender;
- (IBAction)Save:(id)sender;
@end
