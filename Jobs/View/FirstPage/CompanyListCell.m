//
//  AllListsCompanyCell.m
//  Jobs
//
//  Created by 锤石 on 15/11/18.
//  Copyright © 2015年 王振辉. All rights reserved.
//

#import "CompanyListCell.h"
#import "Masonry.h"
#import "CellbackgroundVIew.h"
#import "JobsItem.h"
#import "UIColor+WHColor.h"

@interface CompanyListCell ()
@property (nonatomic, strong) UILabel *processLabel;
@property (nonatomic, strong) CellbackgroundVIew *cellBackgroundView;

@property (nonatomic, strong) UIView *checkView;
@property (nonatomic, strong) UIView *crossView;
@property (nonatomic, strong) UIView *editView;
@property (nonatomic, strong) UIView *stickView;
@property (nonatomic, strong) UIColor *greenColor;
@property (nonatomic, strong) UIColor *redColor;
@property (nonatomic, strong) UIColor *brownColor;
@property (nonatomic, strong) UIColor *stickColor;
@end

@implementation CompanyListCell

+ (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initElements];
    }
    return self;
}

- (void)initElements {
    //background
    self.cellBackgroundView = [[CellbackgroundVIew alloc] initWithColor:CellColorDarkGray];
    self.cellBackgroundView.tag = 23;
    [self.contentView addSubview:self.cellBackgroundView];
    [self.cellBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    //Label on right
    self.processLabel = [[UILabel alloc] init];
    self.processLabel.font = [UIFont boldSystemFontOfSize:18];
    self.processLabel.tag = 123;
    [self.contentView addSubview:self.processLabel];
    self.processLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.processLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(@40);
    }];
    
    //Cell swapView
    _checkView = [self viewWithImageName:@"check"];
    self.greenColor = [UIColor colorWithRed:85.0 / 255.0 green:213.0 / 255.0 blue:80.0 / 255.0 alpha:1.0];

    self.crossView = [self viewWithImageName:@"cross"];
    self.redColor = [UIColor colorWithRed:232.0 / 255.0 green:61.0 / 255.0 blue:14.0 / 255.0 alpha:1.0];

    self.editView = [self viewWithImageName:@"list"];
    self.brownColor = [UIColor colorWithRed:206.0 / 255.0 green:149.0 / 255.0 blue:98.0 / 255.0 alpha:1.0];

    self.stickView = [self viewWithImageName:@"stick"];
    self.stickColor = [UIColor whAmethyst];

    self.firstTrigger = 0.25;
    self.secondTrigger = 0.4;
    [self setDefaultColor:[UIColor whClouds]];
}

- (void)setCompany:(Company *)company {
    _company = company;
    [self reloadData];
}

- (void)reloadData {
    [self configureColor];
    [self configureText];
    [self configureState];
    [self configureSwapeStyle];
}

- (void)configureColor {
    [self.cellBackgroundView setColor:self.company.cellColor];
}

- (void)configureText {
    NSString *detailString = nil;
    NSString *dateString = nil;
    BOOL showsHours = NO;
    if ([self.company.positions count] != 0) {
        JobsItem *jobsItem = self.company.positions[0];
        
        NSDate *nowDate = [NSDate date];
        NSDateFormatter *referenceFormatter = [[NSDateFormatter alloc] init];
        [referenceFormatter setDateFormat:@"yyyy/MMdd"];
        NSString *referenceString = [referenceFormatter stringFromDate:nowDate];
        NSDate *referenceDate = [referenceFormatter dateFromString:referenceString]; //00：00 of today
        
        NSDate *dueDate = jobsItem.dueDate;
        NSTimeInterval timeInterval = [dueDate timeIntervalSinceDate:referenceDate];
        NSTimeInterval day = timeInterval/3600/24;
        
        NSString *dateFrontString = nil;
        if (day < 0) {
            dateFrontString = NSLocalizedString(@"AllListCompanyCell Already", @"已经 ");
        }else{
            if (day<1) {
                if ([dueDate timeIntervalSinceNow] < 0) {
                    dateFrontString = NSLocalizedString(@"AllListCompanyCell Already", @"已经 ");
                }else{
                    dateFrontString = [NSString stringWithFormat:NSLocalizedString(@"AllListCompanyCell %.1fhours later", @"%.1f小时后 "),[dueDate timeIntervalSinceNow]/3600];
                    showsHours = YES;
                }
            } else if (day < 2) {
                dateFrontString = NSLocalizedString(@"AllListCompanyCell Tomorrow", @"明天 ");
            } else if (day < 3) {
                dateFrontString = NSLocalizedString(@"AllListComPanyCell Day After Tomorrow", @"后天 ");
            } else if (day < 10) {
                dateFrontString = [NSString stringWithFormat:NSLocalizedString(@"AllListCompanyCell days later", @"%d天后 "),(int)day];
            } else {
                NSDateFormatter *dateFormatterToShow = [[NSDateFormatter alloc] init];
                [dateFormatterToShow setDateFormat:NSLocalizedString(@"AllListCompanyCell M/d", @"M月d日 ")];
                dateFrontString = [dateFormatterToShow stringFromDate:jobsItem.dueDate];
            }
        }
        
        dateString = [dateFrontString stringByAppendingString:jobsItem.nextTask];
        detailString = jobsItem.text;
        
    }else{
        dateString=@"";
        detailString = NSLocalizedString(@"AllListCompanyCell Haven't apply for a position", @"暂未申请职位");
    }
    
    CellColor cellColor = self.company.cellColor;
    UIColor *stringColor;
    if (cellColor == CellColorWhite || cellColor == CellColorSilver || cellColor == CellColorSky) {
        stringColor = [UIColor blackColor];
    }else {
        stringColor = [UIColor whiteColor];
    }
    
    //标题
    NSMutableAttributedString *titleAttributedString = [[NSMutableAttributedString alloc] initWithString:self.company.name];
    [titleAttributedString addAttribute:NSForegroundColorAttributeName value:stringColor range:NSMakeRange(0, self.company.name.length)];
    [titleAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, self.company.name.length)];
    self.textLabel.attributedText = titleAttributedString;
    
    //副标题
    NSMutableAttributedString *detailAttrString = [[NSMutableAttributedString alloc] initWithString:detailString];
    [detailAttrString addAttribute:NSForegroundColorAttributeName value:stringColor range:NSMakeRange(0, detailString.length)];
    self.detailTextLabel.attributedText = detailAttrString;
    
    //日期
    NSMutableAttributedString *labelAttrString = [[NSMutableAttributedString alloc] initWithString:dateString];
    [labelAttrString addAttribute:NSForegroundColorAttributeName value:stringColor range:NSMakeRange(0, dateString.length)];
    if ( ![dateString isEqualToString:@""] && dateString.length >= 2) {
        [labelAttrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(dateString.length - 2, 2)];
    }
    if (showsHours) {
        [labelAttrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(3, 3)];
    }
    self.processLabel.attributedText = labelAttrString;
}

- (void)configureState {
    if (self.company.deletedFlag == 0) {
        //date
        NSMutableAttributedString *dateAttributeString = [[NSMutableAttributedString alloc] initWithAttributedString:self.processLabel.attributedText];
        [dateAttributeString removeAttribute:NSStrikethroughStyleAttributeName range:NSMakeRange(0, self.processLabel.attributedText.length)];
        self.processLabel.attributedText = dateAttributeString;
        
        //title
        NSMutableAttributedString *titleAttributeString = [[NSMutableAttributedString alloc] initWithAttributedString:self.textLabel.attributedText];
        [titleAttributeString removeAttribute:NSStrikethroughStyleAttributeName range:NSMakeRange(0, self.textLabel.attributedText.length)];
        self.textLabel.attributedText = titleAttributeString;
        
        //detail title
        NSMutableAttributedString *detailAttributeString = [[NSMutableAttributedString alloc] initWithAttributedString:self.detailTextLabel.attributedText];
        [detailAttributeString removeAttribute:NSStrikethroughStyleAttributeName range:NSMakeRange(0, self.detailTextLabel.attributedText.length)];
        self.detailTextLabel.attributedText = detailAttributeString;
        
    }else if(self.company.deletedFlag == 1){
        //data
        NSMutableAttributedString *dateAttributeString = [[NSMutableAttributedString alloc] initWithAttributedString:self.processLabel.attributedText];
        [dateAttributeString addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(0, self.processLabel.attributedText.length)];
        self.processLabel.attributedText = dateAttributeString;
        
        //title
        NSMutableAttributedString *titleAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.textLabel.attributedText];
        [titleAttributedString addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(0, self.textLabel.attributedText.length)];
        self.textLabel.attributedText = titleAttributedString;
        
        //detail
        NSMutableAttributedString *detailAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.detailTextLabel.attributedText];
        [detailAttributedString addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(0, self.detailTextLabel.attributedText.length)];
        self.detailTextLabel.attributedText = detailAttributedString;
    }
}

- (void)configureSwapeStyle {
    if (self.company.deletedFlag == 0) {
        [self setSwipeGestureWithView:_checkView
                                color:_greenColor
                                 mode:MCSwipeTableViewCellModeSwitch
                                state:MCSwipeTableViewCellState1
                      completionBlock:self.checkCompletetionBlock];
        
        [self setSwipeGestureWithView:_checkView
                                color:_greenColor
                                 mode:MCSwipeTableViewCellModeSwitch
                                state:MCSwipeTableViewCellState2
                      completionBlock:self.checkCompletetionBlock];
        
        [self setSwipeGestureWithView:_editView
                                color:_brownColor
                                 mode:MCSwipeTableViewCellModeExit
                                state:MCSwipeTableViewCellState3
                      completionBlock:self.editCompletetionBlock];
        
        [self setSwipeGestureWithView:_stickView
                                color:_stickColor
                                 mode:MCSwipeTableViewCellModeSwitch
                                state:MCSwipeTableViewCellState4
                      completionBlock:self.stickCompletetionBlock];
        
        
    }else if(self.company.deletedFlag == 1){
        [self setSwipeGestureWithView:_checkView
                                color:[UIColor whPeterRiver]
                                 mode:MCSwipeTableViewCellModeSwitch
                                state:MCSwipeTableViewCellState1
                      completionBlock:self.checkCompletetionBlock];
        
        [self setSwipeGestureWithView:_crossView
                                color:_redColor
                                 mode:MCSwipeTableViewCellModeExit
                                state:MCSwipeTableViewCellState2
                      completionBlock:self.crossCompletetionBlock];
        
        [self setSwipeGestureWithView:_editView
                                color:_brownColor
                                 mode:MCSwipeTableViewCellModeExit
                                state:MCSwipeTableViewCellState3
                      completionBlock:self.editCompletetionBlock];
        
        [self setSwipeGestureWithView:_editView
                                color:_brownColor
                                 mode:MCSwipeTableViewCellModeExit
                                state:MCSwipeTableViewCellState4
                      completionBlock:self.editCompletetionBlock];
    }
}

- (UIView *)viewWithImageName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeCenter;
    return imageView;
}

@end
