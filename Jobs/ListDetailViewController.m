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
//@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@end

@implementation ListDetailViewController{
    NSString *_iconName;
}

#pragma mark - view
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.jobListToEdit != nil) {
        self.title = @"编辑公司";
        self.textField.text = self.jobListToEdit.name;
        self.saveBarButton.enabled = YES;
        _iconName = self.jobListToEdit.iconName;
    }
 //   self.iconImageView.image = [UIImage imageNamed:_iconName];
    
    self.navigationController.navigationBar.layer.shadowColor = [UIColor blackColor].CGColor; //shadowColor阴影颜色
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(2.0f , 2.0f); //shadowOffset阴影偏移x，y向(上/下)偏移(-/+)2
    self.navigationController.navigationBar.layer.shadowOpacity = 0.25f;//阴影透明度，默认0
    self.navigationController.navigationBar.layer.shadowRadius = 4.0f;//阴影半径
    
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureRecognized:)];
//    [self.tableView addGestureRecognizer:tap];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

//- (IBAction)tapGestureRecognized:(id)sender{
//    UITapGestureRecognizer *longPress = (UITapGestureRecognizer *)sender;
//    // UITapGestureRecognizer *state = longPress.state;
//    
//    CGPoint location = [longPress locationInView:self.tableView];
//    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
//    if (indexPath == nil) {
//        [self.textField resignFirstResponder];
//    }else{
//[self tableView:self.tableView willSelectRowAtIndexPath:indexPath];
//    }
//}

- (void )tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row==0) {
        [self.textField resignFirstResponder];
    }
    //return indexPath;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.textField becomeFirstResponder];
}


- (id)initWithCoder:(NSCoder *)aDecoder{
    if ((self = [super initWithCoder:aDecoder])) {
        _iconName = @"1";
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
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    self.saveBarButton.enabled = ([newText length]>0);
    return YES;
}




#pragma mark - IconPickerViewControllerDelegate
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"PickIcon"]) {
        IconPickerViewController *controller = segue.destinationViewController;
        controller.delegate = self;
    }
}

#pragma mark - IconPickerViewControllerDelegate
- (void)iconPicker:(IconPickerViewController *)picker didPickIcon:(NSString *)iconName{
    _iconName = iconName;
   // self.iconImageView.image = [UIImage imageNamed:_iconName];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - IBAction

- (IBAction)cancel:(id)sender{
    [self.delegate listDetailViewControllerDidCancel:self];
}

- (IBAction)save:(id)sender{
    if (self.jobListToEdit == nil) {
        JobList *jobList = [[JobList alloc]init];
        jobList.name = self.textField.text;
        jobList.iconName = _iconName;
        [self.delegate listDetailViewController:self didFinishAddingJoblist:jobList];
    }else{
        self.jobListToEdit.name = self.textField.text;
        self.jobListToEdit.iconName = _iconName;
        [self.delegate listDetailViewController:self didFinishEditingJobList:self.jobListToEdit];
    }
}

@end
