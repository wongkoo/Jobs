//
//  AddItemTableViewController.h
//  Jobs
//
//  Created by 王振辉 on 15/6/4.
//  Copyright (c) 2015年 王振辉. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddItemTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITextField *textField;

- (IBAction)cancel:(id)sender;
- (IBAction)Save:(id)sender;
@end
