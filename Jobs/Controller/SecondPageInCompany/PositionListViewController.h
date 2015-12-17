//
//  ViewController.h
//  Jobs
//
//  Created by 王振辉 on 15/6/3.
//  Copyright (c) 2015年 王振辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PositionDetailViewController.h"
#import <BFPaperCheckbox.h>
#import "CountdownView.h"

@class Company;

@protocol ViewController3DTouchDelegate <NSObject>
- (void)deleteCompany:(Company *)company;
- (void)addPositionInCompany:(Company *)company;
@end

@interface PositionListViewController : UITableViewController <ItemDetailViewControllerDelegate,BFPaperCheckboxDelegate,CountdownViewDelegate>

@property (nonatomic, strong) Company *company;
@property (nonatomic, weak) id <ViewController3DTouchDelegate>delegate;

@end

