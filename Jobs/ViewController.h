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
//4.让对象A遵从代理协议,在@interface声明部分添加⼀一个尖括号包含协议
@interface ViewController : UITableViewController <ItemDetailViewControllerDelegate,BFPaperCheckboxDelegate>

@property (nonatomic, strong)JobList *jobList;

@end

