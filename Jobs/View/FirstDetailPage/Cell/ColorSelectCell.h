//
//  ColorSelectCell.h
//  Jobs
//
//  Created by 锤石 on 15/11/5.
//  Copyright © 2015年 王振辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellbackgroundVIew.h"
@interface ColorSelectCell : UITableViewCell

@property (nonatomic, assign) CellColor cellColor;
@property (nonatomic, copy) NSString *title;

@end
