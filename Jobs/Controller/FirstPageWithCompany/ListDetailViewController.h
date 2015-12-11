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

@class ListDetailViewController;
@class JobList;

typedef void (^AddJobListInsertZeroBlock)(JobList *jobList);
typedef void (^EditJobListReloadBlock)(JobList *jobList);

@interface ListDetailViewController : UITableViewController

@property (nonatomic, strong) NSString *companyNameString;
@property (nonatomic, strong) NSString *accountOfWebsiteString;
@property (nonatomic, strong) NSString *reminderOfPasswordString;
@property (nonatomic, strong) NSString *emailString;
@property (nonatomic, strong) NSMutableArray *process;
@property (nonatomic, assign) CellColor cellColor;


@property (nonatomic, weak) IBOutlet UIBarButtonItem *saveBarButton;

@property (nonatomic, strong) JobList *jobListToEdit;
@property (nonatomic, assign) ListDetailType listDetailType;
@property (nonatomic, copy) AddJobListInsertZeroBlock addJobListInsertZeroBlock;
@property (nonatomic, copy) EditJobListReloadBlock editJobListReloadBlock;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end
