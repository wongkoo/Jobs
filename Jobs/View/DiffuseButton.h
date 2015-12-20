//
//  DiffuseButton.h
//  Jobs
//
//  Created by 锤石 on 15/11/24.
//  Copyright © 2015年 王振辉. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MenuSelectedIndexBlock)(NSInteger index);

@interface DiffuseButton : UIView

- (id)initWithRadius:(CGFloat)radius
     backgroundColor:(UIColor *)backgroundColor
           lineColor:(UIColor *)lineColor
          menuTitles:(NSArray *)menuTitles
       selectedblock:(MenuSelectedIndexBlock)block
               frame:(CGRect)frame;

- (void)drawButton;

- (void)zoomOutReload;

@end
