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

#import "JobList.h"
#import "jobsItem.h"
#import "DataModel.h"

#import "PullDownProcessView.h"
#import "PureColorBackgroundView.h"
#import "CellbackgroundVIew.h"
#import <MCSwipeTableViewCell.h>
#import "UIColor+WHColor.h"
#import "Masonry.h"

#define CELL_HEIGHT 80

@interface AllListsViewController ()<ListDetailViewControllerDelegate,UINavigationControllerDelegate,UIViewControllerPreviewingDelegate,ViewController3DTouchDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) PureColorBackgroundView *statusBarBackgroundView;
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
    
    [self initTableView];
    [self initPullDownProcessView];
    [self checkForceTouch];
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

- (void)configureStatusBar {
    if (!self.statusBarBackgroundView) {
        self.statusBarBackgroundView = [[PureColorBackgroundView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
        [self.view addSubview:self.statusBarBackgroundView];
    }
    
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
        NSLog(@"3D Touch is not available on this device. Sorry!");
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
    
    static NSString *CellIdentifier = @"CompanyCell";
    MCSwipeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (!cell) {
        cell = [self swipeTableViewCellWithIdentifier:CellIdentifier];
    }
    
    [self configureElementsForCell:cell withIndexPath:indexPath];
    
    return cell;
}

- (MCSwipeTableViewCell *)swipeTableViewCellWithIdentifier:(NSString *)identifier {
    MCSwipeTableViewCell *cell = [[MCSwipeTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    
    // iOS 7 separator
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        cell.separatorInset = UIEdgeInsetsZero;
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    CellbackgroundVIew *backView = [[CellbackgroundVIew alloc] initWithColor:CellColorDarkGray];
    backView.tag = 23;
    [cell.contentView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.mas_left);
        make.right.equalTo(cell.mas_right);
        make.top.equalTo(cell.mas_top);
        make.bottom.equalTo(cell.mas_bottom);
    }];
    
    UILabel *label =[[UILabel alloc]init];
    label.font = [UIFont boldSystemFontOfSize:18];
    label.tag = 123;
    [cell.contentView addSubview:label];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cell.mas_right).offset(-15);
        make.centerY.equalTo(cell.mas_centerY);
        make.height.equalTo(@40);
    }];
    
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

#pragma mark - ConfigCellElements
- (void)configureElementsForCell:(MCSwipeTableViewCell *)cell withIndexPath:(NSIndexPath *)indexPath {
    JobList *jobList = self.dataModel.jobs[indexPath.row];
    [self configureColorForCell:cell withJobList:jobList];
    [self configureTextForCell:cell withJobList:jobList];
    [self configureStateOfCell:cell withJobList:jobList];
    [self configureSwapeCell:cell withJobList:jobList];
}

- (void)configureColorForCell:(MCSwipeTableViewCell *)cell withJobList:(JobList *)jobList {
    CellbackgroundVIew *view = (CellbackgroundVIew *)[cell.contentView viewWithTag:23];
    [view setColor:jobList.cellColor];
}

- (void)configureTextForCell:(MCSwipeTableViewCell *)cell withJobList:(JobList *)jobList{

    NSString *detailString = [[NSString alloc] init];
    NSString *dateString = [[NSString alloc] init];
    BOOL showsHours = NO;
    if ([jobList.items count] != 0) {
        JobsItem *jobsItem = jobList.items[0];
    
        NSDate *nowDate = [NSDate date];
        NSDateFormatter *referenceFormatter = [[NSDateFormatter alloc] init];
        [referenceFormatter setDateFormat:@"yyyy/MMdd"];
        NSString *referenceString = [referenceFormatter stringFromDate:nowDate];
        NSDate *referenceDate = [referenceFormatter dateFromString:referenceString]; //00：00 of today
        
        NSDate *dueDate = jobsItem.dueDate;
        NSTimeInterval timeInterval = [dueDate timeIntervalSinceDate:referenceDate];
        NSTimeInterval day = timeInterval/3600/24;
        
        NSString *dateFrontString = [[NSString alloc] init];
        if (day < 0) {
            dateFrontString = @"已经 ";
        }else{
            if (day<1) {
                if ([dueDate timeIntervalSinceNow] < 0) {
                    dateFrontString = @"已经 ";
                }else{
                    dateFrontString = [NSString stringWithFormat:@"%.1f小时后 ",[dueDate timeIntervalSinceNow]/3600];
                    showsHours = YES;
                }
            } else if (day < 2) {
                dateFrontString = @"明天 ";
            } else if (day < 3) {
                dateFrontString = @"后天 ";
            } else if (day < 10) {
                dateFrontString = [NSString stringWithFormat:@"%d天后 ",(int)day];
            } else {
                NSDateFormatter *dateFormatterToShow = [[NSDateFormatter alloc] init];
                [dateFormatterToShow setDateFormat:@"M月d日 "];
                dateFrontString = [dateFormatterToShow stringFromDate:jobsItem.dueDate];
            }
        }
        
        dateString = [dateFrontString stringByAppendingString:jobsItem.nextTask];
        detailString = jobsItem.text;
        
    }else{
        dateString=@"";
        detailString = @"暂未申请职位";
    }
    
    CellColor cellColor = jobList.cellColor;
    UIColor *stringColor;
    if (cellColor == CellColorWhite || cellColor == CellColorSilver || cellColor == CellColorSky) {
        stringColor = [UIColor blackColor];
    }else {
        stringColor = [UIColor whiteColor];
    }
    
    //标题
    NSMutableAttributedString *titleAttributedString = [[NSMutableAttributedString alloc] initWithString:jobList.name];
    [titleAttributedString addAttribute:NSForegroundColorAttributeName value:stringColor range:NSMakeRange(0, jobList.name.length)];
    [titleAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, jobList.name.length)];
    cell.textLabel.attributedText = titleAttributedString;
    
    //副标题
    NSMutableAttributedString *detailAttrString = [[NSMutableAttributedString alloc] initWithString:detailString];
    [detailAttrString addAttribute:NSForegroundColorAttributeName value:stringColor range:NSMakeRange(0, detailString.length)];
    cell.detailTextLabel.attributedText = detailAttrString;
    
    //日期
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:123];
    NSMutableAttributedString *labelAttrString = [[NSMutableAttributedString alloc] initWithString:dateString];
    [labelAttrString addAttribute:NSForegroundColorAttributeName value:stringColor range:NSMakeRange(0, dateString.length)];
    if ( ![dateString isEqualToString:@""] && dateString.length >= 2) {
        [labelAttrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(dateString.length - 2, 2)];
    }
    if (showsHours) {
        [labelAttrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(3, 3)];
    }
    label.attributedText = labelAttrString;
}

- (void)configureSwapeCell:(MCSwipeTableViewCell *)cell withJobList:(JobList *)jobList {
    UIView *checkView = [self viewWithImageName:@"check"];
    UIColor *greenColor = [UIColor colorWithRed:85.0 / 255.0 green:213.0 / 255.0 blue:80.0 / 255.0 alpha:1.0];
    
    UIView *crossView = [self viewWithImageName:@"cross"];
    UIColor *redColor = [UIColor colorWithRed:232.0 / 255.0 green:61.0 / 255.0 blue:14.0 / 255.0 alpha:1.0];
    
    UIView *listView = [self viewWithImageName:@"list"];
    UIColor *brownColor = [UIColor colorWithRed:206.0 / 255.0 green:149.0 / 255.0 blue:98.0 / 255.0 alpha:1.0];
    
    UIView *stickView = [self viewWithImageName:@"stick"];
    UIColor *stickColor = [UIColor whAmethyst];
    
    // Setting the default inactive state color to the tableView background color
    [cell setDefaultColor:self.tableView.backgroundColor];
    [cell setDelegate:(id)self];
    
    if (jobList.deletedFlag == 0) {
        [cell setSwipeGestureWithView:checkView
                                color:greenColor
                                 mode:MCSwipeTableViewCellModeSwitch
                                state:MCSwipeTableViewCellState1
                      completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode){
                          
                          [self changeStateofCell:cell];
                      }];
        [cell setSwipeGestureWithView:checkView
                                color:greenColor
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
                          controller.jobListToEdit = jobList;
                          [self presentViewController:navigationController animated:YES completion:nil];
                      }];
        
        [cell setSwipeGestureWithView:stickView
                                color:stickColor
                                 mode:MCSwipeTableViewCellModeSwitch
                                state:MCSwipeTableViewCellState4
                      completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
                          NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
                          JobList *list = self.dataModel.jobs[indexPath.row];
                          [self.dataModel.jobs insertObject:list atIndex:0];
                          [self.dataModel.jobs removeObjectAtIndex:(indexPath.row + 1)];
                          [self.tableView moveRowAtIndexPath:[self.tableView indexPathForCell:cell] toIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                          [self configureStatusBar];
                          NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                          [self.tableView scrollToRowAtIndexPath:topIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                      }];
        
        
    }else if(jobList.deletedFlag == 1){
        [cell setSwipeGestureWithView:checkView
                                color:[UIColor whPeterRiver]
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
                          controller.jobListToEdit = jobList;
                          [self presentViewController:navigationController animated:YES completion:nil];
                      }];
    }
    cell.firstTrigger = 0.25;
    cell.secondTrigger = 0.4;
}

- (void)configureStateOfCell:(MCSwipeTableViewCell *)cell withJobList:(JobList *)jobList {
    if (jobList.deletedFlag == 0) {
        //date
        UILabel *label = (UILabel *)[cell.contentView viewWithTag:123];
        NSMutableAttributedString *dateAttributeString = [[NSMutableAttributedString alloc] initWithAttributedString:label.attributedText];
        [dateAttributeString removeAttribute:NSStrikethroughStyleAttributeName range:NSMakeRange(0, label.attributedText.length)];
        label.attributedText = dateAttributeString;

        //title
        NSMutableAttributedString *titleAttributeString = [[NSMutableAttributedString alloc] initWithAttributedString:cell.textLabel.attributedText];
        [titleAttributeString removeAttribute:NSStrikethroughStyleAttributeName range:NSMakeRange(0, cell.textLabel.attributedText.length)];
        cell.textLabel.attributedText = titleAttributeString;
        
        //detail title
        NSMutableAttributedString *detailAttributeString = [[NSMutableAttributedString alloc] initWithAttributedString:cell.detailTextLabel.attributedText];
        [detailAttributeString removeAttribute:NSStrikethroughStyleAttributeName range:NSMakeRange(0, cell.detailTextLabel.attributedText.length)];
        cell.detailTextLabel.attributedText = detailAttributeString;
        
    }else if(jobList.deletedFlag == 1){
        //data
        UILabel *label = (UILabel *)[cell.contentView viewWithTag:123];
        NSMutableAttributedString *dateAttributeString = [[NSMutableAttributedString alloc] initWithAttributedString:label.attributedText];
        [dateAttributeString addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(0, label.attributedText.length)];
        label.attributedText = dateAttributeString;
        
        //title
        NSMutableAttributedString *titleAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:cell.textLabel.attributedText];
        [titleAttributedString addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(0, cell.textLabel.attributedText.length)];
        cell.textLabel.attributedText = titleAttributedString;
        
        //detail
        NSMutableAttributedString *detailAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:cell.detailTextLabel.attributedText];
        [detailAttributedString addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(0, cell.detailTextLabel.attributedText.length)];
        cell.detailTextLabel.attributedText = detailAttributedString;
    }
    [self updateAllApplicationNum];
}

- (UIView *)viewWithImageName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeCenter;
    return imageView;
}

- (void)deleteCell:(MCSwipeTableViewCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.dataModel cancelLocalNotificationIndexOfJobs:indexPath.row];
    [self.dataModel.jobs removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
}

- (void)changeStateofCell:(MCSwipeTableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    JobList *jobList = self.dataModel.jobs[indexPath.row];
    NSInteger disDeletedNum = [self.dataModel numberOfDisDeletedJobsList];
    
    jobList.deletedFlag = !jobList.deletedFlag;
    [self configureStateOfCell:cell withJobList:jobList];
    [self configureSwapeCell:cell withJobList:jobList];
    [self.dataModel.jobs removeObjectAtIndex:indexPath.row];
    
    NSInteger insertIndex;
    NSIndexPath *desIndexPath;
    
    if (jobList.deletedFlag == 1) {
        insertIndex = disDeletedNum - 1;
        desIndexPath = [NSIndexPath indexPathForRow:disDeletedNum-1 inSection:0];
    }else if(jobList.deletedFlag == 0){
        insertIndex = 0;
        desIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    
    [self.dataModel.jobs insertObject:jobList atIndex:insertIndex];
    [self.tableView moveRowAtIndexPath:indexPath toIndexPath:desIndexPath];
    [self configureStatusBar];
    [self.tableView scrollToRowAtIndexPath:desIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
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
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
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
