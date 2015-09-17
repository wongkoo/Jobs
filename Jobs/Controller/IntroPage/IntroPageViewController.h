//
//  IntroPageViewController.h
//  Jobs
//
//  Created by 王振辉 on 15/6/22.
//  Copyright (c) 2015年 王振辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EAIntroView/EAIntroView.h>
#import "DataModel.h"
@interface IntroPageViewController : UIViewController<EAIntroDelegate>
@property (nonatomic, strong) DataModel *_dataModel;
@end
