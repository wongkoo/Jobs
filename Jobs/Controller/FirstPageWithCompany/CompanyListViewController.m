//
//  AllListsViewController.m
//  Jobs
//
//  Created by 王振辉 on 15/6/4.
//  Copyright (c) 2015年 王振辉. All rights reserved.
//

#import "CompanyListViewController.h"
#import "CompanyDetailViewController.h"
#import "PositionListViewController.h"
#import "ShareViewController.h"

#import "Company.h"
#import "jobsItem.h"
#import "DataModel.h"

#import "PullDownProcessView.h"
#import "DiffuseButton.h"
#import "UIColor+WHColor.h"
#import "Masonry.h"
#import "CompanyListCell.h"

static const NSInteger CELL_HEIGHT = 80;
static NSString * const SegueAddOrEditIdentifier = @"AddCompany";
static NSString * const SegueShowPositionIdentifier = @"ShowPosition";

@interface CompanyListViewController ()<UINavigationControllerDelegate,UIViewControllerPreviewingDelegate,ViewController3DTouchDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DiffuseButton *menuButton;
@property (nonatomic, strong) PullDownProcessView *pullDownProcessView;

@property (nonatomic, strong) DataModel *dataModel;                     ///< dataModel should be used bu self.dataModel
@property (nonatomic, strong) UILabel *allApplicationNumLabel;
@property (nonatomic, assign) BOOL forceTouchAvailable;
@property (nonatomic, strong) NSIndexPath *indexPathOfForceTouch;
@property (nonatomic, assign) CGPoint panPoint;
@property (nonatomic, assign) BOOL pulled;
@end

@implementation CompanyListViewController



#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = NSLocalizedString(@"AllListViewController Company", @"公司");
    
    [self initViews];
    [self checkForceTouch];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.menuButton zoomOutReload];
    [self updateAllApplicationNum];
    [self.tableView reloadData];
    [self configPullDownProcessView];
    [self configureShareButton];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



#pragma mark - InitViews

- (void)initViews {
    [self initTableView];
    [self initPullDownProcessView];
    [self initMenuButton];
}

- (void)initTableView {
    //TableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollsToTop = YES;
    self.tableView.showsVerticalScrollIndicator =NO;
    [self.view addSubview:self.tableView];
    
    //TableViewFooterView
    self.allApplicationNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    self.allApplicationNumLabel.font = [UIFont systemFontOfSize:15];
    self.allApplicationNumLabel.textAlignment = NSTextAlignmentCenter;
    self.allApplicationNumLabel.textColor = [UIColor whMidnightBlue];
    self.allApplicationNumLabel.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = self.allApplicationNumLabel;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView.panGestureRecognizer addTarget:self action:@selector(paned:)];
    
    //TableView background
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor whClouds];
    self.tableView.backgroundView = backgroundView;
    
    //Jobs's icon in TableView background
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
    
    //UITableViewWrapperView Background which cover Jobs's icon
    for (UIView *subview in self.tableView.subviews)
    {
        if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewWrapperView"])
        {
            subview.backgroundColor = [UIColor whClouds];
        }
    }
}

- (void)initPullDownProcessView {
    self.pullDownProcessView = [[PullDownProcessView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    [self.view addSubview:self.pullDownProcessView];
}

- (void)initMenuButton {
    NSArray *menuTitles = @[@"关于",@"分享"];
    self.menuButton = [[DiffuseButton alloc] initWithRadius:20
                                            backgroundColor:[UIColor whBelizeHole]
                                                  lineColor:[UIColor whiteColor]
                                                 menuTitles:menuTitles
                                              selectedblock:^(NSInteger index) {
                                                  if (index == 1) {
                                                      [self pushShareViewController];
                                                  }
                                              } frame:self.view.frame];
    
    [self.view addSubview:self.menuButton];
    [self.menuButton drawButton];
}



#pragma mark - ConfigViews

- (void)configureShareButton {
    if (self.menuButton.superview == nil) {
        self.menuButton = nil;
        [self initMenuButton];
    }
}

- (void)configPullDownProcessView {
    if (self.dataModel.companyList.count > 0) {
        Company *company = self.dataModel.companyList[0];
        [self changePullDownProcessViewWithCellColor:company.cellColor];
    }else{
        [self changePullDownProcessViewWithCellColor:CellColorWhite];
    }
}

- (void)changePullDownProcessViewWithCellColor:(CellColor)cellColor {
    self.pullDownProcessView.pureColor = (PureColor)cellColor;
    if (cellColor == CellColorWhite || cellColor == CellColorSilver || cellColor == CellColorSky) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }else{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
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
    if (self.dataModel.companyList.count == 0) {
        string = NSLocalizedString(@"AllListViewController Pull down to add company", @"下拉添加公司");
    }else{
        string = [NSString stringWithFormat:NSLocalizedString(@"AllListViewController Under way position number: %ld", @"%ld个职位正在进行中"),(long)[self.dataModel numberOfUncheckedJobsItem]];
    }
    self.allApplicationNumLabel.text=string;
}



#pragma mark - MenuButtonAction

- (void)pushShareViewController {
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
    
    [self.navigationController pushViewController:shareViewController animated:NO];
}



#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:SegueShowPositionIdentifier]) {
        PositionListViewController *controller = segue.destinationViewController;
        controller.company = sender;
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        
    }else if([segue.identifier isEqualToString:SegueAddOrEditIdentifier]){
        
        UINavigationController *navigationController = segue.destinationViewController;
        CompanyDetailViewController *controller = (CompanyDetailViewController *)navigationController.topViewController;
        __weak typeof(self) weakSelf = self;
        
        if (sender) {
            controller.companyToEdit = sender;
            controller.companyDetailOpenType = CompanyDetailOpenTypeEdit;
            controller.editCompanyReloadBlock = ^(Company *fromCompany, Company *toCompany) {
                [weakSelf companyDetailEditReloadFromCompany:fromCompany toCompany:toCompany];
            };
        }else{
            controller.companyDetailOpenType = CompanyDetailOpenTypeAdd;
            controller.addCompanyInsertZeroBlock = ^(Company *company){
                [weakSelf companyDetailAddCompanyInsert:company];
            };
        }
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (IBAction)backToAllListsViewController:(UIStoryboardSegue *)segue {
    
}



#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CompanyListCell *cell = [tableView dequeueReusableCellWithIdentifier:[CompanyListCell reuseIdentifier]];
    
    if (!cell) {
        cell = [[CompanyListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:[CompanyListCell reuseIdentifier]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        __weak typeof(self) weakSelf =  self;
        
        cell.editCompletetionBlock = ^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode){
            CompanyListCell *myCell = (CompanyListCell *)cell;
            [weakSelf performSegueWithIdentifier:SegueAddOrEditIdentifier sender:myCell.company];
        };
        
        cell.stickCompletetionBlock = ^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode){
            [weakSelf stickCell:(CompanyListCell *)cell];
        };
        
        cell.crossCompletetionBlock = ^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode){
            [weakSelf deleteCell:(CompanyListCell *)cell];
        };
        
        cell.checkCompletetionBlock = ^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode){
            [weakSelf changeStateofCell:(CompanyListCell *)cell];
        };
    }
    
    cell.company = self.dataModel.companyList[indexPath.row];
    
    if (_forceTouchAvailable) {
        [self registerForPreviewingWithDelegate:self sourceView:cell];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataModel.companyList count];
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

- (void)stickCell:(CompanyListCell *)cell {
    NSInteger index = [self.dataModel.companyList indexOfObject:cell.company];
    [self.dataModel.companyList insertObject:cell.company atIndex:0];
    [self.dataModel.companyList removeObjectAtIndex:(index + 1)];
    [self.tableView moveRowAtIndexPath:[self.tableView indexPathForCell:cell] toIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [self configPullDownProcessView];
    NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView scrollToRowAtIndexPath:topIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)deleteCell:(CompanyListCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.dataModel cancelLocalNotificationIndexOfJobs:indexPath.row];
    [self.dataModel.companyList removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
}

- (void)changeStateofCell:(CompanyListCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSInteger disDeletedNum = [self.dataModel numberOfDisDeletedCompany];
    
    cell.company.deletedFlag = !cell.company.deletedFlag;
    [cell reloadData];
    [self updateAllApplicationNum];
    
    [self.dataModel.companyList removeObjectAtIndex:indexPath.row];
    
    NSInteger insertIndex;
    NSIndexPath *desIndexPath;
    
    if (cell.company.deletedFlag == 1) {
        insertIndex = disDeletedNum - 1;
        desIndexPath = [NSIndexPath indexPathForRow:disDeletedNum-1 inSection:0];
    }else if(cell.company.deletedFlag == 0){
        insertIndex = 0;
        desIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    
    [self.dataModel.companyList insertObject:cell.company atIndex:insertIndex];
    [self.tableView moveRowAtIndexPath:indexPath toIndexPath:desIndexPath];
    [self configPullDownProcessView];
    [self.tableView scrollToRowAtIndexPath:desIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}



#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.dataModel setIndexOfSelectedCompany:indexPath.row];
    Company *company = self.dataModel.companyList[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:SegueShowPositionIdentifier sender:company];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}



#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat y = scrollView.contentOffset.y;
    CGPoint point = self.panPoint;
    point.y = -y;
    self.panPoint = point;
    
    if (self.pulled) {
        self.pullDownProcessView.point = self.panPoint;
    }
    
    if (y <= 0) {
        self.pulled = YES;
        
        if (scrollView.contentOffset.y < -110) {
            [self performSegueWithIdentifier:SegueAddOrEditIdentifier sender:nil];
        }
    }else{
        self.pulled = NO;
        int row = (int)(scrollView.contentOffset.y/80);
        if (row < self.dataModel.companyList.count) {
            Company *company = self.dataModel.companyList[row];
            [self changePullDownProcessViewWithCellColor:company.cellColor];
        }
    }
}

- (void)paned:(UIPanGestureRecognizer *)gesture {
    if (self.pulled) {
        CGPoint point = self.panPoint;
        point.x = [gesture locationInView:self.tableView].x;
        self.panPoint = point;
        self.pullDownProcessView.point = self.panPoint;
    }
}



#pragma mark - UINavigationControllerDelegate

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (viewController == self) {
        [self.dataModel setIndexOfSelectedCompany:-1];
    }
}



#pragma mark - UIViewControllerPreviewingDelegate

- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    
    _indexPathOfForceTouch = [self.tableView indexPathForCell:(MCSwipeTableViewCell *)previewingContext.sourceView];
    [self.tableView deselectRowAtIndexPath:_indexPathOfForceTouch animated:NO];
    
    if ([self.presentedViewController isKindOfClass:[PositionListViewController class]]) {
        PositionListViewController *previewController = (PositionListViewController *)self.presentedViewController;
        previewController.company = self.dataModel.companyList[_indexPathOfForceTouch.row];
        previewController.delegate = self;
        return nil;
    }
    
    PositionListViewController *previewController = [[PositionListViewController alloc]init];
    previewController.company  = self.dataModel.companyList[_indexPathOfForceTouch.row];
    previewController.delegate = self;
    return previewController;
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    
    [self.dataModel setIndexOfSelectedCompany:_indexPathOfForceTouch.row];
    Company *company = self.dataModel.companyList[_indexPathOfForceTouch.row];
    [self.tableView deselectRowAtIndexPath:_indexPathOfForceTouch animated:NO];
    [self performSegueWithIdentifier:SegueShowPositionIdentifier sender:company];

}



#pragma mark - ViewController3DTouchDelegate

- (void)deleteCompany:(Company *)company {
    NSInteger index = [self.dataModel.companyList indexOfObject:company];
    [self.dataModel.companyList removeObject:company];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}
- (void)addPositionInCompany:(Company *)company {
    company.addPositionBy3DTouch = YES;
    [self performSegueWithIdentifier:SegueShowPositionIdentifier sender:company];
}



#pragma mark - ListDetailViewControllerCallBack

- (void)companyDetailAddCompanyInsert:(Company *)company {
    [self.dataModel.companyList insertObject:company atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    NSArray *indexPaths = @[indexPath];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)companyDetailEditReloadFromCompany:(Company *)fromCompany toCompany:(Company *)toCompany {
    NSInteger index = [self.dataModel.companyList indexOfObject:fromCompany];
    [self.dataModel.companyList replaceObjectAtIndex:index withObject:toCompany];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}




#pragma mark - Getter

- (DataModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [DataModel sharedInstance];
    }
    return _dataModel;
}
@end
