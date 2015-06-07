//
//  ViewController.m
//  Jobs
//
//  Created by 王振辉 on 15/6/3.
//  Copyright (c) 2015年 王振辉. All rights reserved.
//

#import "ViewController.h"
#import "JobsItem.h"
#import "JobList.h"
@interface ViewController()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.jobList.name;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"AddItem"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        ItemDetailViewController *controller = (ItemDetailViewController *)navigationController.topViewController;
        controller.delegate = self;
    }else if([segue.identifier isEqualToString:@"EditItem"]){
        UINavigationController *navigationController = segue.destinationViewController;
        ItemDetailViewController *controller = (ItemDetailViewController *)navigationController.topViewController;
        controller.delegate = self;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        controller.itemToEdit = self.jobList.items[indexPath.row];
    }
}


#pragma mark - Action response

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.jobList.items removeObjectAtIndex:indexPath.row];
    NSArray *indexPaths = @[indexPath];
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell =[tableView cellForRowAtIndexPath:indexPath];
    JobsItem *item = self.jobList.items[indexPath.row];
    [item toggleChecked];
    [self configureCheckmarkForCell:cell withJobsItem:item];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - TableView
- (void)configureCheckmarkForCell:(UITableViewCell *)cell withJobsItem:(JobsItem *)item{
    if(item.checked){
        cell.textLabel.textColor = [UIColor grayColor];
        cell.detailTextLabel.textColor = [UIColor grayColor];
        cell.accessoryView.backgroundColor = [UIColor redColor];
      // label.text = @"√";
    }else{
        cell.textLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.textColor = [UIColor blackColor];
        //label.text = @" ";
    }
   // label.textColor = self.view.tintColor;
}

- (void)configureTextForCell:(UITableViewCell *)cell withJobsItem:(JobsItem *)item{

    cell.textLabel.text = item.text;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日hh时mm分"];
    NSString *time = [dateFormatter stringFromDate:item.dueDate];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",time];

}

//tell the tableView to show how many rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.jobList.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"JobsItem"];
    JobsItem *item = self.jobList.items[indexPath.row];
    [self configureTextForCell:cell withJobsItem:item];
    [self configureCheckmarkForCell:cell withJobsItem:item];
    
    //cell.detailTextLabel.text = @"sadasdasd";
    return cell;
}




#pragma mark - ItemDetailViewControllerDelegate
//5.通知对象B,对象A现在是它的代理。
- (void)itemDetailViewController:(ItemDetailViewController *)controller didFinishAddingItem:(JobsItem *)item{
    //[self dismissViewControllerAnimated:YES completion:nil];
    NSInteger newRowIndex = [self.jobList.items count];
    [self.jobList.items addObject:item];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newRowIndex inSection:0];
    
    NSArray *indexPaths = @[indexPath];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    // [self saveJobsItems];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)itemDetailViewControllerdidCancel:(ItemDetailViewController *)controller{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)itemDetailViewController:(ItemDetailViewController *)controller didFinishEditingItem:(JobsItem *)item{
    NSInteger index = [self.jobList.items indexOfObject:item];
    NSIndexPath *indexPath =  [NSIndexPath indexPathForRow:index inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self configureTextForCell:cell withJobsItem:item];
    // [self saveJobsItems];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
