//
//  ColorSelectViewController.h
//  Jobs
//
//  Created by 锤石 on 15/11/5.
//  Copyright © 2015年 王振辉. All rights reserved.
//

#import "CellbackgroundVIew.h"

@protocol ColorSelectVCDelegate <NSObject>
@optional
- (void)selectColorInterger:(NSInteger)integer;
@end

@interface ColorSelectViewController : UITableViewController <UITabBarControllerDelegate,UITableViewDataSource,ColorSelectVCDelegate>

@property (nonatomic, assign) CellColor cellColor;
@property (nonatomic, weak) id<ColorSelectVCDelegate> delegate;

@end
