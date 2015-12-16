//
//  AddButtonCell.m
//  Jobs
//
//  Created by 王振辉 on 15/9/20.
//  Copyright © 2015年 王振辉. All rights reserved.
//

#import "AddButtonCell.h"
#import "Masonry.h"

@implementation AddButtonCell

+ (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}



#pragma mark - Initialization

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initializer];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initializer];
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        [self initializer];
    }
    return self;
}

- (void)initializer {
    _addButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    _addButton.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    _addButton.layer.shadowOffset = CGSizeMake(2, 2);
    _addButton.layer.shadowRadius = 2;
    _addButton.layer.shadowOpacity = 0.8;
    [self addSubview:_addButton];
    [_addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    _sortButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_sortButton setBackgroundImage:[UIImage imageNamed:@"sort"] forState:UIControlStateNormal];
    [_sortButton setAlpha:0.6];
    _sortButton.layer.shadowColor = [UIColor grayColor].CGColor;
    _sortButton.layer.shadowOffset = CGSizeMake(2, 2);
    _sortButton.layer.shadowRadius = 2;
    _sortButton.layer.shadowOpacity = 0.8;
    [self addSubview:_sortButton];
    [_sortButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-16);
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(@30);
        make.width.equalTo(@30);
    }];
}

@end
