//
//  ViewController.m
//  Jobs
//
//  Created by 王振辉 on 15/6/3.
//  Copyright (c) 2015年 王振辉. All rights reserved.
//

#import "ViewController.h"
#import "JobsItem.h"
@interface ViewController (){
    NSMutableArray *_items;
}

@end

@implementation ViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"AddItem"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        AddItemTableViewController *controller = (AddItemTableViewController *)navigationController.topViewController;
        controller.delegate = self;
    }else if([segue.identifier isEqualToString:@"EditItem"]){
        UINavigationController *navigationController = segue.destinationViewController;
        AddItemTableViewController *controller = (AddItemTableViewController *)navigationController.topViewController;
        controller.delegate = self;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        controller.itemToEdit = _items[indexPath.row];
    }
}

//5.通知对象B,对象A现在是它的代理。
- (void)addItemTableViewController:(AddItemTableViewController *)controller didFinishAddingItem:(JobsItem *)item{
    [self dismissViewControllerAnimated:YES completion:nil];
    NSInteger newRowIndex = [_items count];
    [_items addObject:item];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newRowIndex inSection:0];
    
    NSArray *indexPaths = @[indexPath];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addItemTableViewControllerdidCancel:(AddItemTableViewController *)controller{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addItemTableViewController:(AddItemTableViewController *)controller didFinishEditingItem:(JobsItem *)item{
    NSInteger index = [_items indexOfObject:item];
    NSIndexPath *indexPath =  [NSIndexPath indexPathForRow:index inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self configureTextForCell:cell withJobsItem:item];
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [_items removeObjectAtIndex:indexPath.row];
    NSArray *indexPaths = @[indexPath];
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}


- (void)configureCheckmarkForCell:(UITableViewCell *)cell withJobsItem:(JobsItem *)item{
    UILabel *label = (UILabel *)[cell viewWithTag:1001];
    
    if(item.checked){
       label.text = @"√";
    }else{
        label.text = @" ";
    }
}

- (void)configureTextForCell:(UITableViewCell *)cell withJobsItem:(JobsItem *)item{
    UILabel *lable = (UILabel *)[cell viewWithTag:1000];
    lable.text = item.text;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell =[tableView cellForRowAtIndexPath:indexPath];
    
    JobsItem *item = _items[indexPath.row];
    
    [item toggleChecked];
    
    [self configureCheckmarkForCell:cell withJobsItem:item];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//tell the tableView to show how many rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"JobsItem"];

    JobsItem *item = _items[indexPath.row];

    [self configureTextForCell:cell withJobsItem:item];
    [self configureCheckmarkForCell:cell withJobsItem:item];
    return cell;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _items = [[NSMutableArray alloc]initWithCapacity:20];
    
    JobsItem *item;
    
    item = [[JobsItem alloc] init];
    item.text =@"观看嫦娥⻜飞天";
    item.checked = NO;
    [_items addObject:item];
    
    item = [[JobsItem alloc] init];
    item.text =@"了解Sony a7和MBP";
    item.checked = NO;
    [_items addObject:item];
    
    item = [[JobsItem alloc] init];
    item.text =@"复习苍⽼老师";
    item.checked = NO;
    [_items addObject:item];
    
    item = [[JobsItem alloc] init];
    item.text =@"看⻄西甲巴萨新败";
    item.checked = NO;
    [_items addObject:item];
    
    item = [[JobsItem alloc] init];
    item.text =@"去电影院";
    item.checked = NO;
    [_items addObject:item];

    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
