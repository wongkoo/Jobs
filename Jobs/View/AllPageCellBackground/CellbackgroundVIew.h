//
//  CellbackgroundVIew.h
//  touch
//
//  Created by 王振辉 on 15/6/8.
//  Copyright (c) 2015年 王振辉. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CellColor) {
    CellColorWhite = 0,
    CellColorSliver,
    CellColorDarkGray
};

@interface CellbackgroundVIew : UIView

- (id)initWithColor:(CellColor)cellColor;
- (void)setColor:(CellColor)cellColor;

@end
