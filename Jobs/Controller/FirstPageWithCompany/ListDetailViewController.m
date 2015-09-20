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
#import "AddProcessView.h"
#import "LabelAndTextFieldCell.h"

@interface ListDetailViewController () {
    NSInteger _numberOfProcess;
    NSString *tempString;
}
//@property (weak     , nonatomic) IBOutlet UIButton *addProcess;
@property (strong   , nonatomic) AddProcessView *processView;
@end

@implementation ListDetailViewController

#pragma mark - view
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.jobListToEdit != nil) {
        self.title = @"编辑公司";
//        self.textField.text = self.jobListToEdit.name;
//        self.accountOfWebsiteTextField.text = self.jobListToEdit.accountOfWebsite;
//        self.reminderOfPasswordTextField.text = self.jobListToEdit.reminderOfPassword;
//        self.emailTextField.text = self.jobListToEdit.email;
        self.saveBarButton.enabled = YES;
    }
    
    _numberOfProcess = 1;
    
//    self.textField.tag = 30;
//    self.accountOfWebsiteTextField.tag = 31;
//    self.reminderOfPasswordTextField.tag = 32;
//    self.emailTextField.tag = 33;
//    
//    self.textField.delegate = self;
//    self.accountOfWebsiteTextField.delegate = self;
//    self.reminderOfPasswordTextField.delegate = self;
//    self.emailTextField.delegate = self;
    
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


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if(section ==1) {
        return 3;
    }else {
        return _numberOfProcess;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *CellIdentifier = @"Cell";
    LabelAndTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[LabelAndTextFieldCell alloc]init];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    cell.label.text = tempString;
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

//- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    if (section == 0) {
//        return @"必填";
//    }else {
//        return @"选填";
//    }
//}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0,
                                                            0.0,
                                                            self.view.bounds.size.width,
                                                            30)];
    view.backgroundColor = [UIColor clearColor];
    
    
    // Create label with section title
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(16.0,
                             10.0,
                             100.0,
                             20.0);
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:17.0];
    if (section == 0) {
        label.text = @"必填";
    }else {
        label.text = @"选填";
    }
    label.backgroundColor = [UIColor clearColor];
    [view addSubview:label];
    
    return view;
    
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
//        [self.accountOfWebsiteTextField becomeFirstResponder];
    }else if (textField.tag == 31 ) {
//        [self.reminderOfPasswordTextField becomeFirstResponder];
    }else if(textField.tag == 32){
//        [self.emailTextField becomeFirstResponder];
    }else{
        [self.view endEditing:YES];
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    self.saveBarButton.enabled = NO;
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
//        jobList.name = self.textField.text;
//        jobList.accountOfWebsite = self.accountOfWebsiteTextField.text;
//        jobList.reminderOfPassword = self.reminderOfPasswordTextField.text;
//        jobList.email = self.emailTextField.text;
        [self.delegate listDetailViewController:self didFinishAddingJoblist:jobList];
    }else{
//        self.jobListToEdit.name = self.textField.text;
//        self.jobListToEdit.accountOfWebsite = self.accountOfWebsiteTextField.text;
//        self.jobListToEdit.reminderOfPassword = self.reminderOfPasswordTextField.text;
//        self.jobListToEdit.email = self.emailTextField.text;
        [self.delegate listDetailViewController:self didFinishEditingJobList:self.jobListToEdit];
    }
}

//- (IBAction)addProcessTapped:(id)sender {
//    [self addProcessView];
//}

#pragma mark - AddProcessView
- (void)addProcessView {
    _processView = [[AddProcessView alloc]init];
    _processView.delegate = self;
    self.navigationItem.leftBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self.view addSubview:_processView];
}

#pragma mark - AddProcessDelegate
- (void)addProcrssViewDidSavedWithString:(NSString *)string Date:(NSDate *)date {
    tempString = [string copy];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_numberOfProcess++ inSection:2];
    NSArray *indexPaths = @[indexPath];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)cancel {
    self.navigationItem.leftBarButtonItem.enabled = YES;
//    if (_textField.text.length>0) {
//        self.navigationItem.rightBarButtonItem.enabled = YES;
//    }
}

@end
