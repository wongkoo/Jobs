//
//  PureColorBackgroundView.m
//  Jobs
//
//  Created by 锤石 on 15/11/12.
//  Copyright © 2015年 王振辉. All rights reserved.
//

#import "PureColorBackgroundView.h"
#import "UIColor+WHColor.h"

@implementation PureColorBackgroundView

- (void)setPureColor:(PureColor)pureColor {
    switch (pureColor) {
        case PureColorColorWhite:
            self.backgroundColor = RGB(249.0f, 249.0f, 249.0f);
            break;
        case PureColorColorSilver:
            self.backgroundColor = RGB(202.0f, 202.0f, 202.0f);
            break;
        case PureColorDarkGray:
            self.backgroundColor = RGB(42.0f, 42.0f, 42.0f);
            break;
        case PureColorConcrete:
            self.backgroundColor = RGB(84.0f, 84.0f, 84.0f);
            break;
        case PureColorSky:
            self.backgroundColor = RGB(206.0f, 227.0f, 255.0f);
            break;
        case PureColorVista:
            self.backgroundColor = RGB(74.0f, 121.0f, 181.0f);
            break;
        case PureColorDenim:
            self.backgroundColor = RGB(37.0f, 67.0f, 133.0f);
            break;
        case PureColorMidnight:
            self.backgroundColor = RGB(16.0f, 42.0f, 75.0f);
            break;
        default:
            self.backgroundColor = RGB(249.0f, 249.0f, 249.0f);
            break;
    }
}

@end
