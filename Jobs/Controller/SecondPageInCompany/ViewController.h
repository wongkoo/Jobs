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
#import "CountdownView.h"

@class JobList;

@protocol ViewController3DTouchDelegate <NSObject>
- (void)deleteJoblist:(JobList *)joblist;
- (void)addPositionInJoblist:(JobList *)joblist;
@end

@interface ViewController : UITableViewController <ItemDetailViewControllerDelegate,BFPaperCheckboxDelegate,CountdownViewDelegate>

@property (nonatomic, strong)JobList *jobList;
@property(nonatomic, weak)  id <ViewController3DTouchDelegate>delegate;

@end

