//
//  ListDetailViewController.m
//  Jobs
//
//  Created by 王振辉 on 15/6/5.
//  Copyright (c) 2015年 王振辉. All rights reserved.
//

#import "ListDetailViewController.h"
#import "ColorSelectViewController.h"

#import "JobList.h"


#import "DateAndProcess.h"
#import "CellbackgroundVIew.h"
#import "AddProcessView.h"

#import "LabelAndTextFieldCell.h"
#import "AddButtonCell.h"
#import "ProcessCell.h"
#import "ColorSelectCell.h"

@interface ListDetailViewController () <UITextFieldDelegate,UIScrollViewDelegate,AddProcessViewDelegate>
@property (nonatomic, strong) AddProcessView *processView;
@property (nonatomic, strong) JobList *p_jobList;
@end

@implementation ListDetailViewController



#pragma mark - view

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.saveBarButton.title = NSLocalizedString(@"ListDetailViewController Save", @"保存");
    self.cancelBarButton.title = NSLocalizedString(@"ListDetailViewController Cancel", @"取消");
    
    if (self.listDetailType == ListDetailTypeEdit) {
        self.title = NSLocalizedString(@"ListDetailViewController Edit Company", @"编辑公司");
        self.saveBarButton.enabled = YES;
        
        self.p_jobList = self.jobListToEdit;
        self.jobListToEdit = [self.p_jobList copy];
    }else if (self.listDetailType == ListDetailTypeAdd) {
        self.title = NSLocalizedString(@"ListDetailViewController Add Company", @"添加公司");
        self.saveBarButton.enabled = NO;
        
        self.jobListToEdit = [[JobList alloc] init];
        self.jobListToEdit.name = @"";
        self.jobListToEdit.accountOfWebsite = @"";
        self.jobListToEdit.email = @"";
        self.jobListToEdit.reminderOfPassword = @"";
        self.jobListToEdit.process = [[NSMutableArray alloc]initWithCapacity:3];
        self.jobListToEdit.cellColor = CellColorWhite;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }else if(section ==1) {
        return 3;
    }else {
        return [self.jobListToEdit.process count]+1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *LabelAndTextFieldCellIdentifier = @"LabelAndTextFieldCell";
    static NSString *AddButtonCellIdentifier = @"AddButtonCell";
    static NSString *ProcessCellIdentifier = @"ProcessCell";
    static NSString *ColorCellIdentifier = @"ColorCell";
    
    //processCell
    if (indexPath.section == 2) {

        if (indexPath.row == [self.jobListToEdit.process count]) {
            AddButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:AddButtonCellIdentifier];
            if (!cell) {
                cell = [[AddButtonCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AddButtonCellIdentifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            
            if ([self.jobListToEdit.process count]>0) {
                cell.sortButton.hidden = NO;
            }else{
                cell.sortButton.hidden = YES;
            }
            [cell.sortButton addTarget:self action:@selector(sortProcessButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            [cell.addButton addTarget:self action:@selector(addProcessButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
            
        }else{
            ProcessCell *cell = [tableView dequeueReusableCellWithIdentifier:ProcessCellIdentifier];
            if (!cell) {
                cell = [[ProcessCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ProcessCellIdentifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            
            DateAndProcess *dateAndProcess = [self.jobListToEdit.process objectAtIndex:indexPath.row];
            
            NSDateFormatter  *dateFormatter=[[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:NSLocalizedString(@"ListDetailViewController Date", @"MM月dd日hh:mm")];
            NSString *dateString=[dateFormatter stringFromDate:dateAndProcess.date];
            
            cell.timeLabel.text = dateString;
            cell.processLabel.text = dateAndProcess.string;
            return cell;
        }
    }
    
    //colorCell
    else if (indexPath.section == 0 && indexPath.row == 1) {
        ColorSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:ColorCellIdentifier];
        if (!cell) {
            cell = [[ColorSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ColorCellIdentifier];
            cell.title = NSLocalizedString(@"ListDetailViewController Background Color", @"背景颜色");
            [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
        }
        cell.cellColor = self.jobListToEdit.cellColor;
        return cell;
    }
    
    //LabelandTextCell
    else {
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
        cell.label.text = NSLocalizedString(@"ListDetailViewController Company", @"公司");
        cell.textField.placeholder = @"Mogujie";
        cell.textField.text = self.jobListToEdit.name;
    }else if(indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.label.text = NSLocalizedString(@"ListDetailViewController Web Account", @"官网帐号");
            cell.textField.placeholder = @"WangMing";
            cell.textField.text = self.jobListToEdit.accountOfWebsite;
        }else if(indexPath.row == 1) {
            cell.label.text = NSLocalizedString(@"ListDetailViewController Password Hint", @"密码提示");
            cell.textField.placeholder = @"DODO's Birthday";
            cell.textField.text = self.jobListToEdit.reminderOfPassword;
        }else if(indexPath.row == 2) {
            cell.label.text = NSLocalizedString(@"ListDetailViewController Email", @"报名邮箱");
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
    if (indexPath.section == 2 && indexPath.row != [self.jobListToEdit.process count]) {
        return YES;
    }
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *layTopRowAction1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                                title:NSLocalizedString(@"ListDetailViewController Delete", @"删除")
                                                                              handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [self.jobListToEdit.process removeObjectAtIndex:indexPath.row];
        [tableView setEditing:NO animated:YES];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                                                                              }];
    layTopRowAction1.backgroundColor = [UIColor redColor];
    
    UITableViewRowAction *layTopRowAction2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                                title:NSLocalizedString(@"ListDetailViewController Edit", @"编辑")
                                                                              handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        DateAndProcess *dateAndProcess = [self.jobListToEdit.process objectAtIndex:indexPath.row];
        [self addProcessViewWithString:dateAndProcess.string Date:dateAndProcess.date Index:indexPath.row];
        [tableView setEditing:NO animated:YES];
                                                                              }];
    layTopRowAction2.backgroundColor = [UIColor orangeColor];
    
    NSArray *arr = @[layTopRowAction1,layTopRowAction2];
    return arr;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    [self.jobListToEdit.process exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2 && indexPath.row != [self.jobListToEdit.process count]) {
        return YES;
    }else{
        return NO;
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
                             200.0,
                             20.0);
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:17.0];
    if (section == 1) {
        label.text = NSLocalizedString(@"ListDetailViewController Optional*", @"选填*");
    }else if(section == 2) {
        label.text = NSLocalizedString(@"ListDetailViewController Recruitment Process", @"招聘流程*");
    }
    label.backgroundColor = [UIColor clearColor];
    [view addSubview:label];
    
    return view;
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    if (sourceIndexPath.section == proposedDestinationIndexPath.section && proposedDestinationIndexPath.row != [self.jobListToEdit.process count]) {
        return proposedDestinationIndexPath;
    }else{
        return sourceIndexPath;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 1) {
        ColorSelectViewController *controller = [[ColorSelectViewController alloc] init];
        controller.cellColor = self.jobListToEdit.cellColor;
        
        __weak typeof(self) weakSelf =  self;
        controller.selectedBlock = ^(NSInteger integer) {
            weakSelf.jobListToEdit.cellColor = integer;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        };
        
        [self.navigationController pushViewController:controller animated:YES];
    }
}



#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([textField.placeholder isEqualToString:@"Mogujie"]) {
        NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
        self.saveBarButton.enabled = ([newText length]>0);
    }
    return YES;
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

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.view endEditing:YES];
}



#pragma mark - IBAction

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)save:(id)sender {
    [self saveText];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (self.listDetailType == ListDetailTypeAdd) {
        if (self.addJobListInsertZeroBlock) {
            self.addJobListInsertZeroBlock(self.jobListToEdit);
        }
    }else if (self.listDetailType == ListDetailTypeEdit) {
        if (self.editJobListReloadBlock) {
            self.editJobListReloadBlock(self.p_jobList, self.jobListToEdit);
        }
    }
}



#pragma mark - SaveTextFromTextField

- (void)saveText {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    LabelAndTextFieldCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    self.jobListToEdit.name = cell.textField.text;
    
    indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    cell = [self.tableView cellForRowAtIndexPath:indexPath];
    self.jobListToEdit.accountOfWebsite = cell.textField.text;
    
    indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
    cell = [self.tableView cellForRowAtIndexPath:indexPath];
    self.jobListToEdit.reminderOfPassword = cell.textField.text;
    
    indexPath = [NSIndexPath indexPathForRow:2 inSection:1];
    cell = [self.tableView cellForRowAtIndexPath:indexPath];
    self.jobListToEdit.email = cell.textField.text;
}



#pragma mark - Button Action

- (void)addProcessButtonTapped:(id)sender {
    [self addProcessViewWithString:NULL Date:NULL Index:-1];
}

- (void)sortProcessButtonTapped:(id)sender {
    self.editing = !self.editing;
}



#pragma mark - Subview AddProcessView

- (void)addProcessViewWithString:(NSString *)string Date:(NSDate *)date Index:(NSInteger)index{
    _processView = [[AddProcessView alloc]init];
    _processView.string = string;
    _processView.date = date;
    _processView.delegate = self;
    _processView.index = index;
    
    self.navigationItem.leftBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    self.tableView.scrollEnabled = NO;
    [self.view addSubview:_processView];
}



#pragma mark - AddProcessDelegate

- (void)addProcrssViewDidSavedWithString:(NSString *)string Date:(NSDate *)date Index:(NSInteger)index{
    [self addProcrssViewDidCancel];
    
    NSIndexPath *buttonIndexPath = [NSIndexPath indexPathForRow:[self.jobListToEdit.process count] inSection:2];
    AddButtonCell *cell = [self.tableView cellForRowAtIndexPath:buttonIndexPath];
    cell.sortButton.hidden = NO;
    
    DateAndProcess *dateAndProcess = [[DateAndProcess alloc]init];
    dateAndProcess.string = string;
    dateAndProcess.date = date;
    if (index == -1) {
        [self.jobListToEdit.process addObject:dateAndProcess];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.jobListToEdit.process count]-1 inSection:2];
        NSArray *indexPaths = @[indexPath];
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }else{
        [self.jobListToEdit.process removeObjectAtIndex:index];
        [self.jobListToEdit.process insertObject:dateAndProcess atIndex:index];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:2];
        NSArray *indexPaths = @[indexPath];
        [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)addProcrssViewDidCancel {
    self.navigationItem.leftBarButtonItem.enabled = YES;
    self.tableView.scrollEnabled = YES;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    LabelAndTextFieldCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    self.jobListToEdit.name = cell.textField.text;
    
    if (self.jobListToEdit.name.length>0) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}

@end
