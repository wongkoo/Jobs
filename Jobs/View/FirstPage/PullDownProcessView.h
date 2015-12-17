//
//  PullDownProcessView.h
//  Jobs
//
//  Created by 锤石 on 15/11/10.
//  Copyright © 2015年 王振辉. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PureColor) {
    PureColorColorWhite = 0,
    PureColorColorSilver,
    PureColorConcrete,
    PureColorDarkGray,
    PureColorSky,
    PureColorVista,
    PureColorDenim,
    PureColorMidnight
};

@interface PullDownProcessView : UIView
@property (nonatomic, assign) PureColor pureColor;
@property (nonatomic, assign) CGPoint point;
@end
