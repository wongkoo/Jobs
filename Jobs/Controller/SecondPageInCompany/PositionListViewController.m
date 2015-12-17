//
//  ViewController.m
//  Jobs
//
//  Created by 王振辉 on 15/6/3.
//  Copyright (c) 2015年 王振辉. All rights reserved.
//

#import "PositionListViewController.h"
#import "PositionDetailViewController.h"
#import "CompanyListViewController.h"
#import "JobsItem.h"
#import "Company.h"
#import "CellbackgroundVIew.h"
#import "ProcessView.h"
#import <MCSwipeTableViewCell.h>
#import <BFPaperCheckbox.h>
#import "UIColor+BFPaperColors.h"
#import <Masonry.h>

@interface PositionListViewController(){
    NSInteger cellHeight;
}

@property (nonatomic, weak) IBOutlet UILabel *detailTextView;
@property (nonatomic, strong) NSMutableArray *checkboxs;
@end

@implementation PositionListViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
//    NSLog(@"ViewController: viewWillAppear");
}

- (void)viewDidLoad {
//    NSLog(@"ViewController: viewDidLoad");
    [self popIfPerformActionForShortcutItem];
    [super viewDidLoad];
    cellHeight = 100;
    self.title = self.company.name;
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [backgroundView setBackgroundColor:[UIColor colorWithRed:227.0 / 255.0 green:227.0 / 255.0 blue:227.0 / 255.0 alpha:1.0]];
    [self.tableView setBackgroundView:backgroundView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self initCheckboxs];
    [self initDetailTextView];
    
    //用于检测是否是公司Cell被重按之后 上移点击添加职位按钮。
    if (self.company.addPositionBy3DTouch == YES) {
        [self performSegueWithIdentifier:@"AddItem" sender:nil];
        self.company.addPositionBy3DTouch = NO;
    }
}

- (void)popIfPerformActionForShortcutItem {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL bl = [userDefaults boolForKey:@"PerformActionForShortcutItem"];
    if (bl) {
        [userDefaults setBool:NO forKey:@"PerformActionForShortcutItem"];
        [self performSegueWithIdentifier:@"backToAllListsViewController" sender:self];
    }
}

- (void)initCheckboxs{
    self.checkboxs = [[NSMutableArray alloc]initWithCapacity:20];
    for (NSInteger i =0; i<[self.company.positions count]; ++i) {
        JobsItem *item =self.company.positions[i];
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
    if (![self.company.accountOfWebsite isEqualToString:@""]) {
        self.detailTextView.text = [self.detailTextView.text stringByAppendingFormat:@"官网账号：%@\n",self.company.accountOfWebsite];
    }
    if (![self.company.reminderOfPassword isEqualToString:@""]) {
        self.detailTextView.text = [self.detailTextView.text stringByAppendingFormat:@"密码提示：%@\n",self.company.reminderOfPassword];
    }
    if (![self.company.email isEqualToString:@""]) {
        self.detailTextView.text = [self.detailTextView.text stringByAppendingFormat:@"报名邮箱：%@",self.company.email];
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
        PositionDetailViewController *controller = (PositionDetailViewController *)navigationController.topViewController;
        controller.delegate = self;
        controller.companyName = self.company.name;
    }else if([segue.identifier isEqualToString:@"EditItem"]){
        UINavigationController *navigationController = segue.destinationViewController;
        PositionDetailViewController *controller = (PositionDetailViewController *)navigationController.topViewController;
        controller.delegate = self;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        controller.itemToEdit = self.company.positions[indexPath.row];
        controller.companyName = self.company.name;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.company.positions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JobsItem *item = self.company.positions[indexPath.row];
    static NSString *CellIdentifier = @"Cell";
    MCSwipeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[MCSwipeTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        // iOS 7 separator
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            cell.separatorInset = UIEdgeInsetsZero;
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        
        CellbackgroundVIew *backView = [[CellbackgroundVIew alloc] initWithColor:CellColorWhite];
        backView.tag = 22;
        [cell.contentView addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.mas_left);
            make.right.equalTo(cell.mas_right);
            make.top.equalTo(cell.mas_top);
            make.bottom.equalTo(cell.mas_bottom);
        }];
        
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
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"M月dd日hh时mm分"];
    NSString *time = [dateFormatter stringFromDate:item.dueDate];
    if(item.shouldRemind == YES){
        cell.detailTextLabel.text = [NSString stringWithFormat:@"⏰%@",time];
    }else{
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",time];
    }
}

- (void)configureCell:(MCSwipeTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    JobsItem *jobsItem = self.company.positions[indexPath.row];
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
                          PositionDetailViewController *controller = (PositionDetailViewController *)navigationController.topViewController;
                          controller.delegate = self;
                          controller.companyName = self.company.name;
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
                          PositionDetailViewController *controller = (PositionDetailViewController *)navigationController.topViewController;
                          controller.delegate = self;
                          controller.companyName = self.company.name;
                          controller.itemToEdit = jobsItem;
                          [self presentViewController:navigationController animated:YES completion:nil];
                      }];
    }
    cell.firstTrigger = 0.25;
    cell.secondTrigger = 0.5;
}

- (void)configureStateOfCell:(MCSwipeTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    JobsItem *jobsItem = self.company.positions[indexPath.row];
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
    [self.company.positions removeObjectAtIndex:indexPath.row];
    [self.checkboxs removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
    
    NSInteger sum = [self.tableView numberOfRowsInSection:0];
    for (NSInteger i = 0; i < sum; ++i) {
        
        BFPaperCheckbox *checkbox = [[BFPaperCheckbox alloc]init];
        checkbox = self.checkboxs[i];
        checkbox.tag = i;
    }
}

- (void)cancelLocalNotificationIndex:(NSInteger)index{
    JobsItem *temp = [self.company.positions objectAtIndex:index];
    UILocalNotification *existingNotification = [temp notificationForThisItem];
    if (existingNotification != nil) {
        [[UIApplication sharedApplication]cancelLocalNotification:existingNotification];
    }
}

- (void)changeStateofCell:(MCSwipeTableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    JobsItem *jobsItem = self.company.positions[indexPath.row];
    BFPaperCheckbox *checkbox = self.checkboxs[indexPath.row];
    NSInteger disDeletedNum=0;
    for(JobsItem *jobsItemTemp in self.company.positions){
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
        [self.company.positions removeObjectAtIndex:indexPath.row];
        [self.company.positions insertObject:jobsItem atIndex:disDeletedNum-1];
        [self.checkboxs removeObjectAtIndex:indexPath.row];
        [self.checkboxs insertObject:checkbox atIndex:disDeletedNum -1];
        NSIndexPath *bottomIndexPath = [NSIndexPath indexPathForRow:disDeletedNum-1 inSection:0];
        [self.tableView moveRowAtIndexPath:indexPath toIndexPath:bottomIndexPath];
    }else if(jobsItem.checked == 1){
        jobsItem.checked = 0;
        [self configureStateOfCell:cell forRowAtIndexPath:indexPath];
        [self configureCell:cell forRowAtIndexPath:indexPath];
        [self.company.positions removeObjectAtIndex:indexPath.row];
        [self.company.positions insertObject:jobsItem atIndex:0];
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

#pragma mark - Preview Actions

- (NSArray<id<UIPreviewActionItem>> *)previewActionItems {
    
    // setup a list of preview actions
    UIPreviewAction *action1 = [UIPreviewAction actionWithTitle:@"添加职位" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        
        PositionListViewController *viewController = (PositionListViewController *)previewViewController;
        [viewController.delegate addPositionInCompany:viewController.company];

    }];
    
    UIPreviewAction *action2 = [UIPreviewAction actionWithTitle:@"删除本公司" style:UIPreviewActionStyleDestructive handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        
        PositionListViewController *viewController = (PositionListViewController *)previewViewController;
        [viewController.delegate deleteCompany:viewController.company];
    }];
    
    NSArray *actions = @[action1, action2];
    return actions;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self createView:indexPath];
    self.tableView.scrollEnabled = NO;
}

- (void)createView:(NSIndexPath *)indexPath{
    JobsItem *item = self.company.positions[indexPath.row];
    
    CountdownView *countdownView = [[CountdownView alloc]init];
    countdownView.companyNameString = self.company.name;
    countdownView.dueDate = item.dueDate;
    countdownView.nextTaskString = item.nextTask;
    countdownView.jobNameString = item.text;
    countdownView.delegate = self;
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.tableView addSubview:countdownView];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 80;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    ProcessView *footerView = [[ProcessView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 80)];
    footerView.process = self.company.process;
    return footerView;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.company.positions removeObjectAtIndex:indexPath.row];
    NSArray *indexPaths = @[indexPath];
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - CountdownDelegate
- (void)countdownViewRemoved {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - BFPaperCheckboxDelegate
- (void)paperCheckboxChangedState:(BFPaperCheckbox *)checkbox
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:checkbox.tag inSection:0];
    MCSwipeTableViewCell *cell = (MCSwipeTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    [self changeStateofCell:cell];
}

#pragma mark - ItemDetailViewControllerDelegate

- (void)itemDetailViewControllerdidCancel:(PositionDetailViewController *)controller{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)itemDetailViewController:(PositionDetailViewController *)controller didFinishAddingItem:(JobsItem *)item{

    [self.company.positions insertObject:item atIndex:0];
    
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

- (void)itemDetailViewController:(PositionDetailViewController *)controller didFinishEditingItem:(JobsItem *)item{
    NSInteger index = [self.company.positions indexOfObject:item];
    NSIndexPath *indexPath =  [NSIndexPath indexPathForRow:index inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    [self configureTextForCell:(MCSwipeTableViewCell *)cell withJobsItem:item];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
