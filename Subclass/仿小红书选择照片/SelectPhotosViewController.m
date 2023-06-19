//
//  ViewController.m
//  仿小红书裁剪
//
//  Created by 韩倩云 on 2019/8/1.
//  Copyright © 2019 yy. All rights reserved.
//

#import "SelectPhotosViewController.h"
#import "YCollectionViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "YPhotoAlbumModel.h"
#import "YPhotoManager.h"
#import "YPhotoPreviewView.h"
#import "PreviewViewController.h"
#import "UIImage+CropImage.h"

#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define SCALEMAX 1.0 //放缩的最大值
#define WIDTHHEIGHTLIMETSCALE 3.0/4.0 //限制得到图片的 长宽比例

@interface SelectPhotosViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UICollectionView * collectionView;

@property (nonatomic, strong) NSMutableArray<YAssetModel *> * selectPhotoArr;

@property (nonatomic, strong) NSArray<YPhotoAlbumModel *> * photoAlbumArr;

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSArray<YAssetModel *> * dataSouce;

@property (nonatomic, strong) YPhotoPreviewView * showSelectPhotoImgView;

@property (nonatomic, strong) NSIndexPath * currentIndexPath;

@property (nonatomic, assign) CGSize orginSize;

@end

@implementation SelectPhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    [self.collectionView addSubview:self.showSelectPhotoImgView];
    [[YPhotoManager sharedManager] getAllAlbumsWithAscending:NO completion:^(NSArray<YPhotoAlbumModel *> * models) {
        self.photoAlbumArr = models;
        [self.tableView reloadData];
    }];
    [self.view addSubview:self.tableView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStyleDone target:self action:@selector(nextStep)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Show" style:UIBarButtonItemStyleDone target:self action:@selector(showAlbumList)];
    _orginSize = self.showSelectPhotoImgView.frame.size;
}

#pragma mark ---selector
- (void)showAlbumList {
    self.tableView.hidden = NO;
}

- (void)nextStep {
    //点击下一步的时候 保存当前model的截图
    [self.showSelectPhotoImgView saveCropImgforModel];
    if (self.selectPhotoArr.count == 0) return;
    NSMutableArray * imgArr = [NSMutableArray array];
    for (YAssetModel * assetModel in self.selectPhotoArr) {
        [imgArr addObject:assetModel.cropImage];
    }
    if (imgArr.count == 0) return;
    PreviewViewController * vc = [[PreviewViewController alloc]init];
    vc.photoArr = imgArr;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addOrRemovePhotoFormArrWithIsSelect:(BOOL)isSelect indexPath:(NSIndexPath *)indexPath {
    YAssetModel * firstModel = self.selectPhotoArr.firstObject;
    
    YAssetModel * model = self.dataSouce[indexPath.item];
    if (![self.selectPhotoArr containsObject:model] && self.selectPhotoArr.count<9) {
        [self.selectPhotoArr addObject:model];
        model.isSelected = YES;
    }else if ([self.selectPhotoArr containsObject:model]){
        [self.selectPhotoArr removeObject:model];
        model.isSelected = NO;
    }else {
        UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:@"最多只能选择9张" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertView addAction:cancelAction];
        [self presentViewController:alertView animated:YES completion:nil];
        return;
    }
    if (firstModel == model || !firstModel) {//操作的是第一个model 改变preview.type
        if (self.selectPhotoArr.count == 0) {
            firstModel = nil;
        } else {
            firstModel = self.selectPhotoArr.firstObject;
        }
        if (firstModel) {
            self.showSelectPhotoImgView.type = firstModel.type;
            self.showSelectPhotoImgView.hasSelected = YES;
        }else {
            self.showSelectPhotoImgView.type = 0;
            self.showSelectPhotoImgView.hasSelected = NO;
        }
    }
    [self.collectionView reloadData];
}

#pragma mark ---tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.photoAlbumArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YAlbumTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[YAlbumTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"tableViewCell"];
    }
    YPhotoAlbumModel * album = self.photoAlbumArr[indexPath.row];
    cell.model = album;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YPhotoAlbumModel * album = self.photoAlbumArr[indexPath.row];
    _dataSouce = album.models;
    [self.collectionView reloadData];
    self.tableView.hidden = YES;
    self.title = album.albumName;
}

#pragma mark ---collection delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSouce.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    cell.selectPhotoBlock = ^(BOOL isSelect) {
//        self.currentIndexPath = indexPath;
        [self addOrRemovePhotoFormArrWithIsSelect:isSelect indexPath:indexPath];
        [self collectionView:self.collectionView didSelectItemAtIndexPath:indexPath];
    };
    YAssetModel *assetModel = _dataSouce[indexPath.row];
    cell.model = assetModel;
    cell.photoImgView.layer.borderWidth = indexPath==self.currentIndexPath?2:0;
    
    if ([self.selectPhotoArr containsObject:assetModel]) {
        cell.selectedIndex = [self.selectPhotoArr indexOfObject:assetModel];
    }else {
        cell.selectNumLabel.hidden = YES;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath == self.currentIndexPath) {
        return;
    }
    //选择新的model之前 保存上一个model的截图
    [self.showSelectPhotoImgView saveCropImgforModel];
    YAssetModel *assetModel = _dataSouce[indexPath.row];
    self.showSelectPhotoImgView.model = assetModel;
    if (self.currentIndexPath) {
        YCollectionViewCell * currentCell = (YCollectionViewCell *)[collectionView cellForItemAtIndexPath:self.currentIndexPath];
        currentCell.photoImgView.layer.borderWidth = 0;
    }
    
    YCollectionViewCell * cell = (YCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.photoImgView.layer.borderWidth = 2;
    self.currentIndexPath = indexPath;
    [UIView performWithoutAnimation:^{
        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    }];
}

#pragma mark ---lazy loadi
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [_tableView registerClass:[YAlbumTableViewCell class] forCellReuseIdentifier:@"tableViewCell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
        CGFloat itemWidth = (self.view.frame.size.width-3*5-2*4)/4;
        flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth);
        flowLayout.minimumLineSpacing = 4;
        flowLayout.minimumInteritemSpacing = 5;
        flowLayout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.width);
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        _collectionView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerNib:[UINib nibWithNibName:@"YCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PhotoCell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (YPhotoPreviewView *)showSelectPhotoImgView {
    if (!_showSelectPhotoImgView) {
        _showSelectPhotoImgView = [[YPhotoPreviewView alloc]initWithFrame:CGRectMake(-4, -4, self.view.frame.size.width, self.view.frame.size.width)];
        _showSelectPhotoImgView.backgroundColor = [UIColor lightGrayColor];
        _showSelectPhotoImgView.contentMode = UIViewContentModeScaleAspectFill;
        _showSelectPhotoImgView.clipsToBounds = YES;
    }
    return _showSelectPhotoImgView;
}

- (NSMutableArray<YAssetModel *> *)selectPhotoArr {
    if (!_selectPhotoArr) {
        _selectPhotoArr = [NSMutableArray<YAssetModel *> array];
    }
    return _selectPhotoArr;
}
@end
