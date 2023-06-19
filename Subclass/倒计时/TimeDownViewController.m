//
//  TimeDownViewController.m
//  Subclass
//
//  Created by 韩倩云 on 2020/1/4.
//  Copyright © 2020 yy. All rights reserved.
//

#import "TimeDownViewController.h"
#import "CountdownView.h"

@interface TimeDownViewController ()

@property (nonatomic, strong) UILabel * label;

@property (nonatomic, strong) CountdownView * countdownView;

@property (nonatomic, strong) NSDate * countdownTime;

@end

@implementation TimeDownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self time];
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height*2);
    [self.view addSubview:scrollView];
    [scrollView addSubview:self.label];
    [scrollView addSubview:self.countdownView];
}

- (void)time {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:self.timeStr];
    NSDate *nowDate = [NSDate date];
    //获取目标时间与当前时间的时间差
    __block float value = [date timeIntervalSinceDate:nowDate];
    
    dispatch_queue_t globalQueue = dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, globalQueue);
    
    //1.0*NSEC_PER_SEC,设置定时器触发的时间间隔为1s 0.0*NSEC_PER_SEC 时间允许的误差是0
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0*NSEC_PER_SEC, 0.0*NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        value--;
        if (value<=0) {
            dispatch_source_cancel(timer);
        }
        int hours = value/(60*60);//小时
        int minutes = (value-hours*60*60)/60;
        int seconds = value-hours*60*60-minutes*60;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.label.text = [NSString stringWithFormat:@"%02d:%02d:%02d",hours,minutes,seconds];
        });
    });
    dispatch_resume(timer);
    
    self.countdownTime = [NSDate dateWithTimeIntervalSince1970:value];
    [self.countdownView startCountDown];
}

- (NSString *)labelTextWithTimeStr:(NSString *)timeStr {
    //计算现在到这个时间的时长
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:timeStr];
    NSDate *nowDate = [NSDate date];
    //获取目标时间与当前时间的时间差
    float value = [date timeIntervalSinceDate:nowDate];
    if (value >= 60 * 60 * 24) {
        // 大于一天
        int dayValue = value/86400;
        return [NSString stringWithFormat:@"%d天",dayValue];
    }else {
        int hours = value/(60*60);//小时
        int minutes = (value-hours*60*60)/60;
        int seconds = value-hours*60*60-minutes*60;
        return [NSString stringWithFormat:@"%02d:%02d:%02d",hours,minutes,seconds];
    }
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(50, 100, self.view.frame.size.width-100, 50)];
        _label.backgroundColor = [UIColor redColor];
        _label.text = [self labelTextWithTimeStr:self.timeStr];
        [_label setAdjustsFontSizeToFitWidth:YES];
    }
    return _label;
}

- (CountdownView *)countdownView {
    if (!_countdownView) {
        _countdownView = [[CountdownView alloc]initWithFrame:CGRectMake(50, 300, self.view.frame.size.width-100, 50)countdownTime:self.countdownTime];
        _countdownView.backgroundColor = [UIColor yellowColor];
        [_countdownView startCountDown];
    }
    return _countdownView;
}

@end
