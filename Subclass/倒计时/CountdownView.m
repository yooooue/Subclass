//
//  CountdownView.m
//  Subclass
//
//  Created by 韩倩云 on 2020/1/4.
//  Copyright © 2020 yy. All rights reserved.
//

#import "CountdownView.h"
#import "CardView.h"
@interface CountdownView ()

@property (nonatomic, strong) NSDate * countdownTime;

@property (nonatomic, strong) NSMutableArray * cardArr;

@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation CountdownView

- (instancetype)initWithFrame:(CGRect)frame countdownTime:(NSDate *)countdownTime {
    self = [super initWithFrame:frame];
    if (self) {
        self.countdownTime = countdownTime;
        [self initUI];
    }
    return self;
}

- (void)startCountDown {
//    __block NSInteger count = currentPage;
    dispatch_queue_t globalQueue = dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, globalQueue);
    
    //1.0*NSEC_PER_SEC,设置定时器触发的时间间隔为1s 0.0*NSEC_PER_SEC 时间允许的误差是0
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 1.0*NSEC_PER_SEC, 0.0*NSEC_PER_SEC);
    dispatch_source_set_event_handler(_timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self countDownAction];
        });
    });
    dispatch_resume(_timer);
}

-(void)countDownAction {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HHmmss"];
    NSString *currentDateStr = [dateFormatter stringFromDate:self.countdownTime];
    
    for (int i = 5; i>=0; i--) {
        if ([[currentDateStr substringWithRange:NSMakeRange(i, 1)] integerValue] > 0) {
            for (int j =5; j >= i; j --) {
                CardView *cardView = [self.cardArr objectAtIndex:j];
                [cardView startOnce];
            }
            break;
        }
    }
    double haveSeconds = self.countdownTime.timeIntervalSince1970 - 1;
    self.countdownTime = [NSDate dateWithTimeIntervalSince1970:haveSeconds];
}

-(NSInteger)p_NumberWithIndex:(NSInteger)index {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HHmmss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSString *currentDateStr = [dateFormatter stringFromDate:self.countdownTime];
    return [[currentDateStr substringWithRange:NSMakeRange(index,1)] integerValue];
}

- (void)initUI {
    self.cardArr = [[NSMutableArray alloc]initWithCapacity:6];
    CGFloat cardWidth = 26;
    CGFloat cardHeight = 38;
    CGFloat oneCardMargin = 1;
    CGFloat twoCardMargin = 13;
    CGFloat x=0,y=0;
    NSArray * cardNumberArr = @[@(10),@(10),@(6),@(10),@(6),@(10)];
    for (int i=0; i<6; i++) {
        CardView * cardView = [[CardView alloc]initWithFrame:CGRectMake(x, y, cardWidth, cardHeight) cardNumber:[cardNumberArr[i] integerValue] currentPage:[self p_NumberWithIndex:i]];
        [self addSubview:cardView];
        self.cardArr[i] = cardView;
        x = x+cardWidth+oneCardMargin;
        if (i%2 == 1) {
            if (i < 5) {
                UILabel *colonLabel = [[UILabel alloc]initWithFrame:CGRectMake(x+1, 6 , 10, 25)];
                colonLabel.text = @":";
                colonLabel.font = [UIFont systemFontOfSize:25];
                colonLabel.textColor = [UIColor blueColor];
                [self addSubview:colonLabel];
            }
            x = x+twoCardMargin;
        }
    }
}

@end
