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

//5.通知对象B,对象A现在是它的代理。
- (void)itemDetailViewController:(ItemDetailViewController *)controller didFinishAddingItem:(JobsItem *)item{
    [self dismissViewControllerAnimated:YES completion:nil];
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



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.jobList.items removeObjectAtIndex:indexPath.row];
   // [self saveJobsItems];
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
    
    JobsItem *item = self.jobList.items[indexPath.row];
    
    [item toggleChecked];
    
    [self configureCheckmarkForCell:cell withJobsItem:item];
   // [self saveJobsItems];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    return cell;
}

//- (id)initWithCoder:(NSCoder *)aDecoder{
//    if ((self = [super initWithCoder:aDecoder])) {
//        [self loadJobsItems];
//    }
//    return self;
//}

//- (void)loadJobsItems{
//    NSString *path = [self dataFilePath];
//    if ([[NSFileManager defaultManager]fileExistsAtPath:path]) {
//        NSData *data = [[NSData alloc]initWithContentsOfFile:path];
//        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
//        _items = [unarchiver decodeObjectForKey:@"JobsItems"];
//        [unarchiver finishDecoding];
//    }else{
//        _items = [[NSMutableArray alloc] initWithCapacity:20];
//    }
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.jobList.name;
//    NSLog(@"文件夹的路径是：%@",[self documentsDirectory]);
//    NSLog(@"数据文件的最终路径是：%@",[self dataFilePath]);
 
    // Do any additional setup after loading the view, typically from a nib.
}

//- (NSString *)documentsDirectory{
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths firstObject];
//    return documentsDirectory;
//}

//- (NSString *)dataFilePath{
//    return [[self documentsDirectory]stringByAppendingPathComponent:@"Jobs.plist"];
//}

//- (void)saveJobsItems{
//    NSMutableData *data = [[NSMutableData alloc] init];
//    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
//    [archiver encodeObject:_items forKey:@"JobsItems"];
//    [archiver finishEncoding];
//    [data writeToFile:[self dataFilePath] atomically:YES];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
