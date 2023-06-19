//
//  CountDownViewController.m
//  Subclass
//
//  Created by 韩倩云 on 2019/11/25.
//  Copyright © 2019 yy. All rights reserved.
//

#import "CountDownViewController.h"

@interface CountDownViewController ()

@property (nonatomic, strong) UILabel * label;

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, strong) CALayer * layer;

@end

@implementation CountDownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:self.label];
//    self.count = 9;
    
    CALayer * layer = [[CALayer alloc]init];
    layer.frame = CGRectMake(100, 100, 100, 60);
    layer.backgroundColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:layer];
    self.layer = layer;
    CGPoint anchorPoint = layer.anchorPoint;
    CGPoint position = layer.position;
    NSLog(@"初始anchorPoint:%f---%f/nposition:%f--%f",anchorPoint.x,anchorPoint.y,position.x,position.y);
    NSMutableArray * marr = [[NSMutableArray alloc]initWithCapacity:5];
    NSLog(@"%@",marr);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.layer.anchorPoint = CGPointMake(0.5, 1.0);
    CGPoint anchorPoint = self.layer.anchorPoint;
    CGPoint position = self.layer.position;
    self.layer.position = CGPointMake(position.x, position.y+30);
    NSLog(@"点击anchorPoint:%f---%f-----position:%f--%f",anchorPoint.x,anchorPoint.y,self.layer.position.x,self.layer.position.y);
}

- (void)setCount:(NSInteger)count {
    if (count < 0) return;
    
    _label.text = [NSString stringWithFormat:@"%ld",(long)count];
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, 50, 80)];
    label.text = [NSString stringWithFormat:@"%ld",(long)count];
    label.font = [UIFont boldSystemFontOfSize:50];
    label.backgroundColor = [UIColor grayColor];
    label.layer.doubleSided = NO;
    label.textColor = [UIColor whiteColor];
    [self.view addSubview:label];
    
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        label.alpha = 0;
        CATransform3D transform = CATransform3DIdentity;
        transform = CATransform3DMakeRotation(-M_PI_2, 1, 0, 0);
//        transform.m34 = - 1.0 / 500.0;
        label.layer.transform = transform;
    } completion:^(BOOL finished) {
        [label removeFromSuperview];
        [self setCount:count-1];
    }];
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, 50, 80)];
        _label.font = [UIFont boldSystemFontOfSize:50];
        _label.backgroundColor = [UIColor grayColor];
//        _label.textColor = [UIColor whiteColor];
        _label.layer.doubleSided = YES;
    }
    return _label;
}


@end
