//
//  ClipViewController.m
//  Subclass
//
//  Created by 韩倩云 on 2020/7/23.
//  Copyright © 2020 yy. All rights reserved.
//

#import "ClipViewController.h"
#import "MaskView.h"
#import "UIImage+SubImage.h"

@interface ClipViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIButton * cancelBtn;
@property (nonatomic, strong) UIButton * doneBtn;
@property (nonatomic, strong) UIButton * btn34;
@property (nonatomic, strong) UIButton * btn11;
@property (nonatomic, strong) UIButton * btn43;
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, strong) MaskView * maskView;
@property (nonatomic, assign) BOOL isFirstZoom;
@property (nonatomic, assign) CGSize hollowSize;
@property (nonatomic, strong) UIView * clipBgView;

@end

@implementation ClipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    self.isFirstZoom = YES;
    self.hollowSize = CGSizeMake(self.view.width-20, (self.view.width-20)/0.75);
    [self.view addSubview:self.clipBgView];
    [self.clipBgView addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageView];
    [self.clipBgView addSubview:self.maskView];
    [self.view addSubview:self.cancelBtn];
    [self.view addSubview:self.doneBtn];
    [self.view addSubview:self.btn43];
    [self.view addSubview:self.btn34];
    [self.view addSubview:self.btn11];
}

- (void)setAssetModel:(YAssetModel *)assetModel {
    _assetModel = assetModel;
    [[YPhotoManager sharedManager]requestImageForAsset:assetModel.asset size:self.clipBgView.bounds.size resizeMode:PHImageRequestOptionsResizeModeFast completion:^(UIImage * _Nonnull image, NSDictionary * _Nonnull info) {
        self.imageView.image = image;
        [self resizeSubviews];
    }];
}

- (void)setHollowSize:(CGSize)hollowSize {
    _hollowSize = hollowSize;
    self.scrollView.size = hollowSize;
    self.scrollView.center = CGPointMake(self.clipBgView.width/2, self.clipBgView.height/2);
}

- (void)resizeSubviews {
    UIImage * image = self.imageView.image;
    CGSize imgSize = image.size;
    CGFloat scrollViewW = self.scrollView.frame.size.width;
    CGFloat scrollViewH = scrollViewW * imgSize.height/imgSize.width;
//    if (imgSize.width >= imgSize.height) {
//        scrollViewH = self.view.frame.size.height;
//        scrollViewW = scrollViewH/(imgSize.height/imgSize.width);
//    }
    self.scrollView.contentSize = CGSizeMake(scrollViewW, scrollViewH);
    self.scrollView.contentOffset = CGPointMake((scrollViewW-self.scrollView.frame.size.width)/2, (scrollViewH-self.scrollView.frame.size.height) /2);
    self.imageView.frame = CGRectMake(0, 0, self.scrollView.contentSize.width, self.scrollView.contentSize.height);
}

#pragma mark ---UIScrollViewDelegate
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

#pragma mark ---Click selector
- (void)cancelBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doneBtnClick {
    [self dismissViewControllerAnimated:YES completion:^{
        UIImage * image = [self.imageView.image subImageWithRect:[self imageCropFrameWithImage]];
        self.assetModel.cropImage = image;
        if (self.clipImageBlock) {
            self.clipImageBlock(image);
        }
    }];
}

- (CGRect)imageCropFrameWithImage {
    CGRect frame = CGRectZero;
    UIImage * image = self.imageView.image;
    CGSize imageSize = image.size;
    CGSize contentSize = self.scrollView.contentSize;
    CGPoint contentOffset = self.scrollView.contentOffset;
    CGRect cropViewFrame = self.scrollView.frame;
    UIEdgeInsets edgeInsets = self.scrollView.contentInset;
    
    frame.origin.x = floorf((contentOffset.x + edgeInsets.left) * (imageSize.width/contentSize.width));
    frame.origin.x = MAX(0, frame.origin.x);
    frame.origin.y = floorf((floorf(contentOffset.y) + edgeInsets.top) * (imageSize.height/contentSize.height));
    frame.origin.y = MAX(0, frame.origin.y);
    frame.size.width = cropViewFrame.size.width * (imageSize.width/contentSize.width);
    frame.size.width = MIN(frame.size.width, imageSize.width);
    if (cropViewFrame.size.width == cropViewFrame.size.height) {
        frame.size.height = frame.size.width;
    }else {
        frame.size.height = cropViewFrame.size.height * (imageSize.height/contentSize.height);
        frame.size.height = MIN(frame.size.height, imageSize.height);
    }
    
    if (frame.origin.x + frame.size.width > imageSize.width) {
        frame.origin.x = imageSize.width - frame.size.width;
    }
    
    if (frame.origin.y + frame.size.height > imageSize.height) {
        frame.origin.y = imageSize.height - frame.size.height;
    }
    
    return frame;
}

- (void)scaleBtnClick:(UIButton *)btn {
    if (btn.selected) return;
    btn.selected = YES;
    [self.scrollView setZoomScale:1 animated:YES];
    switch (btn.tag) {
        case 100:
            self.maskView.aspectRatio = TOClipViewControllerAspectRatioPreset3x4;
            self.btn11.selected = NO;
            self.btn43.selected = NO;
            self.hollowSize = CGSizeMake(self.view.width-20, (self.view.width-20)/0.75);
            break;
        case 101:
            self.maskView.aspectRatio = TOClipViewControllerAspectRatioPreset1x1;
            self.btn34.selected = NO;
            self.btn43.selected = NO;
            self.hollowSize = CGSizeMake(self.view.width-20, (self.view.width-20)/1);
            break;
        case 102:
            self.maskView.aspectRatio = TOClipViewControllerAspectRatioPreset4x3;
            self.btn11.selected = NO;
            self.btn34.selected = NO;
            self.hollowSize = CGSizeMake(self.view.width-20, (self.view.width-20)/(4/3.0));
            break;
        default:
            break;
    }
    
    
}

#pragma mark ---Lazy loading
- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, self.view.height-15-25-BOTTOM_SPACE, 50, 25)];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)doneBtn {
    if (!_doneBtn) {
        _doneBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.width-20-50, self.view.height-15-25-BOTTOM_SPACE, 50, 25)];
        [_doneBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_doneBtn addTarget:self action:@selector(doneBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneBtn;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 0, self.hollowSize.width,self.hollowSize.height)];
        _scrollView.center = CGPointMake(self.clipBgView.width/2, self.clipBgView.height/2);
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.maximumZoomScale = 2.5;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.multipleTouchEnabled = YES;
        _scrollView.scrollsToTop = NO;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.delaysContentTouches = NO;
        _scrollView.canCancelContentTouches = YES;
        _scrollView.backgroundColor = [UIColor colorWithHexStr:@"#24262E"];
        _scrollView.delegate = self;
        _scrollView.layer.masksToBounds = NO;
    }
    return _scrollView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
//        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        _imageView.frame = self.scrollView.bounds;
    }
    return _imageView;
}

- (UIButton *)btn11 {
    if (!_btn11) {
        _btn11 = [[UIButton alloc]initWithFrame:CGRectMake(self.view.width/2-25, CGRectGetMaxY(self.clipBgView.frame)+30, 50, 25)];
        [_btn11 setTitle:@"1:1" forState:UIControlStateNormal];
        [_btn11 addTarget:self action:@selector(scaleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _btn11.tag = 101;
    }
    return _btn11;
}

- (UIButton *)btn34 {
    if (!_btn34) {
        _btn34 = [[UIButton alloc]initWithFrame:CGRectMake(60, CGRectGetMaxY(self.clipBgView.frame)+30, 50, 25)];
        [_btn34 setTitle:@"3:4" forState:UIControlStateNormal];
        [_btn34 addTarget:self action:@selector(scaleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _btn34.tag = 100;
    }
    return _btn34;
}

- (UIButton *)btn43 {
    if (!_btn43) {
        _btn43 = [[UIButton alloc]initWithFrame:CGRectMake(self.view.width-59-60, CGRectGetMaxY(self.clipBgView.frame)+30, 50, 25)];
        [_btn43 setTitle:@"4:3" forState:UIControlStateNormal];
        [_btn43 addTarget:self action:@selector(scaleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _btn43.tag = 102;
    }
    return _btn43;
}

- (MaskView *)maskView {
    if (!_maskView) {
        _maskView = [[MaskView alloc]initWithFrame:self.clipBgView.bounds];
        _maskView.aspectRatio = TOClipViewControllerAspectRatioPreset3x4;
        _maskView.userInteractionEnabled = NO;
    }
    return _maskView;
}

- (UIView *)clipBgView {
    if (!_clipBgView) {
        _clipBgView = [[UIView alloc]initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT, self.view.width, self.view.height-150-BOTTOM_SPACE)];
        _clipBgView.layer.masksToBounds = YES;
        _clipBgView.backgroundColor = [UIColor blackColor];
    }
    return _clipBgView;
}
@end
