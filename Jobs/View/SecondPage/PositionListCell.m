//
//  PositionListCell.m
//  Jobs
//
//  Created by 锤石 on 15/12/22.
//  Copyright © 2015年 王振辉. All rights reserved.
//

#import "PositionListCell.h"
#import "CellbackgroundVIew.h"
#import "BEMCheckBox.h"
#import <Masonry.h>

static const CGFloat kCellHeight = 100;

@interface PositionListCell () <BEMCheckBoxDelegate>
@property (nonatomic, strong) CellbackgroundVIew *cellBackgroundView;
//@property (nonatomic, strong) BFPaperCheckbox *checkBox;
@property (nonatomic, strong) BEMCheckBox *checkBox;
@property (nonatomic, strong) UILabel *periodLabel;
@end

@implementation PositionListCell



#pragma mark - Class method

+ (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}

+ (CGFloat)cellHeight {
    return kCellHeight;
}



#pragma mark - Init

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initElements];
    }
    return self;
}

- (void)initElements {
    //background
    self.cellBackgroundView = [[CellbackgroundVIew alloc] initWithColor:CellColorWhite];
    self.cellBackgroundView.tag = 23;
    [self.contentView addSubview:self.cellBackgroundView];
    [self.cellBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    //checkBox
//    self.checkBox = [[BFPaperCheckbox alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - kCellHeight, 0, kCellHeight, kCellHeight)];
//    self.checkBox.delegate = self;
//    [self.checkBox uncheckAnimated:YES];
//    self.checkBox.rippleFromTapLocation = NO;
//    self.checkBox.tapCirclePositiveColor = [UIColor paperColorAmber];
//    self.checkBox.tapCircleNegativeColor = [UIColor paperColorRed];
//    self.checkBox.checkmarkColor = [UIColor paperColorLightBlue];
//    [self.contentView addSubview:self.checkBox];
////    [self.checkBox mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.centerY.equalTo(self.mas_centerY);
////        make.centerX.equalTo(self.mas_right).offset(-kCellHeight/2);
////        make.width.height.equalTo(@(kCellHeight));
////    }];
    
    self.checkBox = [[BEMCheckBox alloc] init];
//    self.checkBox.onAnimationType = BEMAnimationTypeFill;
//    self.checkBox.offAnimationType = BEMAnimationTypeFill;
//    self.checkBox.onFillColor = [UIColor blueColor];
    self.checkBox.delegate = self;
    [self.contentView addSubview:self.checkBox];
    [self.checkBox mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.mas_centerY);
                make.right.equalTo(self.mas_right).offset(-20);
                make.width.height.equalTo(@(40));
    }];
    
    
    //periodLabel
    self.periodLabel = [[UILabel alloc] init];
    self.periodLabel.font = [UIFont systemFontOfSize:18];
    [self.contentView addSubview:self.periodLabel];
    [self.periodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.checkBox.mas_left).offset(-20);
        make.height.equalTo(@20);
    }];
    
    self.textLabel.font = [UIFont systemFontOfSize:22.0];
}



#pragma mark - ReloadData

- (void)reloadData {
    [self reloadCheckBox];
    [self reloadText];
    [self reloadColor];
    [self reloadBlock];
}

- (void)reloadCheckBox {
    if (self.position.checked == self.checkBox.on) {
        return;
    }else{
        self.checkBox.on = self.position.checked;
    }
}

- (void)reloadText {
    self.periodLabel.text = self.position.nextTask;
    self.textLabel.text = self.position.text;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"M月dd日hh时mm分"];
    NSString *time = [dateFormatter stringFromDate:self.position.dueDate];
    if(self.position.shouldRemind == YES){
        self.detailTextLabel.text = [NSString stringWithFormat:@"⏰%@",time];
    }else{
        self.detailTextLabel.text = [NSString stringWithFormat:@"%@",time];
    }
}

- (void)reloadColor {
    if (self.position.checked) {
        self.periodLabel.textColor = [UIColor grayColor];
        self.textLabel.textColor = [UIColor grayColor];
        self.detailTextLabel.textColor = [UIColor grayColor];
    }else {
        self.periodLabel.textColor = [UIColor colorWithRed:213.0/255.0 green:73.0/255.0 blue:22.0/255.0 alpha:1];
        self.textLabel.textColor = [UIColor colorWithRed:130.0/255.0 green:18.0/255.0 blue:13.0/255.0 alpha:1];
        self.detailTextLabel.textColor =  [UIColor colorWithRed:121.0/255.0 green:67.0/255.0 blue:11.0/255.0 alpha:1];
    }
}

- (void)reloadBlock {
    UIView *crossView = [self viewWithImageName:@"cross"];
    UIColor *redColor = [UIColor colorWithRed:232.0 / 255.0 green:61.0 / 255.0 blue:14.0 / 255.0 alpha:1.0];
    UIView *listView = [self viewWithImageName:@"list"];
    UIColor *brownColor = [UIColor colorWithRed:206.0 / 255.0 green:149.0 / 255.0 blue:98.0 / 255.0 alpha:1.0];
    if (self.position.checked) {
        [self setSwipeGestureWithView:crossView
                                color:redColor
                                 mode:MCSwipeTableViewCellModeExit
                                state:MCSwipeTableViewCellState1
                      completionBlock:self.deleteCompletionBlock];
        
        [self setSwipeGestureWithView:listView
                                color:brownColor
                                 mode:MCSwipeTableViewCellModeExit
                                state:MCSwipeTableViewCellState3
                      completionBlock:self.editCompletionBlock];
    }else {
        [self setSwipeGestureWithView:crossView
                                color:redColor
                                 mode:MCSwipeTableViewCellModeNone
                                state:MCSwipeTableViewCellState1
                      completionBlock:nil];
        
        [self setSwipeGestureWithView:listView
                                color:brownColor
                                 mode:MCSwipeTableViewCellModeExit
                                state:MCSwipeTableViewCellState3
                      completionBlock:self.editCompletionBlock];

    }
}

- (UIView *)viewWithImageName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeCenter;
    return imageView;
}



#pragma mark - Setter

- (void)setPosition:(JobsItem *)position {
    _position = position;
    [self reloadData];
}



#pragma mark - BEMCheckBoxDelegate

- (void)didTapCheckBox:(BEMCheckBox *)checkBox {
    self.position.checked = checkBox.on;
    [self reloadData];
}

//- (void)animationDidStopForCheckBox:(BEMCheckBox *)checkBox {
//    self.position.checked = checkBox.on;
//    [self reloadData];
//}


@end
