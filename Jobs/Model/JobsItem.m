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

@interface JobsItem () <NSCoding, NSCopying>
@end
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

- (void)scheduleNotification:(NSString *)companyName{
    UILocalNotification *exitingNotification = [self notificationForThisItem];
    if (exitingNotification != nil) {
        [[UIApplication sharedApplication]cancelLocalNotification:exitingNotification];
    }
    if (self.shouldRemind && [self.dueDate compare:[NSDate date]]!=NSOrderedAscending) {
        UILocalNotification *localNotification = [[UILocalNotification alloc]init];
        localNotification.fireDate = self.dueDate;
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        NSString *string = [companyName stringByAppendingString:self.text];
        NSString *string2 = [string stringByAppendingString:@" 即将 "];
        localNotification.alertBody =[string2 stringByAppendingString:self.nextTask];
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



#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if( (self = [super init]) ) {
        self.text = [aDecoder decodeObjectForKey:@"Text"];
        self.nextTask = [aDecoder decodeObjectForKey:@"NextTask"];
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
    [aCoder encodeObject:self.nextTask forKey:@"NextTask"];
    [aCoder encodeBool:self.checked forKey:@"Checked"];
    [aCoder encodeObject:self.dueDate forKey:@"DueDate"];
    [aCoder encodeBool:self.shouldRemind forKey:@"ShouldRemind"];
    [aCoder encodeInteger:self.itemId forKey:@"ItemId"];
}



#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    JobsItem *copyJobsItem = [[JobsItem alloc] init];
    copyJobsItem.text = self.text;
    copyJobsItem.nextTask = self.nextTask;
    copyJobsItem.checked = self.checked;
    copyJobsItem.dueDate = self.dueDate;
    copyJobsItem.shouldRemind = self.shouldRemind;
    copyJobsItem.itemId = self.itemId;
    return copyJobsItem;
}

@end
