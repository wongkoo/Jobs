//
//  ListDetailViewController.m
//  Jobs
//
//  Created by 王振辉 on 15/6/5.
//  Copyright (c) 2015年 王振辉. All rights reserved.
//

#import "ListDetailViewController.h"
#import "JobList.h"
#import "CellbackgroundVIew.h"
@interface ListDetailViewController ()
@end

@implementation ListDetailViewController{
}

#pragma mark - view
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.jobListToEdit != nil) {
        self.title = @"编辑公司";
        self.textField.text = self.jobListToEdit.name;
        self.accountOfWebsiteTextField.text = self.jobListToEdit.accountOfWebsite;
        self.reminderOfPasswordTextField.text = self.jobListToEdit.reminderOfPassword;
        self.emailTextField.text = self.jobListToEdit.email;
        self.saveBarButton.enabled = YES;
    }
    self.textField.tag = 30;
    self.accountOfWebsiteTextField.tag = 31;
    self.reminderOfPasswordTextField.tag = 32;
    self.emailTextField.tag = 33;
    
    self.textField.delegate = self;
    self.accountOfWebsiteTextField.delegate = self;
    self.reminderOfPasswordTextField.delegate = self;
    self.emailTextField.delegate = self;
    
    self.navigationController.navigationBar.layer.shadowColor = [UIColor blackColor].CGColor; //shadowColor阴影颜色
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(2.0f , 2.0f); //shadowOffset阴影偏移x，y向(上/下)偏移(-/+)2
    self.navigationController.navigationBar.layer.shadowOpacity = 0.25f;//阴影透明度，默认0
    self.navigationController.navigationBar.layer.shadowRadius = 4.0f;//阴影半径
    
}


- (void )tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}



- (id)initWithCoder:(NSCoder *)aDecoder{
    if ((self = [super initWithCoder:aDecoder])) {
        //_iconName = @"1";
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return indexPath;
    }else{
        return nil;
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.tag == 30) {
        NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
        self.saveBarButton.enabled = ([newText length]>0);
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.tag ==30) {
        [self.accountOfWebsiteTextField becomeFirstResponder];
    }else if (textField.tag == 31 ) {
        [self.reminderOfPasswordTextField becomeFirstResponder];
    }else if(textField.tag == 32){
        [self.emailTextField becomeFirstResponder];
    }else{
        [self.view endEditing:YES];
    }
    return YES;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.view endEditing:YES];
}



#pragma mark - IBAction
- (IBAction)cancel:(id)sender{
    [self.delegate listDetailViewControllerDidCancel:self];
}

- (IBAction)save:(id)sender{
    if (self.jobListToEdit == nil) {
        JobList *jobList = [[JobList alloc]init];
        jobList.name = self.textField.text;
        jobList.accountOfWebsite = self.accountOfWebsiteTextField.text;
        jobList.reminderOfPassword = self.reminderOfPasswordTextField.text;
        jobList.email = self.emailTextField.text;
        [self.delegate listDetailViewController:self didFinishAddingJoblist:jobList];
    }else{
        self.jobListToEdit.name = self.textField.text;
        self.jobListToEdit.accountOfWebsite = self.accountOfWebsiteTextField.text;
        self.jobListToEdit.reminderOfPassword = self.reminderOfPasswordTextField.text;
        self.jobListToEdit.email = self.emailTextField.text;
        [self.delegate listDetailViewController:self didFinishEditingJobList:self.jobListToEdit];
    }
}

@end
