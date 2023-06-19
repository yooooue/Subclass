//
//  ImagePickerViewController.m
//  Subclass
//
//  Created by 韩倩云 on 2020/7/20.
//  Copyright © 2020 yy. All rights reserved.
//

#import "ImagePickerViewController.h"
#import "AssetCollectionViewCell.h"
#import "YPhotoAlbumModel.h"
#import "YPhotoManager.h"
#import "EditPhotosViewController.h"

@interface ImagePickerViewController ()

@end

@implementation ImagePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationBar.translucent = NO;
//    self.navigationBar.backgroundColor = [UIColor blackColor];//会有一层白色蒙住
    self.navigationBar.barTintColor = [UIColor colorWithWhite:0 alpha:0];
    self.navigationBar.tintColor = [UIColor whiteColor];
}

- (instancetype)initWithMaxImagesCount:(NSInteger)maxImagesCount columnNumber:(NSInteger)columnNumber delegate:(id<ImagePickerControllerDelegate>)delegate pushPhotoPickerVc:(BOOL)pushPhotoPickerVc {
    
    PhotoPickerViewController * photoPickerVC = [[PhotoPickerViewController alloc]init];
    photoPickerVC.columnNumber = 4;
    photoPickerVC.maxImgCount = maxImagesCount;
    self = [super initWithRootViewController:photoPickerVC];
    
    return self;
}

- (void)cancelBtnClick {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)nextBtnClick {
    
}
@end

@interface PhotoPickerViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray<YAssetModel *> * selectPhotoArr;

@property (nonatomic, strong) UICollectionView * collectionView;

@property (nonatomic, strong) UITableView * albumTableView;

@property (nonatomic, strong) NSArray<YAssetModel *> * assetModelArr;

@property (nonatomic, strong) NSArray <YPhotoAlbumModel *>* albumModelArr;

@property (nonatomic, strong) NSIndexPath * currentIndexPath;

@property (nonatomic, assign) BOOL isVideo;

@property (nonatomic, assign) BOOL isImage;

@end

@implementation PhotoPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    ImagePickerViewController * imagePickerVC = (ImagePickerViewController *)self.navigationController;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"closeBtn"] style:UIBarButtonItemStylePlain target:imagePickerVC action:@selector(cancelBtnClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextBtnClick)];
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
//    self.navigationItem.backBarButtonItem.tintColor = [UIColor blackColor];
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if(status == PHAuthorizationStatusAuthorized) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 用户点击 "OK"
                    [[YPhotoManager sharedManager] getAllAlbumsWithAscending:NO completion:^(NSArray<YPhotoAlbumModel *> * models) {
                        self.albumModelArr = models;
                        [self.albumTableView reloadData];
                    }];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
             // 用户点击 不允许访问
                    [self dismissViewControllerAnimated:YES completion:^{
                    }];
                });
            }
        }];
    }
    [[YPhotoManager sharedManager] getAllAlbumsWithAscending:NO completion:^(NSArray<YPhotoAlbumModel *> * models) {
        self.albumModelArr = models;
        [self.albumTableView reloadData];
    }];
    [self.view addSubview:self.collectionView];
}

- (void)setAssetModelArr:(NSArray<YAssetModel *> *)assetModelArr {
    _assetModelArr = assetModelArr;
    [self.collectionView reloadData];
}

- (void)setAlbumModelArr:(NSArray<YPhotoAlbumModel *> *)albumModelArr {
    _albumModelArr = albumModelArr;
    [self.albumTableView reloadData];
    YPhotoAlbumModel * firstAlbumModel = albumModelArr.firstObject;
    self.assetModelArr = firstAlbumModel.models;
    self.title = firstAlbumModel.albumName;
}

- (void)nextBtnClick {
    if (self.isVideo) {
        
    }else {
        EditPhotosViewController * editVC = [[EditPhotosViewController alloc]init];
        editVC.photoArr = self.selectPhotoArr;
        [self.navigationController pushViewController:editVC animated:YES];
    }
}

#pragma mark ---UICollectionViewDataSource Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assetModelArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AssetCollectionViewCell * assetCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AssetCell" forIndexPath:indexPath];
    assetCell.selectPhotoBlock = ^(BOOL isSelect) {
        [self collectionView:self.collectionView didSelectItemAtIndexPath:indexPath];
        [self addOrRemovePhotoFormArrWithIsSelect:isSelect indexPath:indexPath];
        
    };
    YAssetModel *assetModel = self.assetModelArr[indexPath.item];
    assetCell.assetModel = assetModel;
    assetCell.photoImgView.layer.borderWidth = indexPath==self.currentIndexPath?2:0;
    if (self.isImageOnly) {
        assetCell.unableClickCoverView.hidden = assetModel.assetModelMediaType == YAssetModelMediaTypeVideo?NO:YES;
        assetCell.userInteractionEnabled = assetCell.unableClickCoverView.hidden;
    }else {
        if (self.isVideo) {
            assetCell.unableClickCoverView.hidden = assetModel.assetModelMediaType == YAssetModelMediaTypeVideo?YES:NO;
            assetCell.userInteractionEnabled = assetCell.unableClickCoverView.hidden;
        }else if (self.isImage) {
            assetCell.unableClickCoverView.hidden = assetModel.assetModelMediaType == YAssetModelMediaTypeVideo?NO:YES;
            assetCell.userInteractionEnabled = assetCell.unableClickCoverView.hidden;
        }else {
            assetCell.unableClickCoverView.hidden = YES;
            assetCell.userInteractionEnabled = YES;
        }
    }
    if ([self.selectPhotoArr containsObject:assetModel]) {
        assetCell.selectIndex = [self.selectPhotoArr indexOfObject:assetModel];
    }else {
        assetCell.selectNumLabel.hidden = YES;
    }
    
    
    return assetCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath == self.currentIndexPath) return;
    if (self.currentIndexPath) {
        AssetCollectionViewCell * currentCell = (AssetCollectionViewCell *)[collectionView cellForItemAtIndexPath:self.currentIndexPath];
        currentCell.photoImgView.layer.borderWidth = 0;
    }
    AssetCollectionViewCell * cell = (AssetCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.photoImgView.layer.borderWidth = 2;
    self.currentIndexPath = indexPath;
}

- (void)addOrRemovePhotoFormArrWithIsSelect:(BOOL)isSelect indexPath:(NSIndexPath *)indexPath {
    YAssetModel * model = self.assetModelArr[indexPath.item];
    if (model.assetModelMediaType == YAssetModelMediaTypeVideo) {
        AssetCollectionViewCell * cell = (AssetCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        model.cropImage = cell.photoImgView.image;//视频取封面图
        if (![self.selectPhotoArr containsObject:model] && self.selectPhotoArr.count<1) {
            [self.selectPhotoArr addObject:model];
            model.isSelected = YES;
            self.isVideo = YES;
            self.isImage = NO;
        }else if ([self.selectPhotoArr containsObject:model]){
            [self.selectPhotoArr removeObject:model];
            model.isSelected = NO;
            self.isVideo = NO;
            self.isImage = NO;
        }else {
            UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:@"最多只能选择1个视频" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertView addAction:cancelAction];
            [self presentViewController:alertView animated:YES completion:nil];
            return;
        }
    }else {
        self.isVideo = NO;
        self.isImage = YES;
        if (![self.selectPhotoArr containsObject:model] && self.selectPhotoArr.count<self.maxImgCount) {
            [self.selectPhotoArr addObject:model];
            model.isSelected = YES;
        }else if ([self.selectPhotoArr containsObject:model]){
            [self.selectPhotoArr removeObject:model];
            model.isSelected = NO;
        }else {
            UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat: @"最多只能选择%ld张",(long)self.maxImgCount] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertView addAction:cancelAction];
            [self presentViewController:alertView animated:YES completion:nil];
            return;
        }
    }
    [self.collectionView reloadData];

}
#pragma mark ---懒载
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
        CGFloat margin = 1;
        CGFloat itemWH = (self.view.width-(self.columnNumber+1)*margin)/self.columnNumber;
        flowLayout.itemSize = CGSizeMake(itemWH, itemWH);
        flowLayout.minimumLineSpacing = margin;
        flowLayout.minimumInteritemSpacing = margin;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-44-STATUSBAR_HEIGHT) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
//        _collectionView.contentInset = UIEdgeInsetsMake(margin, margin, margin, margin);
        _collectionView.alwaysBounceHorizontal = NO;
        [_collectionView registerClass:[AssetCollectionViewCell class] forCellWithReuseIdentifier:@"AssetCell"];
    }
    return _collectionView;
}

- (NSMutableArray<YAssetModel *> *)selectPhotoArr {
    if (!_selectPhotoArr) {
        _selectPhotoArr = [NSMutableArray<YAssetModel *> array];
    }
    return _selectPhotoArr;
}
@end
