//
//  SearchViewController.m
//  Subclass
//
//  Created by 韩倩云 on 2020/5/26.
//  Copyright © 2020 yy. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()<UISearchControllerDelegate, UISearchResultsUpdating, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic, strong) UISearchController * searchController;

@property (nonatomic, strong) NSMutableArray * dataArr;

@property (nonatomic, strong) NSMutableArray * results;

@property (nonatomic, strong) UITableView * tableView;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
//    UISearchBar * searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 88, self.view.frame.size.width, 44)];
//    searchBar.searchBarStyle = UISearchBarIconSearch;
//    [self.view addSubview:searchBar];
//    self.navigationController.navigationBarHidden = YES;
    [self.view addSubview:self.tableView];
}

#pragma mark ---UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.results.count;
}

#pragma mark ---UISearchBarDelegate---
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
}
- (UISearchController *)searchController {
    if (!_searchController) {
        _searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
        _searchController.delegate = self;
    }
    return _searchController;;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 88, self.view.frame.size.width, self.view.frame.size.height)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.searchController.searchBar;
    }
    return _tableView;;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (NSMutableArray *)results {
    if (!_results) {
        _results = [NSMutableArray array];
    }
    return _results;;
}
@end
