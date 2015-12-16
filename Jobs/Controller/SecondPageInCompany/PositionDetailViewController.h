//
//  ItemDetailViewController.h
//  Jobs
//
//  Created by 王振辉 on 15/6/4.
//  Copyright (c) 2015年 王振辉. All rights reserved.
//

#import <UIKit/UIKit.h>
//1.在对象B的.h中定义⼀一个@protocol 代理
@class PositionDetailViewController;
@class JobsItem;

@protocol ItemDetailViewControllerDelegate <NSObject>
- (void) itemDetailViewControllerdidCancel:(PositionDetailViewController *)controller;
- (void) itemDetailViewController:(PositionDetailViewController *)controller didFinishAddingItem:(JobsItem *)item;
- (void) itemDetailViewController:(PositionDetailViewController *)controller didFinishEditingItem:(JobsItem *)item;
@end

@interface PositionDetailViewController : UITableViewController<UITextFieldDelegate>

@property (nonatomic, strong) JobsItem *itemToEdit;
@property (nonatomic, strong) NSString *companyName;
@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, weak) IBOutlet UISegmentedControl *nextTaskTextField;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *saveBarButton;
@property (nonatomic, weak) IBOutlet UISwitch *switchControl;
@property (nonatomic, weak) IBOutlet UILabel *dueDateLabel;

@property (nonatomic, weak) id <ItemDetailViewControllerDelegate> delegate;

- (IBAction)cancel:(id)sender;
- (IBAction)Save:(id)sender;
@end
