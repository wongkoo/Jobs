//
//  AllListsViewController.m
//  Jobs
//
//  Created by 王振辉 on 15/6/4.
//  Copyright (c) 2015年 王振辉. All rights reserved.
//

#import "AllListsViewController.h"
#import "JobList.h"
#import "ViewController.h"
#import "jobsItem.h"
#import "DataModel.h"
#import "CellbackgroundVIew.h"
#import <MCSwipeTableViewCell.h>
#import "AppDelegate.h"
#import "UIColor+WHColor.h"

@interface AllListsViewController (){
    NSInteger cellHeight;
}

@property (nonatomic, weak)     IBOutlet UILabel *allApplicationNumLabel;
@property (nonatomic, strong)   UILongPressGestureRecognizer *longPress;
@property (nonatomic)           BOOL forceTouchAvailable;
@property (nonatomic, strong)   NSIndexPath *indexPathOfForceTouch;

@end

@implementation AllListsViewController

#pragma mark - View Life Cycle
- (void)viewDidLoad {
    NSLog(@"didLoad");
    [super viewDidLoad];
    [self updateAllApplicationNum];
    
    cellHeight = 80;
//    _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
//    _longPress.minimumPressDuration = 0.7;
//    [self.tableView addGestureRecognizer:_longPress];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [backgroundView setBackgroundColor:[UIColor colorWithRed:227.0 / 255.0 green:227.0 / 255.0 blue:227.0 / 255.0 alpha:1.0]];
    [self.tableView setBackgroundView:backgroundView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"will");
    [super viewWillAppear:animated];
    [self updateAllApplicationNum];
    [self.tableView reloadData];
    [self checkForceTouch];
}

- (void)viewDidAppear:(BOOL)animated{
    NSLog(@"didAppear");
    [super viewDidAppear:animated];
    self.navigationController.delegate = self;
    self.tableView.showsVerticalScrollIndicator =NO; //去除右边滚动条！
    NSInteger index = [self.dataModel indexOfSelectedJobList];
    if (index >=0 && index <[self.dataModel.jobs count]) {
        JobList *jobList = self.dataModel.jobs[index];
        [self performSegueWithIdentifier:@"ShowJobList" sender:jobList];
    }
}

- (void)checkForceTouch {
    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        _forceTouchAvailable = YES;
    }else{
        _forceTouchAvailable = NO;
        NSLog(@"3D Touch is not available on this device. Sorry!");
    }
}

- (void)updateAllApplicationNum{
    NSInteger tempNum = 0;
    for (JobList *jobList in self.dataModel.jobs){
        if(jobList.deletedFlag == 0){
            for(JobsItem *jobsItem in jobList.items){
            if (jobsItem.checked == 0) {
                 tempNum ++;
                }
            }
        }
    }
    self.allApplicationNumLabel.text=[NSString stringWithFormat:@"%ld个职位正在进行中",(long)tempNum];
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ShowJobList"]) {
        ViewController *controller = segue.destinationViewController;
        controller.jobList = sender;
    }else if([segue.identifier isEqualToString:@"AddJobList"]){
        UINavigationController *navigationController = segue.destinationViewController;
        ListDetailViewController *controller = (ListDetailViewController *)navigationController.topViewController;
        controller.delegate = self;
        controller.jobListToEdit = nil;
    }
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    MCSwipeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (!cell) {
        cell = [[MCSwipeTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        // iOS 7 separator
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            cell.separatorInset = UIEdgeInsetsZero;
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        [self setBackgroundViewForCell:cell];
        
        UILabel *label =[[UILabel alloc]init];
        label.font = [UIFont boldSystemFontOfSize:18];
        label.tag = 123;
        [cell.contentView addSubview:label];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        
        //AutoLayout
        NSArray *constraints1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[label]-|"
                                                                        options:0
                                                                        metrics:@{@"margin":@60}
                                                                          views:NSDictionaryOfVariableBindings(label)];
        NSArray *constraints2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[label]|"
                                                                        options:0
                                                                        metrics:@{@"heigth":@40}
                                                                          views:NSDictionaryOfVariableBindings(label)];
        [cell.contentView addConstraints:constraints1];
        [cell.contentView addConstraints:constraints2];

    }
    
    
    [self configureTextForCell:cell withIndexPath:indexPath];
    [self configureStateOfCell:cell forRowAtIndexPath:indexPath ];
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    if (_forceTouchAvailable) {
        [self registerForPreviewingWithDelegate:self sourceView:cell];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.dataModel.jobs count];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    editingStyle = UITableViewCellEditingStyleInsert;
}

- (void)configureTextForCell:(MCSwipeTableViewCell *)cell withIndexPath:(NSIndexPath *)indexPath{
    [self updateAllApplicationNum];
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:123];
    label.textColor =  [UIColor colorWithRed:213.0/255.0 green:73.0/255.0 blue:22.0/255.0 alpha:1];
    
    JobList *jobList = self.dataModel.jobs[indexPath.row];
    
    cell.textLabel.text = jobList.name;
    cell.textLabel.font = [UIFont systemFontOfSize:22.0];
    cell.textLabel.textColor = [UIColor colorWithRed:130.0/255.0 green:18.0/255.0 blue:13.0/255.0 alpha:1];
    cell.detailTextLabel.textColor =  [UIColor colorWithRed:121.0/255.0 green:67.0/255.0 blue:11.0/255.0 alpha:1];
    
    if ([jobList.items count] != 0) {
        JobsItem *jobsItem = jobList.items[0];
        
        NSDate *  senddate=[NSDate date];
        NSDateFormatter  *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MMdd"];

        NSString *now=[dateFormatter stringFromDate:senddate];
        NSString *targetTime = [dateFormatter stringFromDate:jobsItem.dueDate];
        
        NSInteger nowValue = [now integerValue];
        NSInteger targetTimeValue = [targetTime integerValue];
        
        if((targetTimeValue - nowValue) >= 31){
            NSDateFormatter *dateFormatterToShow = [[NSDateFormatter alloc] init];
            [dateFormatterToShow setDateFormat:@"M月d日 "];
            NSString *showTime = [dateFormatterToShow stringFromDate:jobsItem.dueDate];
             label.text = [showTime stringByAppendingString:jobsItem.nextTask];
        }else if((targetTimeValue - nowValue) >= 3 && (targetTimeValue - nowValue) <= 30){
            NSString *string = [NSString stringWithFormat:@"%ld天后 ",(long)(targetTimeValue - nowValue)];
            label.text =[string stringByAppendingString:jobsItem.nextTask];
        }else if((targetTimeValue - nowValue) == 2){
            label.text = [@"后天 " stringByAppendingString:jobsItem.nextTask];
        }else if((targetTimeValue - nowValue) == 1){
            label.text = [@"明天 " stringByAppendingString:jobsItem.nextTask];
        }else if((targetTimeValue - nowValue) == 0){
            label.text = [@"今天 " stringByAppendingString:jobsItem.nextTask];
        }else if((targetTimeValue - nowValue) == -1){
            label.text=[@"昨天 " stringByAppendingString:jobsItem.nextTask];
        }else if((targetTimeValue - nowValue) == -2){
            label.text=[@"前天 " stringByAppendingString:jobsItem.nextTask];
        }else if((targetTimeValue - nowValue) <= -3){
            label.text=[@"几天前 " stringByAppendingString:jobsItem.nextTask];
        }


        cell.detailTextLabel.text = jobsItem.text;
        
    }else{
        label.text=@"";
        cell.detailTextLabel.text = @"暂未申请职位";
    }
}

- (void)configureCell:(MCSwipeTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    JobList *jobList= self.dataModel.jobs[indexPath.row];
    UIView *checkView = [self viewWithImageName:@"check"];
    UIColor *greenColor = [UIColor colorWithRed:85.0 / 255.0 green:213.0 / 255.0 blue:80.0 / 255.0 alpha:1.0];
    
    UIView *crossView = [self viewWithImageName:@"cross"];
    UIColor *redColor = [UIColor colorWithRed:232.0 / 255.0 green:61.0 / 255.0 blue:14.0 / 255.0 alpha:1.0];
    
    UIView *listView = [self viewWithImageName:@"list"];
    UIColor *brownColor = [UIColor colorWithRed:206.0 / 255.0 green:149.0 / 255.0 blue:98.0 / 255.0 alpha:1.0];
    
    UIView *stickView = [self viewWithImageName:@"stick"];
    UIColor *stickColor = [UIColor whAmethyst];
    
    // Setting the default inactive state color to the tableView background color
    [cell setDefaultColor:self.tableView.backgroundView.backgroundColor];
    [cell setDelegate:(id)self];
    
    if (jobList.deletedFlag == 0) {
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
                          
                          UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"ListNavigationController"];
                          ListDetailViewController *controller = (ListDetailViewController *)navigationController.topViewController;
                          controller.delegate = self;
                          JobList *jobList = self.dataModel.jobs[indexPath.row];
                          controller.jobListToEdit = jobList;
                          [self presentViewController:navigationController animated:YES completion:nil];
                      }];
        
        [cell setSwipeGestureWithView:stickView
                                color:stickColor
                                 mode:MCSwipeTableViewCellModeSwitch
                                state:MCSwipeTableViewCellState4
                      completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
                          NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
                          [self.dataModel.jobs insertObject:self.dataModel.jobs[indexPath.row] atIndex:0];
                          [self.dataModel.jobs removeObjectAtIndex:(indexPath.row + 1)];
                          [self.tableView moveRowAtIndexPath:[self.tableView indexPathForCell:cell] toIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                      }];
        
        
    }else if(jobList.deletedFlag == 1){
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
                          
                          UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"ListNavigationController"];
                          ListDetailViewController *controller = (ListDetailViewController *)navigationController.topViewController;
                          controller.delegate = self;
                          JobList *jobList = self.dataModel.jobs[indexPath.row];
                          controller.jobListToEdit = jobList;
                          [self presentViewController:navigationController animated:YES completion:nil];
                      }];
        [cell setSwipeGestureWithView:listView
                                color:brownColor
                                 mode:MCSwipeTableViewCellModeExit
                                state:MCSwipeTableViewCellState4
                      completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
                          
                          UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"ListNavigationController"];
                          ListDetailViewController *controller = (ListDetailViewController *)navigationController.topViewController;
                          controller.delegate = self;
                          JobList *jobList = self.dataModel.jobs[indexPath.row];
                          controller.jobListToEdit = jobList;
                          [self presentViewController:navigationController animated:YES completion:nil];
                      }];
    }
    cell.firstTrigger = 0.25;
    cell.secondTrigger = 0.4;
}

- (void)configureStateOfCell:(MCSwipeTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    JobList *jobList = self.dataModel.jobs[indexPath.row];
    if (jobList.deletedFlag == 0) {
        UILabel *label = (UILabel *)[cell.contentView viewWithTag:123];
        label.textColor =  [UIColor colorWithRed:213.0/255.0 green:73.0/255.0 blue:22.0/255.0 alpha:1];
        cell.textLabel.textColor = [UIColor colorWithRed:130.0/255.0 green:18.0/255.0 blue:13.0/255.0 alpha:1];
        cell.detailTextLabel.textColor =  [UIColor colorWithRed:121.0/255.0 green:67.0/255.0 blue:11.0/255.0 alpha:1];
    }else if(jobList.deletedFlag == 1){
        UILabel *label = (UILabel *)[cell.contentView viewWithTag:123];
        label.textColor = [UIColor grayColor];
        cell.textLabel.textColor = [UIColor grayColor];
        cell.detailTextLabel.textColor =  [UIColor grayColor];
    }
    [self updateAllApplicationNum];
}

- (void)setBackgroundViewForCell:(MCSwipeTableViewCell *)cell{
    //UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, cellHeight)];
    //backgroundView = [(UIView *)[CellbackgroundVIew alloc]init];
    [cell setBackgroundView:[[CellbackgroundVIew alloc]init]];
}

- (UIView *)viewWithImageName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeCenter;
    return imageView;
}

- (void)deleteCell:(MCSwipeTableViewCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self cancelLocalNotificationIndex:indexPath.row];
    [self.dataModel.jobs removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
}

- (void)cancelLocalNotificationIndex:(NSInteger)index{
    JobList *jobList = self.dataModel.jobs[index];
    for (JobsItem *temp in jobList.items){
        if (temp.shouldRemind == YES) {
            UILocalNotification *existingNotification = [temp notificationForThisItem];
            if (existingNotification != nil) {
                [[UIApplication sharedApplication]cancelLocalNotification:existingNotification];
            }
        }
    }
}

- (void)changeStateofCell:(MCSwipeTableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    JobList *jobList = self.dataModel.jobs[indexPath.row];
    NSInteger disDeletedNum=0;
    for(JobList *jobListTemp in self.dataModel.jobs){
        if (jobListTemp.deletedFlag == 0) {
            disDeletedNum ++;
        }else{
            break;
        }
    }
    if (disDeletedNum == 0) {
        disDeletedNum =1;
    }
    if (jobList.deletedFlag == 0) {
        jobList.deletedFlag =1;
        [self configureStateOfCell:cell forRowAtIndexPath:indexPath];
        [self.dataModel.jobs removeObjectAtIndex:indexPath.row];
        [self.dataModel.jobs insertObject:jobList atIndex:disDeletedNum-1];
        NSIndexPath *bottomIndexPath = [NSIndexPath indexPathForRow:disDeletedNum-1 inSection:0];
        [self.tableView moveRowAtIndexPath:indexPath toIndexPath:bottomIndexPath];
    }else if(jobList.deletedFlag == 1){
        jobList.deletedFlag = 0;
        [self configureStateOfCell:cell forRowAtIndexPath:indexPath];
        [self configureCell:cell forRowAtIndexPath:indexPath];
        [self.dataModel.jobs removeObjectAtIndex:indexPath.row];
        [self.dataModel.jobs insertObject:jobList atIndex:0];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.dataModel setIndexOfSelectedJobList:indexPath.row];
    JobList *jobList = self.dataModel.jobs[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self performSegueWithIdentifier:@"ShowJobList" sender:jobList];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight;
}

#pragma mark - UINavigationControllerDelegate
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (viewController == self) {
        [self.dataModel setIndexOfSelectedJobList:-1];
    }
}

#pragma mark - UIViewControllerPreviewingDelegate
- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    
    _indexPathOfForceTouch = [self.tableView indexPathForCell:(MCSwipeTableViewCell *)previewingContext.sourceView];
//    _indexPathOfForceTouch = [self.tableView indexPathForRowAtPoint:location];
    [self.tableView deselectRowAtIndexPath:_indexPathOfForceTouch animated:NO];
    
    if ([self.presentedViewController isKindOfClass:[ViewController class]]) {
        ViewController *previewController = (ViewController *)self.presentedViewController;
        previewController.jobList = self.dataModel.jobs[_indexPathOfForceTouch.row];
        previewController.delegate = self;
        return nil;
    }
    
    ViewController *previewController = [[ViewController alloc]init];
    previewController.jobList  = self.dataModel.jobs[_indexPathOfForceTouch.row];
    previewController.delegate = self;
    return previewController;
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    
    [self.dataModel setIndexOfSelectedJobList:_indexPathOfForceTouch.row];
    JobList *jobList = self.dataModel.jobs[_indexPathOfForceTouch.row];
    [self.tableView deselectRowAtIndexPath:_indexPathOfForceTouch animated:NO];
    [self performSegueWithIdentifier:@"ShowJobList" sender:jobList];

}

#pragma mark - ViewController3DTouchDelegate
- (void)deleteJoblist:(JobList *)joblist {
    NSInteger index = [self.dataModel.jobs indexOfObject:joblist];
    [self.dataModel.jobs removeObject:joblist];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}
- (void)addPositionInJoblist:(JobList *)joblist {
    NSInteger index = [self.dataModel.jobs indexOfObject:joblist];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    JobList *jobList = self.dataModel.jobs[indexPath.row];
    joblist.addPositionBy3DTouch = YES;
    [self performSegueWithIdentifier:@"ShowJobList" sender:jobList];
}

#pragma mark - ListDetailViewControllerDelegate
- (void)listDetailViewControllerDidCancel:(ListDetailViewController *)controller{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)listDetailViewController:(ListDetailViewController *)controller didFinishAddingJoblist:(JobList *)jobList{
  //  NSInteger newRowIndex = [self.dataModel.jobs count];
    [self.dataModel.jobs insertObject:jobList atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    NSArray *indexPaths = @[indexPath];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)listDetailViewController:(ListDetailViewController *)controller didFinishEditingJobList:(JobList *)jobList{
    NSInteger index = [self.dataModel.jobs indexOfObject:jobList];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    //cell.textLabel.text = jobList.name;
    //JobList *jobList = self.dataModel.jobs[indexPath.row];
    
    UILabel *textLabel = (UILabel *)[cell viewWithTag:2];
    textLabel.text = jobList.name;
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//#pragma mark - longPressGesture
//- (IBAction)longPressGestureRecognized:(id)sender {
//    
//    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
//    UIGestureRecognizerState state = longPress.state;
//    
//    CGPoint location = [longPress locationInView:self.tableView];
//    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
//    
//    static UIView       *snapshot = nil;        ///< A snapshot of the row user is moving.
//    static NSIndexPath  *sourceIndexPath = nil; ///< Initial index path, where gesture begins.
//    
//    switch (state) {
//        case UIGestureRecognizerStateBegan: {
//            if (indexPath) {
//                sourceIndexPath = indexPath;
//                
//                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
//                
//                // Take a snapshot of the selected row using helper method.
//                snapshot = [self customSnapshoFromView:cell];
//                
//                // Add the snapshot as subview, centered at cell's center...
//                __block CGPoint center = cell.center;
//                snapshot.center = center;
//                snapshot.alpha = 0.0;
//                [self.tableView addSubview:snapshot];
//                [UIView animateWithDuration:0.25 animations:^{
//                    
//                    // Offset for gesture location.
//                    center.y = location.y;
//                    snapshot.center = center;
//                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
//                    snapshot.alpha = 0.98;
//                    cell.alpha = 0.0;
//                    
//                } completion:^(BOOL finished) {
//                    
//                    cell.hidden = YES;
//                    
//                }];
//            }
//            break;
//        }
//            
//        case UIGestureRecognizerStateChanged: {
//            CGPoint center = snapshot.center;
//            center.y = location.y;
//            snapshot.center = center;
//            
//            // Is destination valid and is it different from source?
//            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
//                
//                // ... update data source.
//                [self.dataModel.jobs exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
//                
//                // ... move the rows.
//                [self.tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
//                
//                // ... and update source so it is in sync with UI changes.
//                sourceIndexPath = indexPath;
//            }
//            break;
//        }
//            
//        default: {
//            // Clean up.
//            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:sourceIndexPath];
//            cell.hidden = NO;
//            cell.alpha = 0.0;
//            
//            [UIView animateWithDuration:0.25 animations:^{
//                
//                snapshot.center = cell.center;
//                snapshot.transform = CGAffineTransformIdentity;
//                snapshot.alpha = 0.0;
//                cell.alpha = 1.0;
//                
//            } completion:^(BOOL finished) {
//                
//                sourceIndexPath = nil;
//                [snapshot removeFromSuperview];
//                snapshot = nil;
//                
//            }];
//            
//            break;
//        }
//    }
//}
//
//- (UIView *)customSnapshoFromView:(UIView *)inputView {
//    
//    // Make an image from the input view.
//    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
//    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    // Create an image view.
//    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
//    snapshot.layer.masksToBounds = NO;
//    snapshot.layer.cornerRadius = 0.0;
//    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
//    snapshot.layer.shadowRadius = 5.0;
//    snapshot.layer.shadowOpacity = 0.4;
//    
//    return snapshot;
//}
//
@end
