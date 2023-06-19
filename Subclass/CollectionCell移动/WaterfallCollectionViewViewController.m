//
//  WaterfallCollectionViewViewController.m
//  Demo_CollectionCell移动
//
//  Created by 韩倩云 on 2018/11/12.
//  Copyright © 2018年 demo. All rights reserved.
//

#import "WaterfallCollectionViewViewController.h"
#import "WaterfallCollectionViewLayout.h"

@interface WaterfallCollectionViewViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,WaterfallCollectionViewLayoutDelegate>

@property (nonatomic, strong) WaterfallCollectionViewLayout * flowLayout;

@property (nonatomic, strong) UICollectionView * collectionView;

@property (nonatomic, strong) NSMutableArray * dataArr;

@end

@implementation WaterfallCollectionViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    self.title = @"脑壳疼🤦‍♀️";
    UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    [self.collectionView addGestureRecognizer:longPress];
}

#pragma mark ===selector===
- (void)longPress:(UILongPressGestureRecognizer *)longPress {
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan:{
            NSIndexPath * selectedIndexPath = [self.collectionView indexPathForItemAtPoint:[longPress locationInView:self.collectionView]];
            [self.collectionView beginInteractiveMovementForItemAtIndexPath:selectedIndexPath];
        }
            break;
        case UIGestureRecognizerStateChanged:
            [self.collectionView updateInteractiveMovementTargetPosition:[longPress locationInView:longPress.view]];
            break;
        case UIGestureRecognizerStateEnded:
            [self.collectionView endInteractiveMovement];
            break;
        default:
            [self.collectionView cancelInteractiveMovement];
            break;
    }
}

#pragma mark ===delegate===
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSString * itemHeight = self.dataArr[sourceIndexPath.item];
    [self.dataArr removeObjectAtIndex:sourceIndexPath.item];
    [self.dataArr insertObject:itemHeight atIndex:destinationIndexPath.item];
//    [self.collectionView moveItemAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
    self.flowLayout.contentHeight = 0;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"waterfallCell" forIndexPath:indexPath];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UILabel * label = [[UILabel alloc]initWithFrame:cell.bounds];
    label.text = self.dataArr[indexPath.item];
    [cell.contentView addSubview:label];
    label.textAlignment = NSTextAlignmentCenter;
    cell.backgroundColor = [UIColor yellowColor];
    return cell;
}

//- (void)moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
//    NSString * itemHeight = self.dataArr[sourceIndexPath.item];
//    [self.dataArr removeObjectAtIndex:sourceIndexPath.item];
//    [self.dataArr insertObject:itemHeight atIndex:destinationIndexPath.item];
//    [self.collectionView reloadData];
//}

#pragma mark ===懒载===
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        WaterfallCollectionViewLayout * flowLayout = [[WaterfallCollectionViewLayout alloc]init];
        flowLayout.edgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        flowLayout.columnCount = 2;
        flowLayout.columnMargin = 5;
        flowLayout.rowMargin = 5;
        flowLayout.attributesHeight = ^CGFloat(CGFloat itemWidth, NSIndexPath *indexPath) {
            return [self.dataArr[indexPath.item] floatValue];
        };
        flowLayout.delegate = self;
        self.flowLayout = flowLayout;
        self.collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:self.flowLayout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"waterfallCell"];
    }
    return _collectionView;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
        for (int i = 0; i < 10; i++) {
            [_dataArr addObject:[NSString stringWithFormat:@"%d",arc4random()%200+100]];
        }
    }
    return _dataArr;
}

@end
