//
//  ViewController.m
//  Jobs
//
//  Created by 王振辉 on 15/6/3.
//  Copyright (c) 2015年 王振辉. All rights reserved.
//

#import "ViewController.h"
#import "ItemDetailViewController.h"
#import "JobsItem.h"
#import "JobList.h"
#import "CellbackgroundVIew.h"
#import <MCSwipeTableViewCell.h>
@interface ViewController(){
    NSInteger cellHeight;
    NSInteger selectedRow;
}
@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    cellHeight = 100;
    self.title = self.jobList.name;
    selectedRow = -1;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
    [self.tableView addGestureRecognizer:longPress];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [backgroundView setBackgroundColor:[UIColor colorWithRed:227.0 / 255.0 green:227.0 / 255.0 blue:227.0 / 255.0 alpha:1.0]];
    [self.tableView setBackgroundView:backgroundView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.jobList.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"JobsItem"];
//     JobsItem *item = self.jobList.items[indexPath.row];
//    [self configureTextForCell:cell withJobsItem:item];
//    [self configureCheckmarkForCell:cell withJobsItem:item];
//    return cell;
    JobsItem *item = self.jobList.items[indexPath.row];
    static NSString *CellIdentifier = @"Cell";
    MCSwipeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[MCSwipeTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        // iOS 7 separator
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            cell.separatorInset = UIEdgeInsetsZero;
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        
        [self setBackgroundViewForCell:cell];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(cell.bounds.size.width/4*3, cellHeight/2-10, cell.bounds.size.width/4*1, 20)];
        label.font = [UIFont boldSystemFontOfSize:18];
        label.tag = 124;
        [cell.contentView addSubview:label];
        //  [self configureTextForCell:cell withIndexPath:indexPath];
    }
    
    NSLog(@"cellforrow");
    [self configureTextForCell:cell withJobsItem:item];
    [self configureStateOfCell:cell forRowAtIndexPath:indexPath ];
    [self configureCell:cell forRowAtIndexPath:indexPath];
    return cell;

    
}

- (void)configureTextForCell:(MCSwipeTableViewCell *)cell withJobsItem:(JobsItem *)item{
    
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:124];
    label.textColor =  [UIColor colorWithRed:213.0/255.0 green:73.0/255.0 blue:22.0/255.0 alpha:1];
    label.text = @"一面";
   // JobsItem *item = self.jobList.items[indexPath.row];
    //JobList *jobList = self.dataModel.jobs[indexPath.row];
    
    cell.textLabel.text = item.text;
    cell.textLabel.font = [UIFont systemFontOfSize:22.0];
    cell.textLabel.textColor = [UIColor colorWithRed:130.0/255.0 green:18.0/255.0 blue:13.0/255.0 alpha:1];
    cell.detailTextLabel.textColor =  [UIColor colorWithRed:121.0/255.0 green:67.0/255.0 blue:11.0/255.0 alpha:1];
    
    //cell.textLabel.text = item.text;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日hh时mm分"];
    NSString *time = [dateFormatter stringFromDate:item.dueDate];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",time];
    
//    if ([jobList.items count] != 0) {
//        
//        label.text= @"Offer";
//        cell.detailTextLabel.text = jobsItem.text;
//        
//    }else{
//        label.text=@"二面";
//        cell.detailTextLabel.text = @"暂未申请职位";
//    }
}

//- (void)configureCheckmarkForCell:(UITableViewCell *)cell withJobsItem:(JobsItem *)item{
//    if(item.checked){
//        cell.textLabel.textColor = [UIColor grayColor];
//        cell.detailTextLabel.textColor = [UIColor grayColor];
//        cell.accessoryView.backgroundColor = [UIColor redColor];
//        UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
//        cell.textLabel.font =font;
//        // cell.backgroundColor =[UIColor grayColor];
//        // label.text = @"√";
//    }else{
//        cell.textLabel.textColor = [UIColor blackColor];
//        cell.detailTextLabel.textColor = [UIColor blackColor];
//        //label.text = @" ";
//    }
//    // label.textColor = self.view.tintColor;
//}

//- (void)configureTextForCell:(UITableViewCell *)cell withJobsItem:(JobsItem *)item{
//    
//    cell.textLabel.text = item.text;
//    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//    [dateFormatter setDateFormat:@"yyyy年MM月dd日hh时mm分"];
//    NSString *time = [dateFormatter stringFromDate:item.dueDate];
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",time];
//    
//}

- (void)configureCell:(MCSwipeTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
   // JobList *jobList= self.dataModel.jobs[indexPath.row];
    JobsItem *jobsItem = self.jobList.items[indexPath.row];
    UIView *checkView = [self viewWithImageName:@"check"];
    UIColor *greenColor = [UIColor colorWithRed:85.0 / 255.0 green:213.0 / 255.0 blue:80.0 / 255.0 alpha:1.0];
    
    UIView *crossView = [self viewWithImageName:@"cross"];
    UIColor *redColor = [UIColor colorWithRed:232.0 / 255.0 green:61.0 / 255.0 blue:14.0 / 255.0 alpha:1.0];
    
    UIView *listView = [self viewWithImageName:@"list"];
    UIColor *brownColor = [UIColor colorWithRed:206.0 / 255.0 green:149.0 / 255.0 blue:98.0 / 255.0 alpha:1.0];
    
    //  UIView *upView = [self viewWithImageName:@"up"];
    
    // Setting the default inactive state color to the tableView background color
    [cell setDefaultColor:self.tableView.backgroundView.backgroundColor];
    [cell setDelegate:(id)self];
    
    if (jobsItem.checked == 0) {
        [cell setSwipeGestureWithView:crossView
                                color:redColor
                                 mode:MCSwipeTableViewCellModeSwitch
                                state:MCSwipeTableViewCellState1
                      completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode){
                          
                          [self changeStateofCell:cell];
                      }];
        [cell setSwipeGestureWithView:crossView
                                color:redColor
                                 mode:MCSwipeTableViewCellModeSwitch
                                state:MCSwipeTableViewCellState2
                      completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode){
                          
                          [self changeStateofCell:cell];
                      }];
        
        [cell setSwipeGestureWithView:listView
                                color:brownColor
                                 mode:MCSwipeTableViewCellModeExit
                                state:MCSwipeTableViewCellState3
                      completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
                          
                          UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"ItemNavigationController"];
                          ItemDetailViewController *controller = (ItemDetailViewController *)navigationController.topViewController;
                          controller.delegate = self;
                          //JobList *jobList = self.dataModel.jobs[indexPath.row];
                          
                          controller.itemToEdit = jobsItem;
                          [self presentViewController:navigationController animated:YES completion:nil];
                      }];
    }else if(jobsItem.checked == 1){
        [cell setSwipeGestureWithView:checkView
                                color:greenColor
                                 mode:MCSwipeTableViewCellModeSwitch
                                state:MCSwipeTableViewCellState1
                      completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode){
                          
                          [self changeStateofCell:cell];
                      }];
        [cell setSwipeGestureWithView:crossView
                                color:redColor
                                 mode:MCSwipeTableViewCellModeExit
                                state:MCSwipeTableViewCellState2
                      completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode){
                          
                          [self deleteCell:cell];
                      }];
        [cell setSwipeGestureWithView:listView
                                color:brownColor
                                 mode:MCSwipeTableViewCellModeExit
                                state:MCSwipeTableViewCellState3
                      completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
                          
                          UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"ItemNavigationController"];
                          ItemDetailViewController *controller = (ItemDetailViewController *)navigationController.topViewController;
                          controller.delegate = self;
                          //JobList *jobList = self.dataModel.jobs[indexPath.row];
                          
                          controller.itemToEdit = jobsItem;
                          [self presentViewController:navigationController animated:YES completion:nil];
                      }];
    }
    cell.firstTrigger = 0.25;
    cell.secondTrigger = 0.5;
}

- (void)configureStateOfCell:(MCSwipeTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
 //   JobList *jobList = self.dataModel.jobs[indexPath.row];
    JobsItem *jobsItem = self.jobList.items[indexPath.row];
    if (jobsItem.checked == 0) {
        UILabel *label = (UILabel *)[cell.contentView viewWithTag:124];
        label.textColor =  [UIColor colorWithRed:213.0/255.0 green:73.0/255.0 blue:22.0/255.0 alpha:1];
        cell.textLabel.textColor = [UIColor colorWithRed:130.0/255.0 green:18.0/255.0 blue:13.0/255.0 alpha:1];
        cell.detailTextLabel.textColor =  [UIColor colorWithRed:121.0/255.0 green:67.0/255.0 blue:11.0/255.0 alpha:1];
    }else if(jobsItem.checked == 1){
        UILabel *label = (UILabel *)[cell.contentView viewWithTag:124];
        label.textColor = [UIColor grayColor];
        cell.textLabel.textColor = [UIColor grayColor];
        cell.detailTextLabel.textColor =  [UIColor grayColor];
    }
}

- (void)setBackgroundViewForCell:(MCSwipeTableViewCell *)cell{
    CGFloat begin[4]= {243.0f/255.0, 243.0f/255.0, 243.0f/255.0,1.0f};
    CGFloat end[4] = {249.0f/255.0, 249.0f/255.0, 249.0f/255.0,1.0f};
    CGRect rect = CGRectMake(0, 0, self.view.bounds.size.width, cellHeight);
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, cellHeight)];
    backgroundView = (UIView *)[[CellbackgroundVIew alloc]initWithBeginRGBAFloatArray:begin andEndRGBAFloatArray:end andFrame:rect];
    [cell.contentView addSubview:backgroundView];
}

- (UIView *)viewWithImageName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeCenter;
    return imageView;
}

- (void)deleteCell:(MCSwipeTableViewCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.jobList.items removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
}

- (void)changeStateofCell:(MCSwipeTableViewCell *)cell {
    NSParameterAssert(cell);
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
   // JobList *jobList = self.dataModel.jobs[indexPath.row];
    JobsItem *jobsItem = self.jobList.items[indexPath.row];
    NSInteger disDeletedNum=0;
    //for(JobList *jobListTemp in self.dataModel.jobs){
    for(JobsItem *jobsItemTemp in self.jobList.items){
        if (jobsItemTemp.checked == 0) {
            disDeletedNum ++;
        }else{
            break;
        }
    }
    if (jobsItem.checked == 0) {
        jobsItem.checked =1;
        [self configureStateOfCell:cell forRowAtIndexPath:indexPath];
        [self.jobList.items removeObjectAtIndex:indexPath.row];
        [self.jobList.items insertObject:jobsItem atIndex:disDeletedNum-1];
        NSIndexPath *bottomIndexPath = [NSIndexPath indexPathForRow:disDeletedNum-1 inSection:0];
        [self.tableView moveRowAtIndexPath:indexPath toIndexPath:bottomIndexPath];
    }else if(jobsItem.checked == 1){
        jobsItem.checked = 0;
        [self configureStateOfCell:cell forRowAtIndexPath:indexPath];
        [self configureCell:cell forRowAtIndexPath:indexPath];
        [self.jobList.items removeObjectAtIndex:indexPath.row];
        [self.jobList.items insertObject:jobsItem atIndex:0];
        NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView moveRowAtIndexPath:indexPath toIndexPath:firstIndexPath];
    }
    
    NSInteger sum = [self.tableView numberOfRowsInSection:0];
    for (NSInteger i = 0; i < sum; ++i) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        MCSwipeTableViewCell *cell = (MCSwipeTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [self configureCell:cell forRowAtIndexPath:indexPath];
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   // MCSwipeTableViewCell *cell = (MCSwipeTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
//    if (indexPath.row == selectedRow) {
//      
//        return cellHeight*2;
//    }
//     NSLog(@"height");
    return cellHeight;
   
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.jobList.items removeObjectAtIndex:indexPath.row];
    NSArray *indexPaths = @[indexPath];
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    if (selectedRow != indexPath.row){
//        selectedRow = indexPath.row;
//    }else{
//        selectedRow = -1;}
//    
//    MCSwipeTableViewCell *cell = (MCSwipeTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
//    CGRect rect = cell.textLabel.frame;
//    rect.size.height =1;
//    cell.textLabel.frame = rect;
//    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    [tableView beginUpdates];
//    [tableView endUpdates];
//}

#pragma mark - ItemDetailViewControllerDelegate

- (void)itemDetailViewControllerdidCancel:(ItemDetailViewController *)controller{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)itemDetailViewController:(ItemDetailViewController *)controller didFinishAddingItem:(JobsItem *)item{

    [self.jobList.items insertObject:item atIndex:0];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    NSArray *indexPaths = @[indexPath];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)itemDetailViewController:(ItemDetailViewController *)controller didFinishEditingItem:(JobsItem *)item{
    NSInteger index = [self.jobList.items indexOfObject:item];
    NSIndexPath *indexPath =  [NSIndexPath indexPathForRow:index inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
   // [self configureTextForCell:cell withJobsItem:item];
    [self configureTextForCell:(MCSwipeTableViewCell *)cell withJobsItem:item];
    // [self saveJobsItems];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - LongPressGesture
- (IBAction)longPressGestureRecognized:(id)sender {
    
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;
    
    CGPoint location = [longPress locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    
    static UIView       *snapshot = nil;        ///< A snapshot of the row user is moving.
    static NSIndexPath  *sourceIndexPath = nil; ///< Initial index path, where gesture begins.
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                sourceIndexPath = indexPath;
                
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                
                // Take a snapshot of the selected row using helper method.
                snapshot = [self customSnapshoFromView:cell];
                
                // Add the snapshot as subview, centered at cell's center...
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [self.tableView addSubview:snapshot];
                [UIView animateWithDuration:0.25 animations:^{
                    
                    // Offset for gesture location.
                    center.y = location.y;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98;
                    cell.alpha = 0.0;
                    
                } completion:^(BOOL finished) {
                    
                    cell.hidden = YES;
                    
                }];
            }
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            CGPoint center = snapshot.center;
            center.y = location.y;
            snapshot.center = center;
            
            // Is destination valid and is it different from source?
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                
                // ... update data source.
                [self.jobList.items exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                
                // ... move the rows.
                [self.tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                
                // ... and update source so it is in sync with UI changes.
                sourceIndexPath = indexPath;
            }
            break;
        }
            
        default: {
            // Clean up.
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:sourceIndexPath];
            cell.hidden = NO;
            cell.alpha = 0.0;
            
            [UIView animateWithDuration:0.25 animations:^{
                
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
                cell.alpha = 1.0;
                
            } completion:^(BOOL finished) {
                
                sourceIndexPath = nil;
                [snapshot removeFromSuperview];
                snapshot = nil;
                
            }];
            
            break;
        }
    }
}
- (UIView *)customSnapshoFromView:(UIView *)inputView {
    
    // Make an image from the input view.
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Create an image view.
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}

@end
