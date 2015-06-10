//
//  ListDetailViewController.h
//  Jobs
//
//  Created by 王振辉 on 15/6/5.
//  Copyright (c) 2015年 王振辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconPickerViewController.h"

@class ListDetailViewController;
@class JobList;

@protocol ListDetailViewControllerDelegate <NSObject>

- (void)listDetailViewControllerDidCancel:(ListDetailViewController *)controller;
- (void)listDetailViewController:(ListDetailViewController *)controller didFinishAddingJoblist:(JobList *)jobList;
- (void)listDetailViewController:(ListDetailViewController *)controller didFinishEditingJobList:(JobList *)jobList;
@end

@interface ListDetailViewController : UITableViewController<UITextFieldDelegate,IconPickerViewControllerDelegate>
@property (nonatomic,weak)IBOutlet UITextField *textField;
@property (nonatomic,weak)IBOutlet UIBarButtonItem *saveBarButton;
@property (nonatomic,weak)id<ListDetailViewControllerDelegate>delegate;
@property (nonatomic,strong)JobList *jobListToEdit;
- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;
@end
