//
//  PreviewViewController.m
//  仿小红书裁剪
//
//  Created by 韩倩云 on 2019/8/26.
//  Copyright © 2019 yy. All rights reserved.
//

#import "PreviewViewController.h"
#import "PreviewCollectionViewCell.h"

@interface PreviewViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView * collectionView;

@property (nonatomic, copy) NSString * pageNumStr;

@end

@implementation PreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.collectionView];
    self.pageNumStr = [NSString stringWithFormat:@"%@/%lu",@"1",(unsigned long)self.photoArr.count];
}

- (void)setPageNumStr:(NSString *)pageNumStr {
    _pageNumStr = pageNumStr;
    self.title = pageNumStr;
}

#pragma mark ---collectionView delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photoArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PreviewCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"previewCellID" forIndexPath:indexPath];
    cell.photoImage.image = self.photoArr[indexPath.item];
    return cell;
}

#pragma mark ---懒载
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.width);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.width) collectionViewLayout:flowLayout];
        [_collectionView registerNib:[UINib nibWithNibName:@"PreviewCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"previewCellID"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
    }
    return _collectionView;
}

@end
