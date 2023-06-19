//
//  WaterfallCollectionViewController.m
//  Subclass
//
//  Created by 韩倩云 on 2020/10/15.
//  Copyright © 2020 yy. All rights reserved.
//

#import "WaterfallCollectionViewController.h"
#import "WaterfallFlowLayout.h"
#import "Subclass-Swift.h"
#import "OUNavigationController.h"
@interface WaterfallCollectionViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView * collectionView;

@property (nonatomic, strong) WaterfallFlowLayout * waterfallFlowLayout;

@end

@implementation WaterfallCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    self.waterfallFlowLayout.contentHeight = 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 30;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256)/ 255.0 green:arc4random_uniform(256)/ 255.0 blue:arc4random_uniform(256)/ 255.0 alpha:1];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell * cell = [collectionView cellForItemAtIndexPath:indexPath];
    DetailViewController * vc = [[DetailViewController alloc]init];
    vc.cellColor = cell.backgroundColor;
    vc.ration = cell.height/cell.width;
    AnimationViewController * animNav = (AnimationViewController *)self.navigationController;
//    [animNav pustTest];
//    [animNav pushViewController:vc withImageView:[UIImageView new] desRect:CGRectMake(0, 0, 200, 300) delegate:vc];
    [animNav pushViewControllerWithViewController:vc imageView:cell origionRect:[collectionView convertRect:[collectionView convertRect:cell.frame toView:collectionView] toView:self.view] desRect:CGRectMake(0, NAVBAR_HEIGHT, SCREEN_WIDTH, SCREEN_WIDTH*cell.height/cell.width) delegate:vc];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        WaterfallFlowLayout * waterfallFlowLayout = [[WaterfallFlowLayout alloc]init];
        waterfallFlowLayout.columnCount = 2;
        waterfallFlowLayout.columnMargin = 10;
        waterfallFlowLayout.rowMargin = 10;
        waterfallFlowLayout.edgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        waterfallFlowLayout.attributesHeight = ^CGFloat(CGFloat itemWidth, NSIndexPath * _Nonnull indexPath) {
            return (arc4random()%100)+100;
        };
        _waterfallFlowLayout = waterfallFlowLayout;
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:waterfallFlowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellID"];
    }
    return _collectionView;
}
@end

