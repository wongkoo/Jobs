//
//  ColorSelectCell.m
//  Jobs
//
//  Created by 锤石 on 15/11/5.
//  Copyright © 2015年 王振辉. All rights reserved.
//

#import "ColorSelectCell.h"
#import "Masonry.h"

@interface ColorSelectCell ()
@property (nonatomic, strong) CellbackgroundVIew *colorView;
@property (nonatomic, strong) UILabel *label;
@end

@implementation ColorSelectCell

+ (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}



#pragma mark - Initialization

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    self.label = [UILabel new];
    self.label.backgroundColor = [UIColor clearColor];
    [self addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.width.equalTo(@85);
        make.height.equalTo(@28);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    self.colorView = [[CellbackgroundVIew alloc] initWithColor:CellColorWhite];
    self.colorView.layer.cornerRadius = 5.0f;
    [self addSubview:self.colorView];
    [self.colorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_label.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-16);
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(_label.mas_height).offset(5);
    }];
}

- (void)setCellColor:(CellColor)cellColor {
    [(CellbackgroundVIew *)_colorView setColor:cellColor];
}

- (void)setTitle:(NSString *)title {
    _title = [title copy];
    self.label.text = _title;
}

@end
