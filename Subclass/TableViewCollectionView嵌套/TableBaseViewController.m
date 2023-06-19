//
//  TableBaseViewController.m
//  Subclass
//
//  Created by 韩倩云 on 2020/4/22.
//  Copyright © 2020 yy. All rights reserved.
//

#import "TableBaseViewController.h"

@interface TableBaseViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) UIScrollView * bgScrollView;


@end

@implementation TableBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return
    3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

@end
