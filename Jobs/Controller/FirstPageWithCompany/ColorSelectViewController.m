//
//  ColorSelectViewController.m
//  Jobs
//
//  Created by 锤石 on 15/11/5.
//  Copyright © 2015年 王振辉. All rights reserved.
//

#import "ColorSelectViewController.h"
#import "UIColor+WHColor.h"
#import <Masonry.h>

@interface ColorSelectViewController ()<UITabBarControllerDelegate,UITableViewDataSource>
@end

@implementation ColorSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}



#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedBlock(indexPath.row);
    self.selectedBlock = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundView = [[CellbackgroundVIew alloc] initWithColor:CellColorWhite];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        UILabel *label = [[UILabel alloc] init];
        label.tag = 22;
        label.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(cell.mas_centerX);
            make.centerY.equalTo(cell.mas_centerY);
        }];
        
        
    }
    
    CellbackgroundVIew *view = (CellbackgroundVIew *)cell.backgroundView;
    [view setColor:indexPath.row];
    UILabel *label = [cell.contentView viewWithTag:22];
    switch (indexPath.row) {
        case 0:
            label.text = @"white";
            label.textColor = [UIColor blackColor];
            break;
        case 1:
            label.text = @"silver";
            label.textColor = [UIColor blackColor];
            break;
        case 2:
            label.text = @"concrete";
            label.textColor = [UIColor whiteColor];
            break;
        case 3:
            label.text = @"dark gray";
            label.textColor = [UIColor whiteColor];
            break;
        case 4:
            label.text = @"sky";
            label.textColor = [UIColor blackColor];
            break;
        case 5:
            label.text = @"vista";
            label.textColor = [UIColor whiteColor];
            break;
        case 6:
            label.text = @"demin";
            label.textColor = [UIColor whiteColor];
            break;
        case 7:
            label.text = @"midnight";
            label.textColor = [UIColor whiteColor];
            break;
        default:
            break;
    }
    
    if (indexPath.row == _cellColor) {
        view.layer.borderColor = [UIColor whPumpkin].CGColor;
        view.layer.borderWidth = 5;
    }
    
    return cell;
}


@end
