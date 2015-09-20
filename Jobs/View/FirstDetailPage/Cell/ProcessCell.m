//
//  ProcessCell.m
//  Jobs
//
//  Created by 王振辉 on 15/9/20.
//  Copyright © 2015年 王振辉. All rights reserved.
//

#import "ProcessCell.h"
#import "Masonry.h"

@implementation ProcessCell

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
    _timeLabel = [[UILabel alloc]init];
//    _timeLabel.backgroundColor = [UIColor redColor];
    _timeLabel.text = @"12月12日22:22";
    [self addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(@28);
        make.width.equalTo(@120);
    }];
    
    _processLabel = [[UILabel alloc]init];
    //_processLabel.textAlignment = NSTextAlignmentRight;
//    _processLabel.backgroundColor = [UIColor blueColor];
    _processLabel.text = @"宣讲会";
    [self addSubview:_processLabel];
    [_processLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_timeLabel.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-16);
        make.height.equalTo(@28);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    UILabel *line = [[UILabel alloc]init];
    line.backgroundColor = [UIColor orangeColor];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_timeLabel.mas_right).offset(3);
        make.right.equalTo(_processLabel.mas_left).offset(-3);
        make.height.equalTo(self.mas_height);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    UIView *circle = [[UIView alloc]init];
    circle.backgroundColor = [UIColor grayColor];
    circle.layer.cornerRadius = 4;
    [self addSubview:circle];
    [circle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(line.mas_centerY);
        make.centerX.equalTo(line.mas_centerX);
        make.height.equalTo(@8);
        make.width.equalTo(@8);
    }];
}

@end
