//
//  AllListsViewController.h
//  Jobs
//
//  Created by 王振辉 on 15/6/4.
//  Copyright (c) 2015年 王振辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListDetailViewController.h"
#import "ViewController.h"

@class  DataModel;

@interface AllListsViewController : UITableViewController<ListDetailViewControllerDelegate,UINavigationControllerDelegate,UIViewControllerPreviewingDelegate,ViewController3DTouchDelegate>

@property(nonatomic, strong)DataModel *dataModel;

@end
