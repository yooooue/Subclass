//
//  PrinterViewController.m
//  Subclass
//
//  Created by 韩倩云 on 2019/12/6.
//  Copyright © 2019 yy. All rights reserved.
//

#import "PrinterViewController.h"
#import "TicketTableViewCell.h"
#import "HeaderView.h"

@interface PrinterViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, strong) UIImageView * priterImg;

@property (nonatomic, strong) UIImageView * halfPriterImg;

@end

@implementation PrinterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
//    UIView * header = [[NSBundle mainBundle]loadNibNamed:@"HeaderView" owner:self options:nil].firstObject;
//    [self.view addSubview:header];
    [self.view addSubview:self.priterImg];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.halfPriterImg];
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-200, self.view.frame.size.width, 49)];
    [btn setTitle:@"打印" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor blackColor];
    [btn addTarget:self action:@selector(clictBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)clictBtn {
    self.count++;
    self.tableView.frame = CGRectMake(0, 62-80, self.view.frame.size.width, 80*self.count);
    [self.tableView reloadData];
    [UIView animateWithDuration:3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.tableView.frame = CGRectMake(0, 62, self.view.frame.size.width, 80*self.count);
        
    } completion:^(BOOL finished) {
        
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TicketTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ticketCellID"];
    if (!cell) {
        cell = [[TicketTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ticketCellID"];
    }
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 62, self.view.frame.size.width, 80*self.count) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"TicketTableViewCell" bundle:nil] forCellReuseIdentifier:@"ticketCellID"];
        _tableView.estimatedRowHeight = 100;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _tableView.scrollEnabled = NO;
//        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.001)];
//        view.backgroundColor = [UIColor redColor];
//        _tableView.tableHeaderView = view;
        _tableView.backgroundColor = [UIColor clearColor];
//        _tableView.tableHeaderView = [[NSBundle mainBundle]loadNibNamed:@"HeaderView" owner:self options:nil].firstObject;
    }
    return _tableView;
}

- (UIImageView *)priterImg {
    if (!_priterImg) {
        _priterImg = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-302)/2, 0, 302, 100)];
        _priterImg.image = [UIImage imageNamed:@"打印机"];
    }
    return _priterImg;
}

- (UIImageView *)halfPriterImg {
    if (!_halfPriterImg) {
        _halfPriterImg = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-302)/2, 0, 302, 50)];
        _halfPriterImg.image = [UIImage imageNamed:@"打印机"];
        _halfPriterImg.contentMode = UIViewContentModeTop;
        _halfPriterImg.clipsToBounds = YES;
    }
    return _halfPriterImg;
}
@end
