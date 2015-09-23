//
//  ProcessView.m
//  Jobs
//
//  Created by 王振辉 on 15/9/23.
//  Copyright © 2015年 王振辉. All rights reserved.
//

#import "ProcessView.h"

@implementation ProcessView

- (id)init {
    self = [super init];
    if (self) {
        [self defaultInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self defaultInit];
    }
    
    return self;
}

- (void)defaultInit {
    self.backgroundColor = [UIColor redColor];
}


#pragma mark - Setter
- (void)setProcess:(NSMutableArray *)process {
    _process = process;
    [self drawProcess];
}


#pragma mark - Draw
- (void)drawProcess {
    
}


@end
