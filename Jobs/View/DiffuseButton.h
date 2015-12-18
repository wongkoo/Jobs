//
//  DiffuseButton.h
//  Jobs
//
//  Created by 锤石 on 15/11/24.
//  Copyright © 2015年 王振辉. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiffuseButton : UIControl

- (id)initWithRadius:(CGFloat)radius backgroundColor:(UIColor *)backgroundColor lineColor:(UIColor *)lineColor;
- (void)drawButton;

@end
