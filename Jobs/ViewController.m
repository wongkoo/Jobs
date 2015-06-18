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
#import <BFPaperCheckbox.h>
#import "UIColor+BFPaperColors.h"
@interface ViewController(){
    NSInteger cellHeight;
    NSInteger differFromNowToTarget;
    NSTimer *countDownTimer;
    UIView *stageDetailView;
    UIVisualEffectView *visualEffectView;
}
@property (weak, nonatomic) IBOutlet UILabel *detailTextView;
@property (nonatomic, strong) UILabel *countDownTimerLabel;
@property (nonatomic, strong) NSMutableArray *checkboxs;

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
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [backgroundView setBackgroundColor:[UIColor colorWithRed:227.0 / 255.0 green:227.0 / 255.0 blue:227.0 / 255.0 alpha:1.0]];
    [self.tableView setBackgroundView:backgroundView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self initCheckboxs];
    [self initDetailTextView];
}

- (void)initCheckboxs{
    self.checkboxs = [[NSMutableArray alloc]initWithCapacity:20];
    for (NSInteger i =0; i<[self.jobList.items count]; ++i) {
        JobsItem *item =self.jobList.items[i];
        BFPaperCheckbox *checkbox = [[BFPaperCheckbox alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-cellHeight, 0, cellHeight, cellHeight)];
        checkbox.tag = i;
        if (item.checked == 0) {
            [self.checkboxs addObject:checkbox];
        }else if(item.checked == 1){
            [checkbox checkAnimated:YES];
            [self.checkboxs addObject:checkbox];
        }
        
    }
}

- (void)initDetailTextView{
    self.detailTextView.text = @" ";
    if (![self.jobList.accountOfWebsite isEqualToString:@""]) {
        self.detailTextView.text = [self.detailTextView.text stringByAppendingFormat:@"官网账号：%@\n",self.jobList.accountOfWebsite];
    }
    if (![self.jobList.reminderOfPassword isEqualToString:@""]) {
        self.detailTextView.text = [self.detailTextView.text stringByAppendingFormat:@"密码提示：%@\n",self.jobList.reminderOfPassword];
    }
    if (![self.jobList.email isEqualToString:@""]) {
        self.detailTextView.text = [self.detailTextView.text stringByAppendingFormat:@"报名邮箱：%@",self.jobList.email];
    }
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
        controller.companyName = self.jobList.name;
    }else if([segue.identifier isEqualToString:@"EditItem"]){
        UINavigationController *navigationController = segue.destinationViewController;
        ItemDetailViewController *controller = (ItemDetailViewController *)navigationController.topViewController;
        controller.delegate = self;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        controller.itemToEdit = self.jobList.items[indexPath.row];
        controller.companyName = self.jobList.name;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.jobList.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width/4*1, 20)];
        label.center = CGPointMake(self.view.bounds.size.width-cellHeight/3*2, cellHeight/2);
        label.font = [UIFont boldSystemFontOfSize:18];
        label.tag = 124;
        [cell.contentView addSubview:label];
        
        BFPaperCheckbox *paperCheckbox = self.checkboxs[indexPath.row];
        paperCheckbox.frame =CGRectMake(self.view.bounds.size.width-cellHeight, 0, cellHeight, cellHeight);
        paperCheckbox.center = CGPointMake(self.view.bounds.size.width-cellHeight/2, cellHeight/2);
        paperCheckbox.delegate = self;
        paperCheckbox.rippleFromTapLocation = NO;
        paperCheckbox.tapCirclePositiveColor = [UIColor paperColorAmber]; // We could use [UIColor colorWithAlphaComponent] here to make a better tap-circle.
        paperCheckbox.tapCircleNegativeColor = [UIColor paperColorRed];   // We could use [UIColor colorWithAlphaComponent] here to make a better tap-circle.
        paperCheckbox.checkmarkColor = [UIColor paperColorLightBlue];
        [cell.contentView addSubview:paperCheckbox];
    }
    [self configureTextForCell:cell withJobsItem:item];
    [self configureStateOfCell:cell forRowAtIndexPath:indexPath ];
    [self configureCell:cell forRowAtIndexPath:indexPath];
    return cell;
}

#pragma mark - Deal with Cells

- (void)configureTextForCell:(MCSwipeTableViewCell *)cell withJobsItem:(JobsItem *)item{
    
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:124];
    label.textColor =  [UIColor colorWithRed:213.0/255.0 green:73.0/255.0 blue:22.0/255.0 alpha:1];
    label.text = item.nextTask;
    
    cell.textLabel.text = item.text;
    cell.textLabel.font = [UIFont systemFontOfSize:22.0];
    cell.textLabel.textColor = [UIColor colorWithRed:130.0/255.0 green:18.0/255.0 blue:13.0/255.0 alpha:1];
    cell.detailTextLabel.textColor =  [UIColor colorWithRed:121.0/255.0 green:67.0/255.0 blue:11.0/255.0 alpha:1];
    
    //cell.textLabel.text = item.text;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"M月dd日hh时mm分"];
    NSString *time = [dateFormatter stringFromDate:item.dueDate];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",time];
}

- (void)configureCell:(MCSwipeTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    JobsItem *jobsItem = self.jobList.items[indexPath.row];
    UIView *crossView = [self viewWithImageName:@"cross"];
    UIColor *redColor = [UIColor colorWithRed:232.0 / 255.0 green:61.0 / 255.0 blue:14.0 / 255.0 alpha:1.0];
    UIView *listView = [self viewWithImageName:@"list"];
    UIColor *brownColor = [UIColor colorWithRed:206.0 / 255.0 green:149.0 / 255.0 blue:98.0 / 255.0 alpha:1.0];

    // Setting the default inactive state color to the tableView background color
    [cell setDefaultColor:self.tableView.backgroundView.backgroundColor];
    [cell setDelegate:(id)self];
    
    if (jobsItem.checked == 0) {
        [cell setSwipeGestureWithView:crossView
                                color:redColor
                                 mode:MCSwipeTableViewCellModeNone
                                state:MCSwipeTableViewCellState1
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
                          controller.companyName = self.jobList.name;
                          controller.itemToEdit = jobsItem;
                          [self presentViewController:navigationController animated:YES completion:nil];
                      }];
    }else if(jobsItem.checked == 1){
        [cell setSwipeGestureWithView:crossView
                                color:redColor
                                 mode:MCSwipeTableViewCellModeExit
                                state:MCSwipeTableViewCellState1
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
                          controller.companyName = self.jobList.name;
                          controller.itemToEdit = jobsItem;
                          [self presentViewController:navigationController animated:YES completion:nil];
                      }];
    }
    cell.firstTrigger = 0.25;
    cell.secondTrigger = 0.5;
}

- (void)configureStateOfCell:(MCSwipeTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
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
    
    [self cancelLocalNotificationIndex:indexPath.row];
    [self.jobList.items removeObjectAtIndex:indexPath.row];
    [self.checkboxs removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
    
    NSInteger sum = [self.tableView numberOfRowsInSection:0];
    for (NSInteger i = 0; i < sum; ++i) {
        
        BFPaperCheckbox *checkbox = [[BFPaperCheckbox alloc]init];
        checkbox = self.checkboxs[i];
        checkbox.tag = i;
    }
    
    //NSArray *allNotifications = [[UIApplication sharedApplication]scheduledLocalNotifications];
    //NSLog(@"%d",[allNotifications count]);
}

- (void)cancelLocalNotificationIndex:(NSInteger)index{
    JobsItem *temp = [self.jobList.items objectAtIndex:index];
    UILocalNotification *existingNotification = [temp notificationForThisItem];
    if (existingNotification != nil) {
        [[UIApplication sharedApplication]cancelLocalNotification:existingNotification];
    }
}

- (void)changeStateofCell:(MCSwipeTableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    JobsItem *jobsItem = self.jobList.items[indexPath.row];
    BFPaperCheckbox *checkbox = self.checkboxs[indexPath.row];
    NSInteger disDeletedNum=0;
    for(JobsItem *jobsItemTemp in self.jobList.items){
        if (jobsItemTemp.checked == 0) {
            disDeletedNum ++;
        }else{
            break;
        }
    }
    if (disDeletedNum == 0) {
        disDeletedNum =1;
    }
        if (jobsItem.checked == 0) {
        jobsItem.checked =1;
        [self configureStateOfCell:cell forRowAtIndexPath:indexPath];
        [self.jobList.items removeObjectAtIndex:indexPath.row];
        [self.jobList.items insertObject:jobsItem atIndex:disDeletedNum-1];
        [self.checkboxs removeObjectAtIndex:indexPath.row];
        [self.checkboxs insertObject:checkbox atIndex:disDeletedNum -1];
        NSIndexPath *bottomIndexPath = [NSIndexPath indexPathForRow:disDeletedNum-1 inSection:0];
        [self.tableView moveRowAtIndexPath:indexPath toIndexPath:bottomIndexPath];
    }else if(jobsItem.checked == 1){
        jobsItem.checked = 0;
        [self configureStateOfCell:cell forRowAtIndexPath:indexPath];
        [self configureCell:cell forRowAtIndexPath:indexPath];
        [self.jobList.items removeObjectAtIndex:indexPath.row];
        [self.jobList.items insertObject:jobsItem atIndex:0];
        [self.checkboxs removeObjectAtIndex:indexPath.row];
        [self.checkboxs insertObject:checkbox atIndex:0];
        NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView moveRowAtIndexPath:indexPath toIndexPath:firstIndexPath];
    }
    
    NSInteger sum = [self.tableView numberOfRowsInSection:0];
    for (NSInteger i = 0; i < sum; ++i) {
        BFPaperCheckbox *checkbox = [[BFPaperCheckbox alloc]init];
        checkbox = self.checkboxs[i];
        checkbox.tag = i;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        MCSwipeTableViewCell *cell = (MCSwipeTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [self configureCell:cell forRowAtIndexPath:indexPath];
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self createView:indexPath];
}

- (void)createView:(NSIndexPath *)indexPath{
    UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualEffectView.frame = self.view.bounds;
    visualEffectView.alpha = 0;
    [self.tableView addSubview:visualEffectView];
    
    CGFloat frameX = self.tableView.bounds.size.width *1/10;
    CGFloat frameY = (self.view.bounds.size.height-self.navigationController.navigationBar.frame.size.height-[[UIApplication sharedApplication]statusBarFrame].size.height) *1/10;
    CGFloat sizeWidth = self.tableView.bounds.size.width *4/5;
    CGFloat sizeHeight = (self.view.bounds.size.height-self.navigationController.navigationBar.frame.size.height-[[UIApplication sharedApplication]statusBarFrame].size.height) *4/5;
    stageDetailView= [[UIView alloc]initWithFrame:CGRectMake(frameX, 0, sizeWidth, sizeHeight)];
    stageDetailView.alpha = 0;
    stageDetailView.layer.cornerRadius = 10;
    //rgb(189, 195, 199)  深灰
    //rgb(236, 240, 241) 浅灰
    //rgb(230, 126, 34) 橘黄
    stageDetailView.backgroundColor = [UIColor colorWithRed:189.0/255.0 green:195.0/255.0 blue:199.0/255.0 alpha:1];
    [self.tableView addSubview:stageDetailView];
    
    [UIView animateWithDuration:0.25 animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.25];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        visualEffectView.alpha = 1;
        stageDetailView.alpha = 1;
        stageDetailView.frame = CGRectMake(frameX, frameY, sizeWidth, sizeHeight);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handTapFrom:)];
    //tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    differFromNowToTarget = 10;//60秒倒计时
    countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];

}

-(void)timeFireMethod{
    NSLog(@".");
    differFromNowToTarget--;
    if (differFromNowToTarget < 0) {
        [countDownTimer invalidate];
    }
}

- (void)handTapFrom:(UIGestureRecognizer *)gesture{
    [UIView animateWithDuration:0.25
                     animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.25];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        visualEffectView.alpha = 0;
        stageDetailView.alpha = 0;
        stageDetailView.frame = CGRectMake(self.tableView.bounds.size.width *1/10, self.view.frame.size.height*3/4, self.tableView.bounds.size.width *4/5, (self.view.bounds.size.height-self.navigationController.navigationBar.frame.size.height-[[UIApplication sharedApplication]statusBarFrame].size.height) *4/5);
                     }completion:^(BOOL finished) {
           [stageDetailView removeFromSuperview];
          [visualEffectView removeFromSuperview];}];
    
    [self.view removeGestureRecognizer:gesture];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return cellHeight;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.jobList.items removeObjectAtIndex:indexPath.row];
    NSArray *indexPaths = @[indexPath];
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - BFPaperCheckboxDelegate
- (void)paperCheckboxChangedState:(BFPaperCheckbox *)checkbox
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:checkbox.tag inSection:0];
    MCSwipeTableViewCell *cell = (MCSwipeTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    [self changeStateofCell:cell];
}

#pragma mark - ItemDetailViewControllerDelegate

- (void)itemDetailViewControllerdidCancel:(ItemDetailViewController *)controller{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)itemDetailViewController:(ItemDetailViewController *)controller didFinishAddingItem:(JobsItem *)item{

    [self.jobList.items insertObject:item atIndex:0];
    
    BFPaperCheckbox *checkbox = [[BFPaperCheckbox alloc] initWithFrame:CGRectMake(self.tableView.bounds.size.width/8*7, cellHeight/2, cellHeight, cellHeight)];
    checkbox.frame =CGRectMake(self.tableView.bounds.size.width/8*7, cellHeight/2, cellHeight, cellHeight);
    checkbox.center = CGPointMake(self.tableView.bounds.size.width/8*7, cellHeight/2);
    [self.checkboxs insertObject:checkbox atIndex:0];
    
    NSInteger sum = [self.tableView numberOfRowsInSection:0];
    for (NSInteger i = 0; i < sum; ++i) {
        
        BFPaperCheckbox *checkbox = [[BFPaperCheckbox alloc]init];
        checkbox = self.checkboxs[i];
        checkbox.tag = i;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    NSArray *indexPaths = @[indexPath];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)itemDetailViewController:(ItemDetailViewController *)controller didFinishEditingItem:(JobsItem *)item{
    NSInteger index = [self.jobList.items indexOfObject:item];
    NSIndexPath *indexPath =  [NSIndexPath indexPathForRow:index inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self configureTextForCell:(MCSwipeTableViewCell *)cell withJobsItem:item];
    // [self saveJobsItems];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
