//
//  LocalPushViewController.m
//  Subclass
//
//  Created by 韩倩云 on 2019/12/12.
//  Copyright © 2019 yy. All rights reserved.
//

#import "LocalPushViewController.h"

@interface LocalPushViewController ()

{
    UILabel * label;
}
@end

@implementation LocalPushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    UISwitch * switchBtn = [[UISwitch alloc]initWithFrame:CGRectMake(200, 200, 51, 31)];
//    switchBtn.transform = CGAffineTransformMakeScale(0.60, 0.60);
    [self.view addSubview:switchBtn];
    [switchBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventValueChanged];
    switchBtn.on = !([[UIApplication sharedApplication]currentUserNotificationSettings].types == UIUserNotificationTypeNone);
    label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(switchBtn.frame)-60, 200, 55, 31)];
    label.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
    label.text = @"打开推送";
    [self.view addSubview:label];
}

- (void)click:(UISwitch *)sw {
    NSURL *url =  [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
    }
    if (sw.on) {
        label.text = @"关闭推送";
        [self createLocalNotiftion];
    }else {
        label.text = @"打开推送";
        [[UIApplication sharedApplication]cancelAllLocalNotifications];
    }
}

- (void)createLocalNotiftion {
//    固定时间的本地推送
    NSDate * nowDate = [NSDate date];
    NSCalendar * calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents * components = [[NSDateComponents alloc]init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    components = [calendar components:unitFlags fromDate:nowDate];
    NSInteger hour = [components hour];
    NSInteger week = [components weekday];
    NSInteger min = [components minute];
    NSInteger sec = [components second];
    NSLog( @"现在是%ld: %ld: %ld, 周%ld",hour, min, sec, week);
    
    UILocalNotification * localNotif = [[UILocalNotification alloc]init];
//    设置时区 手机时区
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
//    通知内容
    localNotif.alertBody = @"整分签到提醒本地推送";
//    通知标题
    localNotif.alertTitle = @"签到提醒";
    localNotif.alertAction = @"打开";
//    右上角数字角标
    localNotif.applicationIconBadgeNumber = 0;
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"ss"];
    NSDate * date = [formatter dateFromString:@"00"];
    localNotif.fireDate = date;
//    [NSDate dateWithTimeIntervalSinceNow:10];
//    循环通知周期
    localNotif.repeatInterval = kCFCalendarUnitMinute;
//    设置userinfo 方便撤销
    localNotif.userInfo = [NSDictionary dictionaryWithObject:@"LoginIn" forKey:@"name"];
    [[UIApplication sharedApplication]scheduleLocalNotification:localNotif];
}

@end
