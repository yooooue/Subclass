//
//  NorCollectionViewController.m
//  Demo_CollectionCell移动
//
//  Created by 韩倩云 on 2018/11/12.
//  Copyright © 2018年 demo. All rights reserved.
//

#import "NorCollectionViewController.h"

@interface NorCollectionViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView * collectionView;

@property (nonatomic, strong) UILongPressGestureRecognizer * longPress;

@property (nonatomic, strong) NSMutableArray * dataArr;


@end

@implementation NorCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"普普通通的";
    [self.view addSubview:self.collectionView];
    UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    [self.collectionView addGestureRecognizer:longPress];
    self.longPress = longPress;
}

- (void)longPress:(UILongPressGestureRecognizer *)longPress {
    
    
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan:
        {
            CGPoint point = [longPress locationInView:self.collectionView];
            NSIndexPath * selectedIndexPatch = [self.collectionView indexPathForItemAtPoint:point];
            if (selectedIndexPatch == nil) {
                break;
            }
            UICollectionViewCell * cell = [self.collectionView cellForItemAtIndexPath:selectedIndexPatch];
            cell.backgroundColor = [UIColor redColor];
            [_collectionView beginInteractiveMovementForItemAtIndexPath:selectedIndexPatch];
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor yellowColor];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UILabel * label = [[UILabel alloc]initWithFrame:cell.bounds];
    label.text = self.dataArr[indexPath.item];
    label.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:label];
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    //    实现这个方法 才能做到cell的移动重排
    //    这个方法啊 是手松开才调用 如果cell没有交换位置 则不会被调用
    //    sourceIndexPath 被操作的的item初始的index
    //    destinationIndexPath 被操作的的item最终的的index
    NSLog(@"%ld---%ld",(long)sourceIndexPath.item,(long)destinationIndexPath.item);
    //将元素插入到最终位置
    NSString * item = self.dataArr[sourceIndexPath.item];
    [self.dataArr removeObjectAtIndex:sourceIndexPath.item];
    [self.dataArr insertObject:item atIndex:destinationIndexPath.item];
    //交换元素
//    [self.dataArr exchangeObjectAtIndex:sourceIndexPath.item withObjectAtIndex:destinationIndexPath.item];
//    [self.collectionView reloadData];
//    [UIView performWithoutAnimation:^{
//        [collectionView reloadItemsAtIndexPaths:@[sourceIndexPath,destinationIndexPath]];
//    }];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
//        CGFloat width = (self.view.frame.size.width - 30)/2;
        layout.itemSize = CGSizeMake(50, 50);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[UICollectionViewCell class]
            forCellWithReuseIdentifier:@"cellID"];
        _collectionView.backgroundColor = [UIColor lightGrayColor];
    }
    return _collectionView;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
        for (NSInteger i = 1; i <= 100; i++) {
            [_dataArr addObject:[NSString stringWithFormat:@"%ld",(long)i]];
        }
    }
    return _dataArr;
}

@end
