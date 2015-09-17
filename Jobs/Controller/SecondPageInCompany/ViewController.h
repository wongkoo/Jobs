//
//  ViewController.h
//  Jobs
//
//  Created by 王振辉 on 15/6/3.
//  Copyright (c) 2015年 王振辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemDetailViewController.h"
#import <BFPaperCheckbox.h>


@class JobList;
@interface ViewController : UITableViewController <ItemDetailViewControllerDelegate,BFPaperCheckboxDelegate>

@property (nonatomic, strong)JobList *jobList;
@end

