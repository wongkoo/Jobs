//
//  ListDetailViewController.m
//  Jobs
//
//  Created by 王振辉 on 15/6/5.
//  Copyright (c) 2015年 王振辉. All rights reserved.
//

#import "ListDetailViewController.h"
#import "JobList.h"
@interface ListDetailViewController ()

@end

@implementation ListDetailViewController

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    self.saveBarButton.enabled = ([newText length]>0);
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.jobListToEdit != nil) {
        self.title = @"Edit JobList";
        self.textField.text = self.jobListToEdit.name;
        self.saveBarButton.enabled = YES;
    }
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.textField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction

- (IBAction)cancel:(id)sender{
    [self.delegate listDetailViewControllerDidCancel:self];
}

- (IBAction)save:(id)sender{
    if (self.jobListToEdit == nil) {
        JobList *jobList = [[JobList alloc]init];
        jobList.name = self.textField.text;
        [self.delegate listDetailViewController:self didFinishAddingJoblist:jobList];
    }else{
        self.jobListToEdit.name = self.textField.text;
        [self.delegate listDetailViewController:self didFinishEditingJobList:self.jobListToEdit];
    }
}

@end
