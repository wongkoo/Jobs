//
//  JobsItem.m
//  Jobs
//
//  Created by 王振辉 on 15/6/3.
//  Copyright (c) 2015年 王振辉. All rights reserved.
//

#import "JobsItem.h"
#import "DataModel.h"
#import <UIKit/UIKit.h>

@implementation JobsItem

- (id)init{
    if ((self=[super init])) {
        self.itemId = [DataModel nextJobsItemId];
    }
    return self;
}

- (void)toggleChecked{
    self.checked = !self.checked;
}

- (void)scheduleNotification{
    UILocalNotification *exitingNotification = [self notificationForThisItem];
    if (exitingNotification != nil) {
        [[UIApplication sharedApplication]cancelLocalNotification:exitingNotification];
    }
    if (self.shouldRemind && [self.dueDate compare:[NSDate date]]!=NSOrderedAscending) {
        UILocalNotification *localNotification = [[UILocalNotification alloc]init];
        localNotification.fireDate = self.dueDate;
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.alertBody = self.text;
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.userInfo = @{@"ItemId":@(self.itemId)};
        [[UIApplication sharedApplication]scheduleLocalNotification:localNotification];
    }
}

- (UILocalNotification *)notificationForThisItem{
    NSArray *allNotifications = [[UIApplication sharedApplication]scheduledLocalNotifications];
    for (UILocalNotification *notification in allNotifications) {
        NSNumber *number = [notification.userInfo objectForKey:@"ItemId"];
        if (number != nil && [number integerValue]==self.itemId) {
            return notification;
        }
    }
    return nil;
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    if( (self = [super init]) ) {
        self.text = [aDecoder decodeObjectForKey:@"Text"];
        self.checked =[aDecoder decodeBoolForKey:@"Checked"];
        self.dueDate = [aDecoder decodeObjectForKey:@"DueDate"];
        self.shouldRemind = [aDecoder decodeBoolForKey:@"ShouldRemind"];
        self.itemId = [aDecoder decodeIntegerForKey:@"ItemId"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.text forKey:@"Text"];
    [aCoder encodeBool:self.checked forKey:@"Checked"];
    [aCoder encodeObject:self.dueDate forKey:@"DueDate"];
    [aCoder encodeBool:self.shouldRemind forKey:@"ShouldRemind"];
    [aCoder encodeInteger:self.itemId forKey:@"ItemId"];
}

- (void)dealloc{
    UILocalNotification *existingNotification = [self notificationForThisItem];
    if (existingNotification != nil) {
        [[UIApplication sharedApplication]cancelLocalNotification:existingNotification];
    }
}

@end
