//
//  CustomViewController.m
//  Subclass
//
//  Created by 韩倩云 on 2021/9/13.
//  Copyright © 2021 yy. All rights reserved.
//

#import "CustomViewController.h"
#import "CustomMirrorCollectionView.h"

@interface CustomViewController ()<CustomCollectionViewDelegate>

@property (nonatomic, strong) CustomMirrorCollectionView * categoryCollectionView;

@end

@implementation CustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.categoryCollectionView];
}

- (CustomMirrorCollectionView *)categoryCollectionView {
    if (!_categoryCollectionView) {
        _categoryCollectionView = [[CustomMirrorCollectionView alloc]initWithFrame:CGRectMake(0, 200, SCREEN_WIDTH, 230) withCellName:@"MirrorCategoryCollectionViewCell"];
        _categoryCollectionView.title = @"实时试妆";
        _categoryCollectionView.collectionStyle = CustomCollectionViewStyleCategory;
        _categoryCollectionView.itemSize = CGSizeMake(76, 88);
        CGFloat spacing = (SCREEN_WIDTH-24-76*4)/3.0;
        _categoryCollectionView.interitemSpacing = spacing;
        _categoryCollectionView.lineSpacing = 7;
        _categoryCollectionView.cellName = @"MirrorCategoryCollectionViewCell";
        _categoryCollectionView.contentInset = UIEdgeInsetsMake(0, 12, 0, 12);
        _categoryCollectionView.delegate = self;
//        [_categoryCollectionView setUrl:[MkIPManager.ProductApiv2 stringByAppendingString:@"product/RealMakeupCosmetics"] andParamDic:@{@"PageSize":@"15",
//                                                                                                                                        @"CurrentPage":@"1"
//        }];
    }
    return _categoryCollectionView;
}

@end
