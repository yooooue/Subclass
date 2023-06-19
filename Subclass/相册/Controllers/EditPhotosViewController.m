//
//  EditPhotosViewController.m
//  Subclass
//
//  Created by 韩倩云 on 2020/7/22.
//  Copyright © 2020 yy. All rights reserved.
//

#import "EditPhotosViewController.h"
#import "ThumbnailCollectionViewCell.h"
#import "ClipViewController.h"

@interface EditPhotosViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView * thumbnailCollectionView;

@property (nonatomic, strong) UICollectionView * showCollectionView;

@property (nonatomic, strong) NSMutableArray * editPhotoArr;

@property (nonatomic, strong) NSIndexPath * currentIndex;

@property (nonatomic, strong) UIButton * clipBtn;

@property (nonatomic, strong) UIButton * filterBtn;

@end

@implementation EditPhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(clickNextBtn)];
    self.currentIndex = [NSIndexPath indexPathForItem:0 inSection:0];
    [self.view addSubview:self.thumbnailCollectionView];
    [self.view addSubview:self.showCollectionView];
    [self.view addSubview:self.clipBtn];
    [self.view addSubview:self.filterBtn];
}

- (void)clickNextBtn {
    
}

- (void)clickEditBtn:(UIButton *)btn {
    if (btn == self.clipBtn) {
        ClipViewController * clipVc = [[ClipViewController alloc]init];
        clipVc.assetModel = self.photoArr[self.currentIndex.item];
        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:clipVc];
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        nav.navigationBarHidden = YES;
        [self presentViewController:nav animated:YES completion:^{
            
        }];
        clipVc.clipImageBlock = ^(UIImage * _Nonnull image) {
            [self.showCollectionView reloadData];
        };
    }else {
        
    }
}

#pragma mark ---UICollectionViewDelegate & DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photoArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YAssetModel * assetModel = self.photoArr[indexPath.item];
    if (collectionView == self.thumbnailCollectionView) {
        ThumbnailCollectionViewCell * thumbnailCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ThumbnailCell" forIndexPath:indexPath];
        thumbnailCell.asssetModel = self.photoArr[indexPath.item];
        if (self.currentIndex == indexPath) {
            thumbnailCell.photoImage.layer.borderWidth = 2;
        }else {
            thumbnailCell.photoImage.layer.borderWidth = 0;
        }
//        thumbnailCell.photoImage.layer.borderWidth = self.currentIndex == indexPath?2:0;
        return thumbnailCell;;
    }else {
        
        ShowPhotoCollectionViewCell * showCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ShowPhotoCell" forIndexPath:indexPath];
//        if (assetModel.cropImage) {
//            showCell.photoImage.image = assetModel.cropImage;
//        }else {
            showCell.asssetModel = assetModel;
//        }
        return showCell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath == self.currentIndex) return;
    if (collectionView == self.thumbnailCollectionView) {
        if (self.currentIndex) {
            ThumbnailCollectionViewCell * currentCell = (ThumbnailCollectionViewCell *)[collectionView cellForItemAtIndexPath:self.currentIndex];
            currentCell.photoImage.layer.borderWidth = 0;
        }
        self.currentIndex = indexPath;
        [self.showCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
        [UIView performWithoutAnimation:^{
            [self.thumbnailCollectionView reloadItemsAtIndexPaths:@[indexPath]];
        }];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.showCollectionView) {
        if (self.currentIndex) {
            ThumbnailCollectionViewCell * currentCell = (ThumbnailCollectionViewCell *)[self.thumbnailCollectionView cellForItemAtIndexPath:self.currentIndex];
            currentCell.photoImage.layer.borderWidth = 0;
        }
        CGPoint offset = scrollView.contentOffset;
        NSInteger index = offset.x/self.view.width;
        self.currentIndex = [NSIndexPath indexPathForItem:index inSection:0];
        [UIView performWithoutAnimation:^{
            [self.thumbnailCollectionView reloadItemsAtIndexPaths:@[self.currentIndex]];
        }];
    }
}

- (UICollectionView *)thumbnailCollectionView {
    if (!_thumbnailCollectionView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(60, 60);
        flowLayout.minimumLineSpacing = 7;
        flowLayout.minimumInteritemSpacing = 7;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _thumbnailCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 84) collectionViewLayout:flowLayout];
        _thumbnailCollectionView.delegate = self;
        _thumbnailCollectionView.dataSource = self;
        [_thumbnailCollectionView registerClass:[ThumbnailCollectionViewCell class] forCellWithReuseIdentifier:@"ThumbnailCell"];
    }
    return _thumbnailCollectionView;
}

- (UICollectionView *)showCollectionView {
    if (!_showCollectionView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(self.view.width, self.view.height-self.thumbnailCollectionView.height-105-BOTTOM_SPACE-NAVBAR_HEIGHT);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _showCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.thumbnailCollectionView.frame), self.view.width, self.view.height-self.thumbnailCollectionView.height-105-NAVBAR_HEIGHT-BOTTOM_SPACE) collectionViewLayout:flowLayout];
        _showCollectionView.delegate = self;
        _showCollectionView.dataSource = self;
        _showCollectionView.pagingEnabled = YES;
        [_showCollectionView registerClass:[ShowPhotoCollectionViewCell class] forCellWithReuseIdentifier:@"ShowPhotoCell"];
    }
    return _showCollectionView;
}

- (NSMutableArray *)editPhotoArr {
    if (!_editPhotoArr) {
        _editPhotoArr = [NSMutableArray array];
    }
    return _editPhotoArr;
}

- (UIButton *)clipBtn {
    if (!_clipBtn) {
        _clipBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.width-100-30, self.view.height-50-35-BOTTOM_SPACE-NAVBAR_HEIGHT, 30, 50)];
        [_clipBtn setTitle:@"裁剪" forState:UIControlStateNormal];
        [_clipBtn setImage:[UIImage imageNamed:@"photo_clipImg"] forState:UIControlStateNormal];
        _clipBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_clipBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 2, 22, 2)];
        [_clipBtn setTitleEdgeInsets:UIEdgeInsetsMake(38, -26, 0, 0)];
        [_clipBtn addTarget:self action:@selector(clickEditBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clipBtn;
}

- (UIButton *)filterBtn {
    if (!_filterBtn) {
        _filterBtn = [[UIButton alloc]initWithFrame:CGRectMake(100, self.view.height-50-35-BOTTOM_SPACE-NAVBAR_HEIGHT, 30, 50)];
        NSLog(@"%lf",self.view.height);
        [_filterBtn setTitle:@"滤镜" forState:UIControlStateNormal];
        [_filterBtn setImage:[UIImage imageNamed:@"photo_filterImg"] forState:UIControlStateNormal];
        _filterBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_filterBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 2, 22, 2)];
        [_filterBtn setTitleEdgeInsets:UIEdgeInsetsMake(38, -26, 0, 0)];
        [_filterBtn addTarget:self action:@selector(clickEditBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _filterBtn;
}
@end
