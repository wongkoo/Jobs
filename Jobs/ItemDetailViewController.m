//
//  ItemDetailViewController.m
//  Jobs
//
//  Created by 王振辉 on 15/6/4.
//  Copyright (c) 2015年 王振辉. All rights reserved.
//

#import "ItemDetailViewController.h"
#import "JobsItem.h"
#import "CellbackgroundVIew.h"
@interface ItemDetailViewController ()

@end

@implementation ItemDetailViewController{
    NSDate *_dueDate;
    BOOL _datePickerVisible;
}

#pragma mark - view
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.itemToEdit != nil) {
        self.title = @"编辑事件";
        self.textField.text = self.itemToEdit.text;
        [self initNextTaskSegmentedControl];
        self.saveBarButton.enabled = YES;
        self.switchControl.on = self.itemToEdit.shouldRemind;
        _dueDate = self.itemToEdit.dueDate;
    }else{
        self.switchControl.on = NO;
        _dueDate = [NSDate date];
    }
    [self updateDueDateLabel];
    
    UIControl *aControl;
    [aControl addTarget:self action: @selector(touchSection) forControlEvents:UIControlEventTouchUpInside];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)initNextTaskSegmentedControl{
    if ([self.itemToEdit.nextTask isEqualToString:@"报名"]) {
        self.nextTaskTextField.selectedSegmentIndex = 0;
    }else if([self.itemToEdit.nextTask isEqualToString:@"宣讲"]){
        self.nextTaskTextField.selectedSegmentIndex = 1;
    }else if([self.itemToEdit.nextTask isEqualToString:@"笔试"]){
        self.nextTaskTextField.selectedSegmentIndex = 2;
    }else if([self.itemToEdit.nextTask isEqualToString:@"一面"]){
        self.nextTaskTextField.selectedSegmentIndex = 3;
    }else if([self.itemToEdit.nextTask isEqualToString:@"二面"]){
        self.nextTaskTextField.selectedSegmentIndex = 4;
    }else if([self.itemToEdit.nextTask isEqualToString:@"三面"]){
        self.nextTaskTextField.selectedSegmentIndex = 5;
    }
}
-(void)touchSection{
    [self.textField resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.textField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - handel
- (void)updateDueDateLabel{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    self.dueDateLabel.text = [formatter stringFromDate:_dueDate];
}

- (void)showDatePicker{
    _datePickerVisible  = YES;
    NSIndexPath *indexPathDateRow = [NSIndexPath indexPathForRow:1 inSection:1];
    NSIndexPath *indexPathDatePicker = [NSIndexPath indexPathForRow:2 inSection:1];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPathDateRow];
    cell.detailTextLabel.textColor = cell.detailTextLabel.tintColor;
    [self.tableView beginUpdates];
    
    [self.tableView insertRowsAtIndexPaths:@[indexPathDatePicker] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView reloadRowsAtIndexPaths:@[indexPathDateRow] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
    UITableViewCell *datePickerCell = [self.tableView cellForRowAtIndexPath:indexPathDatePicker];
    
    UIDatePicker *datePicker =(UIDatePicker *)[datePickerCell viewWithTag:100];
    [datePicker setDate:_dueDate animated:NO];
}

- (void)hideDatePicker{
    if (_datePickerVisible) {
        _datePickerVisible = NO;
        NSIndexPath *indexPathDateRow = [NSIndexPath indexPathForRow:1 inSection:1];
        NSIndexPath *indexPathDatePicker = [NSIndexPath indexPathForRow:2 inSection:1];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPathDateRow];
        cell.detailTextLabel.textColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[indexPathDateRow] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView deleteRowsAtIndexPaths:@[indexPathDatePicker] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }
}



- (void)dateChanged:(UIDatePicker *)datePicker{
    _dueDate = datePicker.date;
    [self updateDueDateLabel];
}




#pragma mark - tableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //1
    if (indexPath.section == 1 && indexPath.row ==2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DatePickerCell"];
        //2
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DatePickerCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //3
            UIDatePicker *datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 216.0f)];
            datePicker.tag = 100;
            [cell.contentView addSubview:datePicker];
            
            //4
            [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        }
//        CGFloat begin[4]= {243.0f/255.0, 243.0f/255.0, 243.0f/255.0,1.0f};
//        CGFloat end[4] = {249.0f/255.0, 249.0f/255.0, 249.0f/255.0,1.0f};
//        [cell setBackgroundView: [[CellbackgroundVIew alloc]initWithBeginRGBAFloatArray:begin andEndRGBAFloatArray:end]];
        
        
        
//        cell.layer.shadowOffset = CGSizeMake(0, 15);
//        cell.layer.shadowColor = [[UIColor blackColor] CGColor];
//        cell.layer.shadowRadius = 3;
//        cell.layer.shadowOpacity = .75f;
//        CGRect shadowFrame = cell.layer.bounds;
//        CGPathRef shadowPath = [UIBezierPath bezierPathWithRect:shadowFrame].CGPath;
//        cell.layer.shadowPath = shadowPath;
        
        return cell;
        //5
    }else{
        UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
        
//        CGFloat begin[4]= {243.0f/255.0, 243.0f/255.0, 243.0f/255.0,1.0f};
//        CGFloat end[4] = {249.0f/255.0, 249.0f/255.0, 249.0f/255.0,1.0f};
//        [cell setBackgroundView: [[CellbackgroundVIew alloc]initWithBeginRGBAFloatArray:begin andEndRGBAFloatArray:end]];
        
//        cell.layer.shadowOffset = CGSizeMake(0, 15);
//        cell.layer.shadowColor = [[UIColor blackColor] CGColor];
//        cell.layer.shadowRadius = 3;
//        cell.layer.shadowOpacity = .75f;
//        CGRect shadowFrame = cell.layer.bounds;
//        CGPathRef shadowPath = [UIBezierPath bezierPathWithRect:shadowFrame].CGPath;
//        cell.layer.shadowPath = shadowPath;
        
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1 && _datePickerVisible) {
        return 3;
    }else if(section == 0){
        return 2;
    }else{
        return [super tableView:tableView numberOfRowsInSection:section];
    }
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && indexPath.row == 2) {
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
        return [super tableView:tableView indentationLevelForRowAtIndexPath:newIndexPath];
    }else{
        return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.textField resignFirstResponder];
    if (indexPath.section == 1 && indexPath.row ==1) {
        if (!_datePickerVisible) {
            [self showDatePicker];
        }else{
            [self hideDatePicker];
        }
    }
}

- (IBAction)chooseNextTask:(id)sender {
    if (self.textField.text != nil) {
        self.saveBarButton.enabled = YES;
    }else{
        self.saveBarButton.enabled = NO;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && indexPath.row == 2) {
        return 217.0f;
    }else{
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

//- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == 1 && indexPath.row == 1) {
//        return indexPath;
//    }else{
//        return nil;
//    }
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}
#pragma mark - action
//3.让对象B在适当的时候向代理对象发送消息,⽐比如当⽤用户触碰cancel或done按钮时
- (IBAction)cancel:(id)sender {
    [self.delegate itemDetailViewControllerdidCancel:self];
   // [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)Save:(id)sender {
    if (self.itemToEdit == nil) {
        JobsItem *item = [[JobsItem alloc] init];
        item.text = self.textField.text;
        item.checked = NO;
        item.shouldRemind =self.switchControl.on;
        item.dueDate = _dueDate;
        item.nextTask = [self.nextTaskTextField titleForSegmentAtIndex:[self.nextTaskTextField selectedSegmentIndex]];
        [item scheduleNotification:self.companyName];
        [self.delegate itemDetailViewController:self didFinishAddingItem:item];
    }else{
        self.itemToEdit.text = self.textField.text;
        self.itemToEdit.nextTask= [self.nextTaskTextField titleForSegmentAtIndex:[self.nextTaskTextField selectedSegmentIndex]];
        self.itemToEdit.shouldRemind = self.switchControl.on;
        self.itemToEdit.dueDate = _dueDate;
        [self.itemToEdit scheduleNotification:self.companyName];
        [self.delegate itemDetailViewController:self didFinishEditingItem:self.itemToEdit];
    }
    
  //  [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - text
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self hideDatePicker];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([newText length]>0 && self.nextTaskTextField.selectedSegmentIndex!= -1) {
        self.saveBarButton.enabled = YES;
    }else{
        self.saveBarButton.enabled = NO;
    }
    return YES;
}
@end

















