//
//  CustomMirrorCollectionView.m
//  MUD004
//
//  Created by 韩倩云 on 2019/6/12.
//  Copyright © 2019 MACCO. All rights reserved.
//

#import "CustomMirrorCollectionView.h"
//#import "MirrorMeiDaCollectionViewCell.h"
//#import "HomePageBannerPageView.h"
//#import "MirrorPageModel.h"
//#import "MakeupPagedModel.h"
//#import "MirrorMakeupModel.h"
//#import "ProForMakeupCollectionViewCell.h"
//#import "PhotosCollectionViewCell.h"
//#import "PhotoWallPageModel.h"
#import "ActivityCollectionViewFlowLayout.h"
//#import "MirrorCategoryCollectionViewCell.h"
//#import "MakeupCategoryModel.h"

@interface CustomMirrorCollectionView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView * collectionView;

@property (nonatomic, strong) ActivityCollectionViewFlowLayout * flowLayout;

@property (nonatomic, strong) UILabel * titleLabel;

@property (nonatomic, strong) UIButton * moreBtn;

@property (nonatomic, strong) NSMutableArray * dataArr;

//@property (nonatomic, strong) HomePageBannerPageView * pageView;

@end

@implementation CustomMirrorCollectionView

- (instancetype)initWithFrame:(CGRect)frame withCellName:(NSString *)cellName {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.cellName = cellName;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self addSubview:self.titleLabel];
    [self addSubview:self.collectionView];
    [self addSubview:self.moreBtn];
//    [self addSubview:self.pageView];
    UIImageView * img = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame)-2, 10, 28, 15)];
    img.image = [UIImage imageNamed:@"mirror_AR"];
    if (self.collectionStyle == CustomCollectionViewStyleCategory) [self addSubview:img];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setItemSize:(CGSize)itemSize {
    _itemSize = itemSize;
    self.flowLayout.itemSize = itemSize;
}

- (void)setLineSpacing:(CGFloat)lineSpacing {
    _lineSpacing = lineSpacing;
    self.flowLayout.minimumLineSpacing = lineSpacing;
}

- (void)setInteritemSpacing:(CGFloat)interitemSpacing {
    _interitemSpacing = interitemSpacing;
    self.flowLayout.minimumInteritemSpacing = interitemSpacing;
}

- (void)setContentInset:(UIEdgeInsets)contentInset {
    self.collectionView.contentInset = contentInset;
    self.flowLayout.offset = (SCREEN_WIDTH-self.itemSize.width)/2-contentInset.left;
}

- (void)setCollectionViewColor:(UIColor *)collectionViewColor {
    _collectionViewColor = collectionViewColor;
    self.collectionView.backgroundColor = collectionViewColor;
}

- (void)setIsHidMoreBtn:(BOOL)isHidMoreBtn {
    _isHidMoreBtn = isHidMoreBtn;
    self.moreBtn.hidden = isHidMoreBtn;
}

- (void)setIsShowPageView:(BOOL)isShowPageView {
    _isShowPageView = isShowPageView;
//    self.pageView.hidden = !isShowPageView;
}

//- (void)setDataArrWithoutNetwork:(NSArray<MirrorProductionModel *> *)dataArr {
//    [self.dataArr removeAllObjects];
//    [self.dataArr addObjectsFromArray:dataArr];
//    if ([self.dataArr.firstObject isKindOfClass:[NSDictionary class]]) {
//        NSLog(@"错了");
//    }
//    [self.collectionView reloadData];
//}

//- (void)setUrl:(NSString *)url andParamDic:(NSDictionary *)dic {
//    [self getDataWithStyle:self.collectionStyle andLinkUrl:url andParamDic:dic];
//}

//- (void)getDataWithStyle:(CustomCollectionViewStyle)style andLinkUrl:(NSString *)url andParamDic:(NSDictionary *)dic {
//    switch (style) {
//        case CustomCollectionViewStyleBrand:
//            [self getBrandDataWithUrl:url andParamDic:dic];
//            break;
//        case CustomCollectionViewStyleMeiDa://主题试妆
//            [self getMeiDaData];
//            break;
//        case CustomCollectionViewStylePhotos:
//            [self getPhotosDataWithUrl:url andParamDic:dic];
//            break;
//        case CustomCollectionViewStyleCategory:
//            [self getCategoryModelData];
//            break;
//        default:
//            break;
//    }
//}
//
//- (void)getProDataWithUrl:(NSString *)url andParamDic:(NSDictionary *)dic {
//    MirrorPageModel * pageModel = [[MirrorPageModel alloc]init];
//    pageModel.successBlock = ^(id obj) {
//        [self.dataArr addObjectsFromArray:obj];
//        if ([self.dataArr.firstObject isKindOfClass:[NSDictionary class]]) {
//            NSLog(@"错了");
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.collectionView reloadData];
//        });
//    };
//    pageModel.failBlock = ^(id obj) {
//
//    };
//    [pageModel getMirrorNewProsListWithUrl:url andParamDic:dic];
//}

//- (void)getBrandDataWithUrl:(NSString *)url andParamDic:(NSDictionary *)dic {
//    MirrorPageModel * pageModel = [[MirrorPageModel alloc]init];
//    pageModel.successBlock = ^(id obj) {
//        [self.dataArr addObjectsFromArray:obj];
//        if ([self.dataArr.firstObject isKindOfClass:[NSDictionary class]]) {
//            NSLog(@"错了");
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.collectionView reloadData];
//        });
//    };
//    pageModel.failBlock = ^(id obj) {
//
//    };
//    [pageModel getMirrorBrandListWithUrl:url andParamDic:dic];
//}

//- (void)getMeiDaData {
//    //根据需求，这里魔镜主题试装最多显示8个
////    NSInteger count = UserInfoManager.shareInstance.makeupModelArr.count;
////    NSInteger index = 0;
////
////    while (index < count && index < 8) {
////        [self.dataArr addObject:UserInfoManager.shareInstance.makeupModelArr[index]];
////        if ([self.dataArr.firstObject isKindOfClass:[NSDictionary class]]) {
////            NSLog(@"错了");
////        }
////        index ++;
////    }
//    self.dataArr = [UserInfoManager.shareInstance getMakeupHomeList];
//    if (self.dataArr.count > 0) {
//        DLog(@"----数据好了，注销整妆列表通知 ");
//        [[NSNotificationCenter defaultCenter] removeObserver:self name: kMakeupHomeList object:nil];
//        [self.collectionView reloadData];
//
//    }else {
//        DLog(@"----数据还没好，注册整妆列表通知");
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMeiDaData) name:kMakeupHomeList object:nil];
//    }
//}

//- (void)getPhotosDataWithUrl:(NSString *)url andParamDic:(NSDictionary *)dic {
//    PhotoWallPageModel * pageModel = [[PhotoWallPageModel alloc]init];
//    pageModel.successBlock = ^(id obj) {
//        [self.dataArr addObjectsFromArray:obj];
//        if ([self.dataArr.firstObject isKindOfClass:[NSDictionary class]]) {
//            NSLog(@"错了");
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.collectionView reloadData];
//        });
//        if (self.dataArr.count==0) {
//            [self removeFromSuperview];
//        }
//    };
//    pageModel.failBlock = ^(id obj) {
//        [self removeFromSuperview];
//    };
//    [pageModel getPhotosWithMakeupDic:dic Url:url];
//}

//- (void)getCategoryModelData {
//    CategoryModel * makeupModel = [[CategoryModel alloc]init];
//    makeupModel.cateName = @"Overall";
//    makeupModel.cateID = @"0";
//    [self.dataArr addObject:makeupModel];
//    MirrorPageModel * pageModel = [[MirrorPageModel alloc]init];
//    pageModel.successBlock = ^(id obj) {
//        [self.dataArr addObjectsFromArray:obj];
//        if ([self.dataArr.firstObject isKindOfClass:[NSDictionary class]]) {
//            NSLog(@"错了");
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.collectionView reloadData];
//        });
//    };
//    pageModel.failBlock = ^(id obj) {
//
//    };
//    [pageModel getMakeupCategoryListWithBrandNO:nil];
//}
#pragma mark ---UICollectionView DataSource---
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 7;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    Class myClass = NSClassFromString(self.cellName);
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor blueColor];
//    id dataModel = self.dataArr[indexPath.item];
//    switch (self.collectionStyle) {
////        case CustomCollectionViewStyleMeiDa:
////        {
////            MirrorMeiDaCollectionViewCell * meiDaCell = (MirrorMeiDaCollectionViewCell *)cell;
////            [meiDaCell setCellWithModel:dataModel at:indexPath.item];
////        }
////            break;
////        case CustomCollectionViewStylePhotos:
////        {
////            PhotosCollectionViewCell * photoCell = (PhotosCollectionViewCell *)cell;
////            [photoCell setCellWithModel:dataModel indeXPath:indexPath];
////        }
////            break;
////        case CustomCollectionViewStyleMakeupPro:
////        {
////            ProForMakeupCollectionViewCell * mkProCell = (ProForMakeupCollectionViewCell *)cell;
////            [mkProCell setCellWithModel:dataModel];
////        }
////            break;
//        case CustomCollectionViewStyleCategory:
//        {
//            MirrorCategoryCollectionViewCell * cateCell = (MirrorCategoryCollectionViewCell *)cell;
//            [cateCell setCellWithModel:dataModel];
//        }
//            break;
//        default:
//            break;
//    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    id dataModel = self.dataArr[indexPath.item];
//    if (self.delegate && [self.delegate respondsToSelector:@selector(clickCellWithStyle:andDataModel:)]) {
//        [self.delegate clickCellWithStyle:self.collectionStyle andDataModel:dataModel];
//    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.isShowPageView) {
        NSArray * arr = [self.collectionView indexPathsForVisibleItems];
        NSArray * arr2 = [arr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            NSIndexPath *path1 = (NSIndexPath *)obj1;
            NSIndexPath *path2 = (NSIndexPath *)obj2;
            return [path1 compare:path2];
        } ];
        NSIndexPath * currentIndexPath = arr2.lastObject;
        NSInteger index;
        if (currentIndexPath.item == self.dataArr.count-1 && arr2.count == 2) {
            index = currentIndexPath.item;
        }else {
            index = currentIndexPath.item-1;
        }
//        [self.pageView updataLayoutPageViewWithCurrentPage:index];
    }
}

#pragma mark ---Selector---
- (void)clickMoreBtn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickMoreBtnWithStyle:)]) {
        [self.delegate clickMoreBtnWithStyle:self.collectionStyle];
    }
}

#pragma mark ---懒载---
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        ActivityCollectionViewFlowLayout * flowLayout = [[ActivityCollectionViewFlowLayout alloc]init];
        flowLayout.offset = (self.width-self.itemSize.width)/2-self.contentInset.left;
        flowLayout.itemSize = self.itemSize;
        flowLayout.minimumLineSpacing = self.lineSpacing;
        flowLayout.minimumInteritemSpacing = floor(self.interitemSpacing);
        flowLayout.scrollDirection = self.collectionStyle==CustomCollectionViewStyleCategory?UICollectionViewScrollDirectionVertical:UICollectionViewScrollDirectionHorizontal;
        self.flowLayout = flowLayout;
        CGFloat y = 15;
        if (self.collectionStyle == CustomCollectionViewStyleCategory) {
            y = 9;
        }else if (self.collectionStyle == CustomCollectionViewStyleMeiDa) {
            y = 5;
        }
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleLabel.frame)+y, self.frame.size.width, self.frame.size.height-CGRectGetMaxY(_titleLabel.frame)-15) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellID"];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.bounces = NO;
        _collectionView.scrollEnabled = self.collectionStyle!=CustomCollectionViewStyleCategory;
    }
    return _collectionView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.collectionStyle==CustomCollectionViewStyleMeiDa||self.collectionStyle==CustomCollectionViewStyleMakeupPro)?24:20, 12, 100, 17)];
        _titleLabel.text = self.title;
        _titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
        _titleLabel.textColor = [UIColor colorWithHexStr:@"#46464b"];
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

- (UIButton *)moreBtn {
    if (!_moreBtn) {
        _moreBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-10-40, 12, 40, 17)];
        [_moreBtn setTitle:@"更多" forState:UIControlStateNormal];
        [_moreBtn setTitleEdgeInsets:UIEdgeInsetsMake(2, -25, 0, 0)];
        [_moreBtn setImage:[UIImage imageNamed:@"详情"] forState:UIControlStateNormal];
        [_moreBtn setImageEdgeInsets:UIEdgeInsetsMake(2, 25, 0, 0)];
        _moreBtn.titleLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightRegular];
        [_moreBtn setTitleColor:[UIColor colorWithHexStr:@"#8E8D99"] forState:UIControlStateNormal];
        [_moreBtn addTarget:self action:@selector(clickMoreBtn) forControlEvents:UIControlEventTouchUpInside];
        if (self.collectionStyle == CustomCollectionViewStyleCategory) _moreBtn.hidden = YES;
    }
    return _moreBtn;
}


//- (HomePageBannerPageView *)pageView {
//    if (!_pageView) {
//        NSInteger count = self.dataArr.count;
//        CGFloat pageViewSingleWidth = 6;
//        CGFloat pageViewGap = 11;
//        CGFloat currentPageViewWidth = 6;
//        CGFloat pageViewWidth = (count-1)*(pageViewGap+pageViewSingleWidth)+currentPageViewWidth;
//        _pageView = [[HomePageBannerPageView alloc]initWithFrame:CGRectMake(0, 0, pageViewWidth, 6)];
//        _pageView.center = CGPointMake(self.centerX, self.height-15-3);
//        _pageView.currentPageColor = [UIColor colorWithHexStr:@"#ff80ab"];
//        _pageView.normalPageColor = [UIColor colorWithHexStr:@"#ffffff"];
//        _pageView.pageViewGap = pageViewGap;
//        _pageView.currentPageViewWidth = currentPageViewWidth;
//        _pageView.normalPageViewWidth = pageViewSingleWidth;
//        _pageView.pageViewHeight = 6;
//        _pageView.pageCount = count;
//        [_pageView setupPageViewsWithCount:0];
//        _pageView.hidden = YES;
//    }
//    return _pageView;
//}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
@end
