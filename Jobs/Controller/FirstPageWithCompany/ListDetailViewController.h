//
//  ListDetailViewController.h
//  Jobs
//
//  Created by 王振辉 on 15/6/5.
//  Copyright (c) 2015年 王振辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddProcessView.h"
#import "CellbackgroundVIew.h"

@class ListDetailViewController;
@class JobList;

@protocol ListDetailViewControllerDelegate <NSObject>
- (void)listDetailViewControllerDidCancel:(ListDetailViewController *)controller;
- (void)listDetailViewController:(ListDetailViewController *)controller didFinishAddingJoblist:(JobList *)jobList;
- (void)listDetailViewController:(ListDetailViewController *)controller didFinishEditingJobList:(JobList *)jobList;
@end

@interface ListDetailViewController : UITableViewController<UITextFieldDelegate,UIScrollViewDelegate,AddProcessViewDelegate>

@property (nonatomic, strong) NSString *companyNameString;
@property (nonatomic, strong) NSString *accountOfWebsiteString;
@property (nonatomic, strong) NSString *reminderOfPasswordString;
@property (nonatomic, strong) NSString *emailString;
@property (nonatomic, strong) NSMutableArray *process;
@property (nonatomic, assign) CellColor cellColor;
@property (nonatomic, weak)   IBOutlet UIBarButtonItem *saveBarButton;

@property (nonatomic, weak) id<ListDetailViewControllerDelegate>delegate;
@property (nonatomic, strong) JobList *jobListToEdit;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end
