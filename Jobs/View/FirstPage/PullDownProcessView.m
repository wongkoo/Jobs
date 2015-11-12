//
//  PullDownProcessView.m
//  Jobs
//
//  Created by 锤石 on 15/11/10.
//  Copyright © 2015年 王振辉. All rights reserved.
//

#import "PullDownProcessView.h"
#define LABEL_HEIGHT 40
@interface PullDownProcessView ()
@property (nonatomic, strong) UILabel *label;
@end

@implementation PullDownProcessView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initLabel];
    }
    return self;
}

- (void)initLabel {
    self.label = [[UILabel alloc] init];
    self.label.text = @"▽ Add Company";
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.alpha = 0.0;
    [self addSubview:self.label];
    self.clipsToBounds = YES;
}

- (void)setProcess:(float)process {
    if (process < 0) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 0);
        return;
    }
    
    self.backgroundColor = [UIColor colorWithRed:(236.0 - process)/255.0 green:(240.0 - process*1.2)/255.0 blue:(241.0 - process*1.3)/255.0 alpha:1.0];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, process);

    _process = process;
    self.label.frame = CGRectMake(0, self.frame.size.height - LABEL_HEIGHT - 60 + process, self.frame.size.width, LABEL_HEIGHT);
    self.label.alpha = process/100;
}

@end
