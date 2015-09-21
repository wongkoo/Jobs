//
//  ListDetailViewController.m
//  Jobs
//
//  Created by 王振辉 on 15/6/5.
//  Copyright (c) 2015年 王振辉. All rights reserved.
//

#import "ListDetailViewController.h"
#import "JobList.h"
#import "DateAndProcess.h"
#import "CellbackgroundVIew.h"
#import "AddProcessView.h"
#import "LabelAndTextFieldCell.h"
#import "AddButtonCell.h"
#import "ProcessCell.h"

@interface ListDetailViewController ()
@property (strong, nonatomic) AddProcessView *processView;
@end

@implementation ListDetailViewController

#pragma mark - view
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.jobListToEdit != nil) {
        self.title = @"编辑公司";
        _companyNameString = self.jobListToEdit.name;
        _accountOfWebsiteString = self.jobListToEdit.accountOfWebsite;
        _emailString = self.jobListToEdit.email;
        _process = self.jobListToEdit.process;
        //self.jobListToEdit.items;
        self.saveBarButton.enabled = YES;
    }else{
        self.title = @"添加公司";
        self.saveBarButton.enabled = NO;
        _process = [[NSMutableArray alloc]initWithCapacity:3];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if(section ==1) {
        return 3;
    }else {
        return [_process count]+1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *LabelAndTextFieldCellIdentifier = @"LabelAndTextFieldCell";
    static NSString *AddButtonCellIdentifier = @"AddButtonCell";
    static NSString *ProcessCellIdentifier = @"ProcessCell";
    if (indexPath.section == 2) {

        if (indexPath.row == [_process count]) {
            AddButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:AddButtonCellIdentifier];
            if (!cell) {
                cell = [[AddButtonCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AddButtonCellIdentifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            [cell.button addTarget:self action:@selector(addProcessTapped:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
            
        }else{
            ProcessCell *cell = [tableView dequeueReusableCellWithIdentifier:ProcessCellIdentifier];
            if (!cell) {
                cell = [[ProcessCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ProcessCellIdentifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            
            DateAndProcess *dateAndProcess = [_process objectAtIndex:indexPath.row];
            
            NSDateFormatter  *dateFormatter=[[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MMddhhmm"];
            NSString *dateString=[dateFormatter stringFromDate:dateAndProcess.date];
            
            cell.timeLabel.text = dateString;
            cell.processLabel.text = dateAndProcess.string;
            return cell;
        }

        
    }else{
        LabelAndTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:LabelAndTextFieldCellIdentifier];
        
        if (!cell) {
            cell = [[LabelAndTextFieldCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LabelAndTextFieldCellIdentifier];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        [self configureElementForCell:cell withIndexPath:indexPath];
        return cell;
    }
}

- (void)configureElementForCell:(LabelAndTextFieldCell *)cell withIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        cell.label.text = @"公司";
        cell.textField.placeholder = @"Mogujie";
        cell.textField.text = self.jobListToEdit.name;
    }else if(indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.label.text = @"官网帐号";
            cell.textField.placeholder = @"WangMing";
            cell.textField.text = self.jobListToEdit.accountOfWebsite;
        }else if(indexPath.row == 1) {
            cell.label.text = @"密码提示";
            cell.textField.placeholder = @"DODO's Birthday";
            cell.textField.text = self.jobListToEdit.reminderOfPassword;
        }else {
            cell.label.text = @"报名邮箱";
            cell.textField.placeholder = @"WangMing@xmail.com";
            cell.textField.text = self.jobListToEdit.email;
        }
    }
    cell.textField.delegate = self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2 && indexPath.row != [_process count]) {
        return YES;
    }
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        return UITableViewCellEditingStyleDelete;
    }else {
        return UITableViewCellEditingStyleNone;
    }
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *layTopRowAction1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [_process removeObjectAtIndex:indexPath.row];
        [tableView setEditing:NO animated:YES];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];
    layTopRowAction1.backgroundColor = [UIColor redColor];
    
    UITableViewRowAction *layTopRowAction2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"编辑" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"点击了编辑");
        DateAndProcess *dateAndProcess = [_process objectAtIndex:indexPath.row];
        [self addProcessViewWithString:dateAndProcess.string Date:dateAndProcess.date];
        [tableView setEditing:NO animated:YES];
    }];
    layTopRowAction2.backgroundColor = [UIColor orangeColor];
    
    NSArray *arr = @[layTopRowAction1,layTopRowAction2];
    return arr;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        return;
    }else{
        return;
    }
}

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

    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(16.0,
                             10.0,
                             100.0,
                             20.0);
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:17.0];
    if (section == 1) {
        label.text = @"选填*";
    }else if(section == 2) {
        label.text = @"招聘流程*";
    }
    label.backgroundColor = [UIColor clearColor];
    [view addSubview:label];
    
    return view;
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([textField.placeholder isEqualToString:@"Mogujie"]) {
        NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
        self.saveBarButton.enabled = ([newText length]>0);
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField.placeholder isEqualToString:@"Mogujie"]) {
        _companyNameString = textField.text;
    }else if([textField.placeholder isEqualToString:@"WangMing"]) {
        _accountOfWebsiteString = textField.text;
    }else if([textField.placeholder isEqualToString:@"DODO's Birthday"]) {
        _reminderOfPasswordString = textField.text;
    }else if([textField.placeholder isEqualToString:@"WangMing@xmail.com"]) {
        _emailString = textField.text;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField.placeholder isEqualToString:@"Mogujie"]) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
        LabelAndTextFieldCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell.textField becomeFirstResponder];
    }else if([textField.placeholder isEqualToString:@"WangMing"]) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
        LabelAndTextFieldCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell.textField becomeFirstResponder];
    }else if([textField.placeholder isEqualToString:@"DODO's Birthday"]) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:1];
        LabelAndTextFieldCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell.textField becomeFirstResponder];
    }else if([textField.placeholder isEqualToString:@"WangMing@xmail.com"]) {
        [self.view endEditing:YES];
    }
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if ([textField.placeholder isEqualToString:@"Mogujie"]) {
            self.saveBarButton.enabled = NO;
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
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    LabelAndTextFieldCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSString *companyNameString = cell.textField.text;
    
    indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSString *accountOfWebsite = cell.textField.text;

    indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
    cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSString *reminderOfPassword = cell.textField.text;
    
    indexPath = [NSIndexPath indexPathForRow:2 inSection:1];
    cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSString *emailString = cell.textField.text;
    
    if (self.jobListToEdit == nil) {
        JobList *jobList = [[JobList alloc]init];
        jobList.name = companyNameString;
        jobList.accountOfWebsite = accountOfWebsite;
        jobList.reminderOfPassword = reminderOfPassword;
        jobList.email = emailString;
        jobList.process = _process;
        [self.delegate listDetailViewController:self didFinishAddingJoblist:jobList];
    }else{
        self.jobListToEdit.name = companyNameString;
        self.jobListToEdit.accountOfWebsite = accountOfWebsite;
        self.jobListToEdit.reminderOfPassword = reminderOfPassword;
        self.jobListToEdit.email = emailString;
        self.jobListToEdit.process = _process; //////????????
        [self.delegate listDetailViewController:self didFinishEditingJobList:self.jobListToEdit];
    }
}

- (IBAction)addProcessTapped:(id)sender {
    [self addProcessViewWithString:NULL Date:NULL];
}

#pragma mark - AddProcessView
- (void)addProcessViewWithString:(NSString *)string Date:(NSDate *)date {
    _processView = [[AddProcessView alloc]init];
    _processView.string = string;
    _processView.date = date;
    _processView.delegate = self;
    self.navigationItem.leftBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    self.tableView.scrollEnabled = NO;
    [self.view addSubview:_processView];
}

#pragma mark - AddProcessDelegate
- (void)addProcrssViewDidSavedWithString:(NSString *)string Date:(NSDate *)date {
    [self cancel];
    
    DateAndProcess *dateAndProcess = [[DateAndProcess alloc]init];
    dateAndProcess.string = string;
    dateAndProcess.date = date;
    [_process addObject:dateAndProcess];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[_process count]-1 inSection:2];
    NSArray *indexPaths = @[indexPath];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)cancel {
    self.navigationItem.leftBarButtonItem.enabled = YES;
    self.tableView.scrollEnabled = YES;
    if (_companyNameString.length>0) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}

#pragma mark - MemoryWorning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
