//
//  FoldCellViewController.m
//  Subclass
//
//  Created by 韩倩云 on 2019/12/4.
//  Copyright © 2019 yy. All rights reserved.
//

#import "FoldCellViewController.h"
#import "ReviewTableViewCell.h"

@interface FoldCellViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSMutableArray * foldArr;

@property (nonatomic, strong) NSArray * dataArr;

@end

@implementation FoldCellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.foldArr =[NSMutableArray arrayWithArray:  @[@true,@true,@true,@true,@true,@true]];
    self.dataArr = @[
  @[@"油皮推荐，非常好用的产品，买它买它买它！物美价廉就是他!非常服帖，已经安利给我身边的小姐妹们了，非常好用的产品，买它买它买它！非常服帖，已经安利给我身边的小姐妹们了，非常好用的产品，买它买它买它！油皮推荐，非常...",@"嘻嘻嘻嘻",@"一级棒",@"一点不好用啊",@"骗人精 你们都是演员吗",@"(⊙o⊙)…"],
                      @[@"油皮推荐，非常好用的产品，买它买它买它！物美价廉就是他!非常服帖，已经安利给我身边的小姐妹们了，非常好用的产品，买它买它买它！非常服帖，已经安利给我身边的小姐妹们了，非常好用的产品，买它买它买它！油皮推荐，非常...",@"嘻嘻嘻嘻",@"一级棒",@"骗人精 你们都是演员吗",@"(⊙o⊙)…"],
                     @[@"嘻嘻嘻嘻",@"骗人精 你们都是演员吗",@"(⊙o⊙)…",@"油皮推荐，非常好用的产品，买它买它买它！物美价廉就是他!非常服帖，已经安利给我身边的小姐妹们了，非常好用的产品，买它买它买它！非常服帖，已经安利给我身边的小姐妹们了，非常好用的产品，买它买它买它！油皮推荐，非常..."],
  @[@"很开心"]];
    [self.view addSubview:self.tableView];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ([self.foldArr[indexPath.section] boolValue]&&indexPath.row>1) ?0:UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return [self.dataArr[section] count]>2?50:CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArr[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        ReviewTableViewCell * reviewCell = [ReviewTableViewCell cellWithTableView:tableView];
        reviewCell.label.text = self.dataArr[indexPath.section][indexPath.row];
        return reviewCell;
    }else {
        WriteBackCommentTableViewCell * writeBackCell = [WriteBackCommentTableViewCell cellWithTableView:tableView];
        writeBackCell.label.text = self.dataArr[indexPath.section][indexPath.row];
        writeBackCell.clipsToBounds = YES;
        return writeBackCell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    NSArray * arr = self.dataArr[section];
    NSInteger count = arr.count-2;
    UIView * footerView = ({
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
        label.backgroundColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        label.text = [self.foldArr[section] boolValue] ?[NSString stringWithFormat:@"展开%ld条评论",count]:[NSString stringWithFormat:@"折叠%ld条评论",count];
        label.userInteractionEnabled = YES;
        label.tag = 100+section;
        label;
    });
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickSection:)];
    [footerView addGestureRecognizer:tap];
    return footerView;
}

- (void)clickSection:(UITapGestureRecognizer *)tap {
    int index = tap.view.tag % 100;
    
    NSMutableArray *indexArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < [self.dataArr[index] count]; i ++) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:index];
        [indexArray addObject:path];
    }
    _foldArr[index] = @(![_foldArr[index] boolValue]);
//    UITableViewRowAnimation type = [self.foldArr[index] boolValue] ?UITableViewRowAnimationBottom:UITableViewRowAnimationTop;
//    [_tableView reloadRowsAtIndexPaths:indexArray withRowAnimation: type];
    
//    NSRange range = NSMakeRange(index, 1);
//    NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
    [UIView performWithoutAnimation:^{
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationFade];
    }];
    
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"ReviewTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellID"];
        _tableView.estimatedRowHeight = 100;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.001)];
        view.backgroundColor = [UIColor redColor];
        _tableView.tableHeaderView = view;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

@end
