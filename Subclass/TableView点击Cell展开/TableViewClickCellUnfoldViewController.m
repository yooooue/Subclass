//
//  ClickCellUnfoldViewController.m
//  Subclass
//
//  Created by 韩倩云 on 2019/6/10.
//  Copyright © 2019 yy. All rights reserved.
//

#import "TableViewClickCellUnfoldViewController.h"
#import "NormalTableViewCell.h"
#import "UnfoldedTableViewCell.h"

@interface TableViewClickCellUnfoldViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSIndexPath * selectedIndex;

@property (nonatomic, assign) BOOL isOpen;

@end

@implementation TableViewClickCellUnfoldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedIndex.row == indexPath.row && self.selectedIndex != nil) {
        if (self.isOpen) {
            return 100;
        }
    }
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedIndex.row == indexPath.row && self.selectedIndex != nil) {
        if (self.isOpen) {
            UnfoldedTableViewCell * unfoldedCell = [tableView dequeueReusableCellWithIdentifier:@"UnfoldedCell" forIndexPath:indexPath];
            if (!unfoldedCell) {
                unfoldedCell = [[UnfoldedTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UnfoldedCell"];
            }
        unfoldedCell.titleLabel.text = @"已展开 点击折叠";
            return unfoldedCell;
        }
    }
    NormalTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"NormalCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[NormalTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NormalCell"];
    }
    cell.titleLabel.text = @"点击展开";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedIndex != nil) {
        self.isOpen = NO;
        [self.tableView reloadRowsAtIndexPaths:@[self.selectedIndex] withRowAnimation:UITableViewRowAnimationFade];
    }
    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
    
    if (self.selectedIndex == indexPath && self.isOpen) {
        self.selectedIndex = nil;
        self.isOpen = NO;
    }else {
        self.isOpen = YES;
        self.selectedIndex = indexPath;
    }
    
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"UnfoldedTableViewCell" bundle:nil] forCellReuseIdentifier:@"UnfoldedCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"NormalTableViewCell" bundle:nil] forCellReuseIdentifier:@"NormalCell"];
    }
    return _tableView;
}

@end
