//
//  AllListsViewController.h
//  Jobs
//
//  Created by 王振辉 on 15/6/4.
//  Copyright (c) 2015年 王振辉. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  DataModel;

@interface AllListsViewController : UIViewController

@property(nonatomic, strong)DataModel *dataModel;

- (IBAction)backToAllListsViewController:(UIStoryboardSegue *)segue;

@end
