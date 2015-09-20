//
//  ShadowNavController.m
//  Jobs
//
//  Created by 王振辉 on 15/9/20.
//  Copyright © 2015年 王振辉. All rights reserved.
//

#import "ShadowNavController.h"

@implementation ShadowNavController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.navigationBar.layer.shadowColor = [UIColor blackColor].CGColor; //shadowColor阴影颜色
        self.navigationBar.layer.shadowOffset = CGSizeMake(2.0f , 2.0f); //shadowOffset阴影偏移x，y向(上/下)偏移(-/+)2
        self.navigationBar.layer.shadowOpacity = 0.25f;//阴影透明度，默认0
        self.navigationBar.layer.shadowRadius = 4.0f;//阴影半径
    }
    
    return self;
}

@end
