//
//  AllListsViewController.m
//  Jobs
//
//  Created by 王振辉 on 15/6/4.
//  Copyright (c) 2015年 王振辉. All rights reserved.
//

#import "AllListsViewController.h"
#import "ListDetailViewController.h"
#import "ViewController.h"
#import "ShareViewController.h"

#import "JobList.h"
#import "jobsItem.h"
#import "DataModel.h"

#import "PullDownProcessView.h"
#import "PureColorBackgroundView.h"
#import "DiffuseButton.h"
#import "UIColor+WHColor.h"
#import "Masonry.h"
#import "AllListsCompanyCell.h"

#define CELL_HEIGHT 80

@interface AllListsViewController ()<ListDetailViewControllerDelegate,UINavigationControllerDelegate,UIViewControllerPreviewingDelegate,ViewController3DTouchDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) PureColorBackgroundView *statusBarBackgroundView;
@property (nonatomic, strong) DiffuseButton *shareButton;
@property (nonatomic, strong) PullDownProcessView *pullDownProcessView;
@property (nonatomic, strong) UILabel *allApplicationNumLabel;
@property (nonatomic, assign) BOOL forceTouchAvailable;
@property (nonatomic, strong) NSIndexPath *indexPathOfForceTouch;
@property (nonatomic, assign) CGPoint panPoint;
@property (nonatomic, assign) BOOL pulled;
@end

@implementation AllListsViewController


#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self initViews];
    [self checkForceTouch];
}

- (void)initViews {
    [self initTableView];
    [self initPullDownProcessView];
    [self initStatusBar];
    [self initShareButton];
}

- (void)initTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollsToTop = YES;
    self.tableView.showsVerticalScrollIndicator =NO;
    [self.view addSubview:self.tableView];
    
    self.allApplicationNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    self.allApplicationNumLabel.font = [UIFont systemFontOfSize:15];
    self.allApplicationNumLabel.textAlignment = NSTextAlignmentCenter;
    self.allApplicationNumLabel.textColor = [UIColor whMidnightBlue];
    self.allApplicationNumLabel.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = self.allApplicationNumLabel;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView.panGestureRecognizer addTarget:self action:@selector(paned:)];
    
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor whClouds];
    self.tableView.backgroundView = backgroundView;
    
    UIImageView *logoView = [[UIImageView alloc] init];
    UIImage *image = [UIImage imageNamed:@"icon"];
    logoView.image = image;
    [backgroundView addSubview:logoView];
    [logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backgroundView.mas_centerX);
        make.bottom.equalTo(backgroundView.mas_bottom).offset(-70);
        make.height.equalTo(@60);
        make.width.equalTo(@60);
    }];
    
    for (UIView *subview in self.tableView.subviews)
    {
        if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewWrapperView"])
        {
            subview.backgroundColor = [UIColor whClouds];
        }
    }
}

- (void)initPullDownProcessView {
    self.pullDownProcessView = [[PullDownProcessView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 0)];
    [self.view addSubview:self.pullDownProcessView];
}

- (void)initStatusBar {
    if (!self.statusBarBackgroundView) {
        self.statusBarBackgroundView = [[PureColorBackgroundView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
        [self.view addSubview:self.statusBarBackgroundView];
    }
}

- (void)initShareButton {
    self.shareButton = [[DiffuseButton alloc] initWithTitle:@"S" radius:20 color:[UIColor whBelizeHole]];
    [self.view addSubview:_shareButton];
    [_shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.bottom.equalTo(self.view).offset(-20);
        make.height.width.equalTo(@40);
    }];
    [_shareButton drawButton];
    [_shareButton addTarget:self action:@selector(shareScreenShot) forControlEvents:UIControlEventTouchUpInside];
}

- (void)configureShareButton {
    if (self.shareButton.superview == nil) {
        self.shareButton = nil;
        [self initShareButton];
    }
}

- (void)configureStatusBar {
    if (self.dataModel.jobs.count > 0) {
        JobList *joblist = self.dataModel.jobs[0];
        [self changeStatusBarWithCellColor:joblist.cellColor];
    }else{
        [self changeStatusBarWithCellColor:CellColorWhite];
    }
    
}

- (void)changeStatusBarWithCellColor:(CellColor)cellColor {
    self.statusBarBackgroundView.pureColor = (PureColor)cellColor;
    if (cellColor == CellColorWhite || cellColor == CellColorSilver || cellColor == CellColorSky) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }else{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self updateAllApplicationNum];
    [self.tableView reloadData];
    [self configureStatusBar];
    [self configureShareButton];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)checkForceTouch {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0) {
        _forceTouchAvailable = NO;
        return;
    }
    
    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        _forceTouchAvailable = YES;
    }else{
        _forceTouchAvailable = NO;
    }
}

- (void)updateAllApplicationNum{
    NSString *string;
    if (self.dataModel.jobs.count == 0) {
        string = @"下拉添加公司";
    }else{
        string = [NSString stringWithFormat:@"%ld个职位正在进行中",(long)[self.dataModel numberOfUncheckedJobsItem]];
    }
    self.allApplicationNumLabel.text=string;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)shareScreenShot {
    
//    UIGraphicsBeginImageContextWithOptions(self.tableView.contentSize, NO, 0.0);  //NO，YES 控制是否透明
//    [self.tableView.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
    UIImage* image = nil;
    UIGraphicsBeginImageContextWithOptions(self.tableView.contentSize, NO, 0.0);
    {
        CGPoint savedContentOffset = self.tableView.contentOffset;
        CGRect savedFrame = self.tableView.frame;
        
        self.tableView.contentOffset = CGPointZero;
        self.tableView.frame = CGRectMake(0, 0, self.tableView.contentSize.width, self.tableView.contentSize.height);
        
        [self.tableView.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        self.tableView.contentOffset = savedContentOffset;
        self.tableView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    
    ShareViewController *shareViewController = [[ShareViewController alloc] init];
    shareViewController.sharedImage = image;
    shareViewController.finishBlock = ^(void){
        [self initShareButton];
    };
    [self.view addSubview:shareViewController.view];
    [self addChildViewController:shareViewController];
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ShowJobList"]) {
        ViewController *controller = segue.destinationViewController;
        controller.jobList = sender;
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }else if([segue.identifier isEqualToString:@"AddJobList"]){
        UINavigationController *navigationController = segue.destinationViewController;
        ListDetailViewController *controller = (ListDetailViewController *)navigationController.topViewController;
        controller.delegate = self;
        controller.jobListToEdit = nil;
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (IBAction)backToAllListsViewController:(UIStoryboardSegue *)segue {
    
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AllListsCompanyCell *cell = [tableView dequeueReusableCellWithIdentifier:[AllListsCompanyCell reuseIdentifier]];
    
    if (!cell) {
        cell = [[AllListsCompanyCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:[AllListsCompanyCell reuseIdentifier]];
        
        __weak id weakSelf = self;
        cell.listCompletetionBlock = ^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode){
            AllListsViewController *mySelf = weakSelf;
            UINavigationController *navigationController = [mySelf.storyboard instantiateViewControllerWithIdentifier:@"ListNavigationController"];
            ListDetailViewController *controller = (ListDetailViewController *)navigationController.topViewController;
            controller.delegate = weakSelf;
            AllListsCompanyCell *myCell = (AllListsCompanyCell *)cell;
            controller.jobListToEdit = myCell.jobList;
            [weakSelf presentViewController:navigationController animated:YES completion:nil];
        };
        
        cell.stickCompletetionBlock = ^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode){

            AllListsCompanyCell *myCell = (AllListsCompanyCell *)cell;
            AllListsViewController *mySelf = weakSelf;
            [mySelf.dataModel.jobs insertObject:myCell.jobList atIndex:0];
            [mySelf.dataModel.jobs removeObjectAtIndex:(indexPath.row + 1)];
            [mySelf.tableView moveRowAtIndexPath:[self.tableView indexPathForCell:cell] toIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            [weakSelf configureStatusBar];
            NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [mySelf.tableView scrollToRowAtIndexPath:topIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        };
        
        cell.crossCompletetionBlock = ^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode){
            [weakSelf deleteCell:(AllListsCompanyCell *)cell];
        };
        
        cell.checkCompletetionBlock = ^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode){
            [weakSelf changeStateofCell:(AllListsCompanyCell *)cell];
        };
    }
    
    cell.jobList = self.dataModel.jobs[indexPath.row];
    
    if (_forceTouchAvailable) {
        [self registerForPreviewingWithDelegate:self sourceView:cell];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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

#pragma mark - CellCallBack

- (void)deleteCell:(AllListsCompanyCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.dataModel cancelLocalNotificationIndexOfJobs:indexPath.row];
    [self.dataModel.jobs removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
}

- (void)changeStateofCell:(AllListsCompanyCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSInteger disDeletedNum = [self.dataModel numberOfDisDeletedJobsList];
    
    cell.jobList.deletedFlag = !cell.jobList.deletedFlag;
    [cell reloadData];
    [self updateAllApplicationNum];
    
    [self.dataModel.jobs removeObjectAtIndex:indexPath.row];
    
    NSInteger insertIndex;
    NSIndexPath *desIndexPath;
    
    if (cell.jobList.deletedFlag == 1) {
        insertIndex = disDeletedNum - 1;
        desIndexPath = [NSIndexPath indexPathForRow:disDeletedNum-1 inSection:0];
    }else if(cell.jobList.deletedFlag == 0){
        insertIndex = 0;
        desIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    
    [self.dataModel.jobs insertObject:cell.jobList atIndex:insertIndex];
    [self.tableView moveRowAtIndexPath:indexPath toIndexPath:desIndexPath];
    [self configureStatusBar];
    [self.tableView scrollToRowAtIndexPath:desIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.dataModel setIndexOfSelectedJobList:indexPath.row];
    JobList *jobList = self.dataModel.jobs[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"ShowJobList" sender:jobList];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat y = scrollView.contentOffset.y;
    CGPoint point = self.panPoint;
    point.y = -y;
    self.panPoint = point;
    
    if (self.pulled) {
        [self refreshPullDownView];
    }
    
    if (y <= 0) {
        self.pulled = YES;
        
        if (scrollView.contentOffset.y < -110) {
            [self performSegueWithIdentifier:@"AddJobList" sender:nil];
        }
    }else{
        self.pulled = NO;;
        int row = (int)(scrollView.contentOffset.y/80);
        if (row < self.dataModel.jobs.count) {
            JobList *jobList = self.dataModel.jobs[row];
            [self changeStatusBarWithCellColor:jobList.cellColor];
        }
    }
}

- (void)refreshPullDownView {
    self.pullDownProcessView.pullColor = self.statusBarBackgroundView.backgroundColor;
    self.pullDownProcessView.point = self.panPoint;
}

- (void)paned:(UIPanGestureRecognizer *)gesture {
    if (self.pulled) {
        CGPoint point = self.panPoint;
        point.x = [gesture locationInView:self.tableView].x;
        self.panPoint = point;
        [self refreshPullDownView];
    }
}

#pragma mark - UINavigationControllerDelegate
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (viewController == self) {
        [self.dataModel setIndexOfSelectedJobList:-1];
    }
}

#pragma mark - UIViewControllerPreviewingDelegate
- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    
    _indexPathOfForceTouch = [self.tableView indexPathForCell:(MCSwipeTableViewCell *)previewingContext.sourceView];
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
    [self.dataModel.jobs insertObject:jobList atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    NSArray *indexPaths = @[indexPath];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)listDetailViewController:(ListDetailViewController *)controller didFinishEditingJobList:(JobList *)jobList{
    NSInteger index = [self.dataModel.jobs indexOfObject:jobList];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
