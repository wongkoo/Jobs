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
#import "PositionListCell.h"
#import "CountdownView.h"
#import "UIColor+WHColor.h"
#import <Masonry.h>


@interface PositionListViewController() <ItemDetailViewControllerDelegate,CountdownViewDelegate>
@property (nonatomic, weak) IBOutlet UILabel *detailTextView;
@end

@implementation PositionListViewController



#pragma mark - ViewLifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self check3DTouch];
    [self initViews];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



#pragma mark - 3D Touch

- (void)check3DTouch {
    //from 3D Touch ShortCutItem
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL bl = [userDefaults boolForKey:@"PerformActionForShortcutItem"];
    if (bl) {
        [userDefaults setBool:NO forKey:@"PerformActionForShortcutItem"];
        [self performSegueWithIdentifier:@"backToAllListsViewController" sender:self];
    }
    
    //from 3D Touch upglide Add Position
    if (self.company.addPositionBy3DTouch == YES) {
        [self performSegueWithIdentifier:@"AddItem" sender:nil];
        self.company.addPositionBy3DTouch = NO;
    }
}



#pragma mark - Init

- (void)initViews {
    self.title = self.company.name;
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.view.frame];
    [backgroundView setBackgroundColor:[UIColor whClouds]];
    [self.tableView setBackgroundView:backgroundView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self initDetailTextView];
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
    JobsItem *position = self.company.positions[indexPath.row];
    PositionListCell *cell = [tableView dequeueReusableCellWithIdentifier:[PositionListCell reuseIdentifier]];
    if (!cell) {
        cell = [[PositionListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:[PositionListCell reuseIdentifier]];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        
        __weak typeof(self) weakSelf = self;
        cell.deleteCompletionBlock = ^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode){
            [weakSelf deleteCell:(PositionListCell *)cell];
        };
        
        cell.editCompletionBlock = ^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
            [weakSelf editCell:(PositionListCell *)cell];
        };
    }
    cell.position = position;
    return cell;
}


- (void)deleteCell:(PositionListCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self cancelLocalNotificationIndex:indexPath.row];
    [self.company.positions removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
}

- (void)editCell:(PositionListCell *)cell {
    UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"ItemNavigationController"];
    PositionDetailViewController *controller = (PositionDetailViewController *)navigationController.topViewController;
    controller.delegate = self;
    controller.companyName = self.company.name;
    controller.itemToEdit = cell.position;
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)cancelLocalNotificationIndex:(NSInteger)index{
    JobsItem *temp = [self.company.positions objectAtIndex:index];
    UILocalNotification *existingNotification = [temp notificationForThisItem];
    if (existingNotification != nil) {
        [[UIApplication sharedApplication]cancelLocalNotification:existingNotification];
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
    return [PositionListCell cellHeight];
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



#pragma mark - ItemDetailViewControllerDelegate

- (void)itemDetailViewControllerdidCancel:(PositionDetailViewController *)controller{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)itemDetailViewController:(PositionDetailViewController *)controller didFinishAddingItem:(JobsItem *)item{
    [self.company.positions insertObject:item atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    NSArray *indexPaths = @[indexPath];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)itemDetailViewController:(PositionDetailViewController *)controller didFinishEditingItem:(JobsItem *)item{
    NSInteger index = [self.company.positions indexOfObject:item];
    NSIndexPath *indexPath =  [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
