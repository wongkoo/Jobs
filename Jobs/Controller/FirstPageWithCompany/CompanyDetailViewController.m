//
//  ListDetailViewController.m
//  Jobs
//
//  Created by 王振辉 on 15/6/5.
//  Copyright (c) 2015年 王振辉. All rights reserved.
//

#import "CompanyDetailViewController.h"
#import "ColorSelectViewController.h"

#import "Company.h"


#import "DateAndProcess.h"
#import "CellbackgroundVIew.h"
#import "AddProcessView.h"

#import "LabelAndTextFieldCell.h"
#import "AddButtonCell.h"
#import "ProcessCell.h"
#import "ColorSelectCell.h"

typedef NS_ENUM(NSInteger, ListDetailSectionType) {
    ListDetailSectionTypeRequired,
    ListDetailSectionTypeOptional,
    ListDetailSectionTypeProcess
};

typedef NS_ENUM(NSInteger, RequiredSectionCellType) {
    RequiredSectionCellTypeTitle,
    RequiredSectionCellTypeColor
};

typedef NS_ENUM(NSInteger, OptionalSectionCellType) {
    OptionalSectionCellTypeAccount,
    OptionalSectionCellTypeKeyHint,
    OptionalSectionCellTypeEmail
};

typedef NS_ENUM(NSInteger, ProcessSectionCellType) {
    ProcessSectionCellTypeAddButton,
    ProcessSectionCellTypeProcess
};

static const NSInteger kSectionNum = 3;
static const NSInteger kRequiredSectionNum = 2;
static const NSInteger kOptionalSectionNum = 3;
static const NSInteger kProcessSectionBasicNum = 1;
static const NSInteger kNullSectionNum = 0;
static const NSInteger kAddProcessViewNULL = -1;
static const CGFloat kCellHeight = 60;
static const CGFloat kHeaderHeight = 30;
static const CGFloat kFooterHeight = 0;

@interface CompanyDetailViewController () <UITextFieldDelegate,UIScrollViewDelegate,AddProcessViewDelegate>
@property (nonatomic, strong) AddProcessView *processView;
@property (nonatomic, strong) Company *p_company;
@end

@implementation CompanyDetailViewController



#pragma mark - view

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.saveBarButton.title = NSLocalizedString(@"ListDetailViewController Save", @"保存");
    self.cancelBarButton.title = NSLocalizedString(@"ListDetailViewController Cancel", @"取消");
    
    if (self.companyDetailOpenType == CompanyDetailOpenTypeEdit) {
        self.title = NSLocalizedString(@"ListDetailViewController Edit Company", @"编辑公司");
        self.saveBarButton.enabled = YES;
        
        self.p_company = self.companyToEdit;
        self.companyToEdit = [self.p_company copy];
    }else if (self.companyDetailOpenType == CompanyDetailOpenTypeAdd) {
        self.title = NSLocalizedString(@"ListDetailViewController Add Company", @"添加公司");
        self.saveBarButton.enabled = NO;
        
        self.companyToEdit = [[Company alloc] init];
        self.companyToEdit.name = @"";
        self.companyToEdit.accountOfWebsite = @"";
        self.companyToEdit.email = @"";
        self.companyToEdit.reminderOfPassword = @"";
        self.companyToEdit.process = [[NSMutableArray alloc]initWithCapacity:3];
        self.companyToEdit.cellColor = CellColorWhite;
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
    if (section == ListDetailSectionTypeRequired) {
        return kRequiredSectionNum;
    }else if(section == ListDetailSectionTypeOptional) {
        return kOptionalSectionNum;
    }else if(section == ListDetailSectionTypeProcess){
        return [self.companyToEdit.process count] + kProcessSectionBasicNum;
    }else {
        return kNullSectionNum;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *LabelAndTextFieldCellIdentifier = @"LabelAndTextFieldCell";
    static NSString *AddButtonCellIdentifier = @"AddButtonCell";
    static NSString *ProcessCellIdentifier = @"ProcessCell";
    static NSString *ColorCellIdentifier = @"ColorCell";
    
    //processCell
    if (indexPath.section == ListDetailSectionTypeProcess) {

        if (indexPath.row == [self.companyToEdit.process count]) {
            AddButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:AddButtonCellIdentifier];
            if (!cell) {
                cell = [[AddButtonCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AddButtonCellIdentifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            
            if ([self.companyToEdit.process count] > 0) {
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
            
            DateAndProcess *dateAndProcess = [self.companyToEdit.process objectAtIndex:indexPath.row];
            
            NSDateFormatter  *dateFormatter=[[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:NSLocalizedString(@"ListDetailViewController Date", @"MM月dd日hh:mm")];
            NSString *dateString=[dateFormatter stringFromDate:dateAndProcess.date];
            
            cell.timeLabel.text = dateString;
            cell.processLabel.text = dateAndProcess.string;
            return cell;
        }
    }
    
    //colorCell
    else if (indexPath.section == ListDetailSectionTypeRequired && indexPath.row == RequiredSectionCellTypeColor) {
        ColorSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:ColorCellIdentifier];
        if (!cell) {
            cell = [[ColorSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ColorCellIdentifier];
            cell.title = NSLocalizedString(@"ListDetailViewController Background Color", @"背景颜色");
            [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
        }
        cell.cellColor = self.companyToEdit.cellColor;
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
    if (indexPath.section == ListDetailSectionTypeRequired) {
        cell.label.text = NSLocalizedString(@"ListDetailViewController Company", @"公司");
        cell.textField.placeholder = @"Mogujie";
        cell.textField.text = self.companyToEdit.name;
    }else if(indexPath.section == ListDetailSectionTypeOptional) {
        if (indexPath.row == OptionalSectionCellTypeAccount) {
            cell.label.text = NSLocalizedString(@"ListDetailViewController Web Account", @"官网帐号");
            cell.textField.placeholder = @"WangMing";
            cell.textField.text = self.companyToEdit.accountOfWebsite;
        }else if(indexPath.row == OptionalSectionCellTypeKeyHint) {
            cell.label.text = NSLocalizedString(@"ListDetailViewController Password Hint", @"密码提示");
            cell.textField.placeholder = @"DODO's Birthday";
            cell.textField.text = self.companyToEdit.reminderOfPassword;
        }else if(indexPath.row == OptionalSectionCellTypeEmail) {
            cell.label.text = NSLocalizedString(@"ListDetailViewController Email", @"报名邮箱");
            cell.textField.placeholder = @"WangMing@xmail.com";
            cell.textField.text = self.companyToEdit.email;
        }
    }
    cell.textField.delegate = self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return kSectionNum;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == ListDetailSectionTypeProcess && indexPath.row != [self.companyToEdit.process count]) {
        return YES;
    }
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == ListDetailSectionTypeProcess) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *layTopRowAction1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                                title:NSLocalizedString(@"ListDetailViewController Delete", @"删除")
                                                                              handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                                                                  [self.companyToEdit.process removeObjectAtIndex:indexPath.row];
                                                                                  [tableView setEditing:NO animated:YES];
                                                                                  [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                                                                              }];
    layTopRowAction1.backgroundColor = [UIColor redColor];
    
    UITableViewRowAction *layTopRowAction2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                                title:NSLocalizedString(@"ListDetailViewController Edit", @"编辑")
                                                                              handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                                                                  DateAndProcess *dateAndProcess = [self.companyToEdit.process objectAtIndex:indexPath.row];
                                                                                  [self addProcessViewWithString:dateAndProcess.string Date:dateAndProcess.date Index:indexPath.row];
                                                                                  [tableView setEditing:NO animated:YES];
                                                                              }];
    layTopRowAction2.backgroundColor = [UIColor orangeColor];
    
    NSArray *arr = @[layTopRowAction1,layTopRowAction2];
    return arr;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    [self.companyToEdit.process exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == ListDetailSectionTypeProcess && indexPath.row != [self.companyToEdit.process count]) {
        return YES;
    }else{
        return NO;
    }
}



#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kFooterHeight;
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
    if (section == ListDetailSectionTypeOptional) {
        label.text = NSLocalizedString(@"ListDetailViewController Optional*", @"选填*");
    }else if(section == ListDetailSectionTypeProcess) {
        label.text = NSLocalizedString(@"ListDetailViewController Recruitment Process", @"招聘流程*");
    }
    label.backgroundColor = [UIColor clearColor];
    [view addSubview:label];
    
    return view;
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    if (sourceIndexPath.section == proposedDestinationIndexPath.section && proposedDestinationIndexPath.row != [self.companyToEdit.process count]) {
        return proposedDestinationIndexPath;
    }else{
        return sourceIndexPath;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == ListDetailSectionTypeRequired && indexPath.row == RequiredSectionCellTypeColor) {
        ColorSelectViewController *controller = [[ColorSelectViewController alloc] init];
        controller.cellColor = self.companyToEdit.cellColor;
        
        __weak typeof(self) weakSelf =  self;
        controller.selectedBlock = ^(NSInteger integer) {
            weakSelf.companyToEdit.cellColor = integer;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:RequiredSectionCellTypeColor inSection:ListDetailSectionTypeRequired];
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        };
        
        [self.navigationController pushViewController:controller animated:YES];
    }
}



#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([textField.placeholder isEqualToString:@"Mogujie"]) {
        NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
        self.saveBarButton.enabled = ([newText length] > 0);
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField.placeholder isEqualToString:@"Mogujie"]) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:OptionalSectionCellTypeAccount inSection:ListDetailSectionTypeOptional];
        LabelAndTextFieldCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell.textField becomeFirstResponder];
    }else if([textField.placeholder isEqualToString:@"WangMing"]) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:OptionalSectionCellTypeKeyHint inSection:ListDetailSectionTypeOptional];
        LabelAndTextFieldCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell.textField becomeFirstResponder];
    }else if([textField.placeholder isEqualToString:@"DODO's Birthday"]) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:OptionalSectionCellTypeEmail inSection:ListDetailSectionTypeOptional];
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
    
    if (self.companyDetailOpenType == CompanyDetailOpenTypeAdd) {
        if (self.addCompanyInsertZeroBlock) {
            self.addCompanyInsertZeroBlock(self.companyToEdit);
        }
    }else if (self.companyDetailOpenType == CompanyDetailOpenTypeEdit) {
        if (self.editCompanyReloadBlock) {
            self.editCompanyReloadBlock(self.p_company, self.companyToEdit);
        }
    }
}



#pragma mark - SaveTextFromTextField

- (void)saveText {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:RequiredSectionCellTypeTitle inSection:ListDetailSectionTypeRequired];
    LabelAndTextFieldCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    self.companyToEdit.name = cell.textField.text;
    
    indexPath = [NSIndexPath indexPathForRow:OptionalSectionCellTypeAccount inSection:ListDetailSectionTypeOptional];
    cell = [self.tableView cellForRowAtIndexPath:indexPath];
    self.companyToEdit.accountOfWebsite = cell.textField.text;
    
    indexPath = [NSIndexPath indexPathForRow:OptionalSectionCellTypeKeyHint inSection:ListDetailSectionTypeOptional];
    cell = [self.tableView cellForRowAtIndexPath:indexPath];
    self.companyToEdit.reminderOfPassword = cell.textField.text;
    
    indexPath = [NSIndexPath indexPathForRow:OptionalSectionCellTypeEmail inSection:ListDetailSectionTypeOptional];
    cell = [self.tableView cellForRowAtIndexPath:indexPath];
    self.companyToEdit.email = cell.textField.text;
}



#pragma mark - Button Action

- (void)addProcessButtonTapped:(id)sender {
    [self addProcessViewWithString:NULL Date:NULL Index:kAddProcessViewNULL];
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
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:RequiredSectionCellTypeTitle inSection:ListDetailSectionTypeRequired];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    self.tableView.scrollEnabled = NO;
    [self.view addSubview:_processView];
}



#pragma mark - AddProcessDelegate

- (void)addProcrssViewDidSavedWithString:(NSString *)string Date:(NSDate *)date Index:(NSInteger)index{
    [self addProcrssViewDidCancel];
    
    NSIndexPath *buttonIndexPath = [NSIndexPath indexPathForRow:[self.companyToEdit.process count] inSection:ListDetailSectionTypeProcess];
    AddButtonCell *cell = [self.tableView cellForRowAtIndexPath:buttonIndexPath];
    cell.sortButton.hidden = NO;
    
    DateAndProcess *dateAndProcess = [[DateAndProcess alloc]init];
    dateAndProcess.string = string;
    dateAndProcess.date = date;
    if (index == kAddProcessViewNULL) {
        [self.companyToEdit.process addObject:dateAndProcess];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.companyToEdit.process count] - kProcessSectionBasicNum inSection:ListDetailSectionTypeProcess];
        NSArray *indexPaths = @[indexPath];
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }else{
        [self.companyToEdit.process removeObjectAtIndex:index];
        [self.companyToEdit.process insertObject:dateAndProcess atIndex:index];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:ListDetailSectionTypeProcess];
        NSArray *indexPaths = @[indexPath];
        [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)addProcrssViewDidCancel {
    self.navigationItem.leftBarButtonItem.enabled = YES;
    self.tableView.scrollEnabled = YES;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:RequiredSectionCellTypeTitle inSection:ListDetailSectionTypeRequired];
    LabelAndTextFieldCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    self.companyToEdit.name = cell.textField.text;
    
    if (self.companyToEdit.name.length > 0) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}

@end
