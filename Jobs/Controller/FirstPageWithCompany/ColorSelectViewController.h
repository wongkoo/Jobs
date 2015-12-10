//
//  ColorSelectViewController.h
//  Jobs
//
//  Created by 锤石 on 15/11/5.
//  Copyright © 2015年 王振辉. All rights reserved.
//

#import "CellbackgroundVIew.h"

typedef void(^SelectedBlock)(NSInteger integer);

@interface ColorSelectViewController : UITableViewController 

@property (nonatomic, assign) CellColor cellColor;
@property (nonatomic, copy) SelectedBlock selectedBlock;

@end
