//
//  ScaleViewController.m
//  Subclass
//
//  Created by 韩倩云 on 2020/10/29.
//  Copyright © 2020 yy. All rights reserved.
//

#import "ScaleViewController.h"

@interface ScaleViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView * shareBottomView;

@end

@implementation ScaleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(share)];
    
    self.sTitle = @"sTitle";
    self.cTitle = @"cTitle";
    NSMutableString * mStr = [NSMutableString stringWithString:@"mutableString"];
    self.sTitle = mStr;
    self.cTitle = mStr;
    [mStr insertString:@"INSERT" atIndex:0];
    
    NSLog(@"sTitle%@-----cTitle%@",self.sTitle,self.cTitle);
}

- (void)share {
    [UIView animateWithDuration:0.35 animations:^{
        [self.navigationController.view.layer setTransform:[self firstTransform]];
        UIWindow * window = [[UIApplication sharedApplication] keyWindow];
        window.backgroundColor = [UIColor grayColor];
        [window addSubview:self.shareBottomView];
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.navigationController.view.transform = CGAffineTransformMakeScale(0.7, 0.75);
            self.shareBottomView.frame = CGRectMake(0, SCREEN_HEIGHT-200, SCREEN_WIDTH, 200);
        }];
    }];
}

- (void)clickView {
    [UIView animateWithDuration:0.35 animations:^{
        [self.navigationController.view.layer setTransform:[self secondTransform]];
        UIWindow * window = [[UIApplication sharedApplication] keyWindow];
        window.backgroundColor = [UIColor whiteColor];
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.navigationController.view.transform = CGAffineTransformMakeScale(1, 1);
            self.shareBottomView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 200);
        }];
    }];
}

- (CATransform3D)firstTransform {
    CATransform3D t1 = CATransform3DIdentity;
//    t1.m34 = 1.0/-900;
    t1 = CATransform3DScale(t1, 0.75, 0.75, 1);
//    t1 = CATransform3DRotate(t1, 15*M_PI/180.0, 1, 0, 0);
    return t1;
}


- (CATransform3D)secondTransform {
    CATransform3D t1 = CATransform3DIdentity;
//    t1.m34 = 1.0/-900;
    t1 = CATransform3DScale(t1, 1, 1, 1);
//    t1 = CATransform3DRotate(t1, 15*M_PI/180.0, 1, 0, 0);
    return t1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CellID" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellID"];
    }
    return cell;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CellID"];
    }
    return _tableView;
}

- (UIView *)shareBottomView {
    if (!_shareBottomView) {
        _shareBottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-200, SCREEN_WIDTH, 200)];
        _shareBottomView.backgroundColor = [UIColor redColor];
        [_shareBottomView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickView)]];
    }
    return _shareBottomView;
}
@end
