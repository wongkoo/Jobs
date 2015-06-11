//
//  ListDetailViewController.h
//  Jobs
//
//  Created by 王振辉 on 15/6/5.
//  Copyright (c) 2015年 王振辉. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ListDetailViewController;
@class JobList;

@protocol ListDetailViewControllerDelegate <NSObject>

- (void)listDetailViewControllerDidCancel:(ListDetailViewController *)controller;
- (void)listDetailViewController:(ListDetailViewController *)controller didFinishAddingJoblist:(JobList *)jobList;
- (void)listDetailViewController:(ListDetailViewController *)controller didFinishEditingJobList:(JobList *)jobList;
@end

@interface ListDetailViewController : UITableViewController<UITextFieldDelegate,UIScrollViewDelegate>
@property (nonatomic,weak)IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITextField *accountOfWebsiteTextField;
@property (weak, nonatomic) IBOutlet UITextField *reminderOfPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;


@property (nonatomic,weak)IBOutlet UIBarButtonItem *saveBarButton;
@property (nonatomic,weak)id<ListDetailViewControllerDelegate>delegate;
@property (nonatomic,strong)JobList *jobListToEdit;
- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;
@end
