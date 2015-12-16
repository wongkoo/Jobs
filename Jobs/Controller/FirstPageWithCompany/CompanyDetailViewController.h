//
//  ListDetailViewController.h
//  Jobs
//
//  Created by 王振辉 on 15/6/5.
//  Copyright (c) 2015年 王振辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellbackgroundVIew.h"

typedef NS_ENUM(NSInteger, ListDetailType){
    ListDetailTypeAdd,
    ListDetailTypeEdit
};

@class CompanyDetailViewController;
@class JobList;

typedef void (^AddJobListInsertZeroBlock)(JobList *jobList);
typedef void (^EditJobListReloadBlock)(JobList *fromJobList, JobList *toJobList);

@interface CompanyDetailViewController : UITableViewController

@property (nonatomic, weak) IBOutlet UIBarButtonItem *saveBarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelBarButton;
@property (nonatomic, strong) JobList *jobListToEdit;
@property (nonatomic, assign) ListDetailType listDetailType;
@property (nonatomic, copy) AddJobListInsertZeroBlock addJobListInsertZeroBlock;
@property (nonatomic, copy) EditJobListReloadBlock editJobListReloadBlock;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end
