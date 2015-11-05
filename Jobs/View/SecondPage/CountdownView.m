//
//  CountdownView.m
//  Jobs
//
//  Created by 王振辉 on 15/10/5.
//  Copyright © 2015年 王振辉. All rights reserved.
//

#import "CountdownView.h"

@interface CountdownView () {
    NSInteger differFromNowToTarget;
    NSInteger countDownTimerLabelType;
    NSTimer *countDownTimer;
    
    UIVisualEffectView *visualEffectView;
    UIView *stageDetailView;
    
    UILabel *countDownTimerLabel;
    UILabel *companyLabel;
    UILabel *jobLabel;
    UILabel *stageLabel;
}

@end

@implementation CountdownView

- (id)init {
    self = [self initWithFrame:[UIScreen mainScreen].bounds];
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
    UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualEffectView.frame = self.bounds;
    visualEffectView.alpha = 0;
    [self addSubview:visualEffectView];
    
    CGFloat frameX = self.bounds.size.width *1/10;
    CGFloat frameY = (self.bounds.size.height - 20 - 44) *1/10;
    CGFloat sizeWidth = self.bounds.size.width *4/5;
    CGFloat sizeHeight = (self.bounds.size.height - 20 - 44) *4/5;
    
    stageDetailView= [[UIView alloc]initWithFrame:CGRectMake(frameX, 0, sizeWidth, sizeHeight)];
    stageDetailView.alpha = 0;
    stageDetailView.layer.cornerRadius = 10;
    stageDetailView.backgroundColor = [UIColor whiteColor];
    stageDetailView.layer.shadowColor = [UIColor blackColor].CGColor;
    stageDetailView.layer.shadowOffset = CGSizeMake(4, 4);
    stageDetailView.layer.shadowOpacity = 0.6;
    stageDetailView.layer.shadowRadius = 10;
    
    [self addSubview:stageDetailView];
    
    [UIView animateWithDuration:0.25 animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.25];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        visualEffectView.alpha = 1;
        stageDetailView.alpha = 1;
        stageDetailView.frame = CGRectMake(frameX, frameY, sizeWidth, sizeHeight);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handTapFrom:)];
    [self addGestureRecognizer:tap];
}

#pragma mark - Setter
- (void)setCompanyNameString:(NSString *)companyNameString {
    _companyNameString = companyNameString;
    
    companyLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    companyLabel.text = _companyNameString;
    companyLabel.textColor = [UIColor colorWithRed:255.0/255.0 green:77.0/255.0 blue:0.0 alpha:1];
    companyLabel.font = [UIFont systemFontOfSize:33];
    companyLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [stageDetailView addSubview:companyLabel];
    [stageDetailView addConstraint:[NSLayoutConstraint constraintWithItem:companyLabel
                                                                attribute:NSLayoutAttributeCenterX
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:stageDetailView
                                                                attribute:NSLayoutAttributeCenterX
                                                               multiplier:1
                                                                 constant:0]];
    [stageDetailView addConstraint:[NSLayoutConstraint constraintWithItem:companyLabel
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:stageDetailView
                                                                attribute:NSLayoutAttributeTop
                                                               multiplier:1
                                                                 constant:40]];
}

- (void)setJobNameString:(NSString *)jobNameString {
    _jobNameString = jobNameString;
    
    jobLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    jobLabel.text = _jobNameString;
    jobLabel.textColor = [UIColor colorWithRed:255.0/255.0 green:77.0/255.0 blue:0.0 alpha:1];
    jobLabel.font = [UIFont systemFontOfSize:25];
    jobLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [stageDetailView addSubview:jobLabel];
    [stageDetailView addConstraint:[NSLayoutConstraint constraintWithItem:jobLabel
                                                                attribute:NSLayoutAttributeCenterX
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:stageDetailView
                                                                attribute:NSLayoutAttributeCenterX
                                                               multiplier:1
                                                                 constant:0]];
    [stageDetailView addConstraint:[NSLayoutConstraint constraintWithItem:jobLabel
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                   toItem:companyLabel
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1
                                                                 constant:0]];
    [stageDetailView addConstraint:[NSLayoutConstraint constraintWithItem:jobLabel
                                                                attribute:NSLayoutAttributeBottom
                                                                relatedBy:NSLayoutRelationLessThanOrEqual
                                                                   toItem:countDownTimerLabel
                                                                attribute:NSLayoutAttributeTop
                                                               multiplier:1
                                                                 constant:0]];
}

- (void)setNextTaskString:(NSString *)nextTaskString {
    _nextTaskString = nextTaskString;
    
    stageLabel = [[UILabel alloc]init];
    stageLabel.text = _nextTaskString;
    stageLabel.textColor = [UIColor colorWithRed:255.0/255.0 green:77.0/255.0 blue:0.0 alpha:1];
    stageLabel.font = [UIFont systemFontOfSize:40];
    stageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [stageDetailView addSubview:stageLabel];
    [stageDetailView addConstraint:[NSLayoutConstraint constraintWithItem:stageLabel
                                                                attribute:NSLayoutAttributeCenterX
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:stageDetailView
                                                                attribute:NSLayoutAttributeCenterX
                                                               multiplier:1
                                                                 constant:0]];
    [stageDetailView addConstraint:[NSLayoutConstraint constraintWithItem:stageLabel
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:countDownTimerLabel
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1
                                                                 constant:0]];
}

- (void)setDueDate:(NSDate *)dueDate {
    _dueDate = dueDate;
    
    differFromNowToTarget = [_dueDate timeIntervalSinceNow];
    countDownTimerLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    countDownTimerLabel.textColor = [UIColor whiteColor];
    countDownTimerLabel.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:77.0/255.0 blue:0.0 alpha:1];
    
    countDownTimerLabelType = -1;
    [self UpdateCountDownLabel];
    countDownTimerLabel.font = [UIFont systemFontOfSize:40];
    countDownTimerLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [stageDetailView addSubview:countDownTimerLabel];
    countDownTimerLabel.layer.cornerRadius = 10;
    countDownTimerLabel.clipsToBounds = YES;
    [stageDetailView addConstraint:[NSLayoutConstraint constraintWithItem:countDownTimerLabel
                                                                attribute:NSLayoutAttributeCenterX
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:stageDetailView
                                                                attribute:NSLayoutAttributeCenterX
                                                               multiplier:1
                                                                 constant:0]];
    [stageDetailView addConstraint:[NSLayoutConstraint constraintWithItem:countDownTimerLabel
                                                                attribute:NSLayoutAttributeCenterY
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:stageDetailView
                                                                attribute:NSLayoutAttributeCenterY
                                                               multiplier:1
                                                                 constant:0]];
    
    [countDownTimerLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(countDownTimerLabelTapped:)]];
    countDownTimerLabel.userInteractionEnabled = YES;
    countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
}

-(void)timeFireMethod{
    differFromNowToTarget--;
    if (differFromNowToTarget <= 0) {
        [countDownTimer invalidate];
        return;
    }
    [self UpdateCountDownLabel];
}

- (void)UpdateCountDownLabel{
    if (countDownTimerLabelType == -1) {
        
        if(differFromNowToTarget > 3600 ){
            countDownTimerLabel.text = [NSString stringWithFormat:@"%ldhour后",(long)differFromNowToTarget/3600];
            countDownTimerLabelType = 0;
        }else if(differFromNowToTarget > 60 && differFromNowToTarget <=3600){
            countDownTimerLabel.text = [NSString stringWithFormat:@"%ldmin后",(long)differFromNowToTarget/60];
            countDownTimerLabelType = 1;
        }else if(differFromNowToTarget >0 && differFromNowToTarget <= 60){
            countDownTimerLabel.text = [NSString stringWithFormat:@"%lds后",(long)differFromNowToTarget];
            countDownTimerLabelType = 2;
        }else{
            countDownTimerLabel.text = @"已结束";
        }
        
    }else if(countDownTimerLabelType == 0){
        
        if (differFromNowToTarget >3600) {
            countDownTimerLabel.text = [NSString stringWithFormat:@"%ldhour后",(long)differFromNowToTarget/3600];
        }else{
            countDownTimerLabel.text = [NSString stringWithFormat:@"%.3fhour后",(double)differFromNowToTarget/3600.0];
        }
        
    }else if(countDownTimerLabelType == 1){
        
        countDownTimerLabel.text = [NSString stringWithFormat:@"%ldmin后",(long)differFromNowToTarget/60];
        
    }else if(countDownTimerLabelType == 2){
        
        countDownTimerLabel.text = [NSString stringWithFormat:@"%lds后",(long)differFromNowToTarget];
        
    }
}
- (void)countDownTimerLabelTapped:(UIGestureRecognizer *)gesture{
    if (countDownTimerLabelType == 0 || countDownTimerLabelType ==1) {
        countDownTimerLabelType ++;
    }else if(countDownTimerLabelType == 2){
        countDownTimerLabelType =0;
    }else if(countDownTimerLabelType == -1){
        countDownTimerLabelType = -1;
    }
    
    [self UpdateCountDownLabel];
}

- (void)handTapFrom:(UIGestureRecognizer *)gesture{
    [UIView animateWithDuration:0.25
                     animations:^{
                         [UIView setAnimationBeginsFromCurrentState:YES];
                         [UIView setAnimationDuration:0.25];
                         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                         visualEffectView.alpha = 0;
                         stageDetailView.alpha = 0;
                     }completion:^(BOOL finished) {
                         [stageDetailView removeFromSuperview];
                         [visualEffectView removeFromSuperview];
                         [self removeFromSuperview];
                         [self.delegate countdownViewRemoved];
                     }];
    
    [countDownTimer invalidate];
    [self removeGestureRecognizer:gesture];
   
    //**    Special in tableview    **
    UITableView *tableView = (UITableView *)self.superview;
    tableView.scrollEnabled = YES;
    
    countDownTimerLabelType = -1;
}

@end
