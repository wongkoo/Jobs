//
//  ShareViewController.h
//  Jobs
//
//  Created by 锤石 on 15/12/1.
//  Copyright © 2015年 王振辉. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FinishBlock)(void);

@interface ShareViewController : UIViewController

@property (nonatomic, strong) UIImage *sharedImage;
@property (nonatomic, copy) FinishBlock finishBlock;

@end