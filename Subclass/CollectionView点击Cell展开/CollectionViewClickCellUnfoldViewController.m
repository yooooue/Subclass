//
//  CollectionViewClickCellUnfoldViewController.m
//  Subclass
//
//  Created by 韩倩云 on 2019/6/10.
//  Copyright © 2019 yy. All rights reserved.
//

#import "CollectionViewClickCellUnfoldViewController.h"
#import "NormalCollectionViewCell.h"
#import "UnfoldedCollectionViewCell.h"

@interface CollectionViewClickCellUnfoldViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView * collectionView;

@property (nonatomic, assign) BOOL isOpen;

@property (nonatomic, strong) NSIndexPath * selectedIndex;

@end

@implementation CollectionViewClickCellUnfoldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedIndex == indexPath && self.selectedIndex != nil) {
        if (self.isOpen) {
            return CGSizeMake(100, 50);
        }
    }
    return CGSizeMake(50, 50);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedIndex == indexPath) {
        if (self.isOpen) {
            UnfoldedCollectionViewCell * unfolderCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UnfoldedCell" forIndexPath:indexPath];
            return unfolderCell;
        }
    }
    NormalCollectionViewCell * normalCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NormalCell" forIndexPath:indexPath];
    return normalCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedIndex != nil) {
        self.isOpen = NO;
        [UIView performWithoutAnimation:^{
            [self.collectionView reloadItemsAtIndexPaths:@[self.selectedIndex]];
        }];
//        [self.collectionView reloadRowsAtIndexPaths:@[self.selectedIndex] withRowAnimation:UITableViewRowAnimationFade];
//        [self.collectionView reloadItemsAtIndexPaths:@[self.selectedIndex]];
    }
    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
    
    if (self.selectedIndex == indexPath && self.isOpen) {
        self.selectedIndex = nil;
        self.isOpen = NO;
    }else {
        self.isOpen = YES;
        self.selectedIndex = indexPath;
    }
    
    [UIView performWithoutAnimation:^{
        [self.collectionView reloadItemsAtIndexPaths:indexPaths];
    }];

//    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    [self scrollCollectionWithIndex:indexPath];
}

- (void)scrollCollectionWithIndex:(NSIndexPath *)indexPath {
    NSArray * arr = [self.collectionView indexPathsForVisibleItems];
    NSLog(@"%@",arr);
    NSArray * arr2 = [arr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSIndexPath *path1 = (NSIndexPath *)obj1;
        NSIndexPath *path2 = (NSIndexPath *)obj2;
        return [path1 compare:path2];
    } ];
    NSLog(@"%@",arr2);
    
    NSIndexPath * visibleLastIndex = arr2.lastObject;
    NSIndexPath * visibleFirstIndex = arr2.firstObject;
    if (arr.count <= 2) {
        return;
    }
    
    if ((visibleLastIndex.item-1 == indexPath.item && visibleLastIndex.item ) || (visibleLastIndex == indexPath)) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:indexPath.item-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    }
    if ((visibleFirstIndex == indexPath) || (visibleFirstIndex.item+1 == indexPath.item )) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:indexPath.item+1 inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
    }
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(50, 50);
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 70) collectionViewLayout:flowLayout];
        _collectionView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerNib:[UINib nibWithNibName:@"NormalCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"NormalCell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"UnfoldedCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"UnfoldedCell"];
        _collectionView.backgroundColor = [UIColor redColor];
    }
    return _collectionView;
}

@end
