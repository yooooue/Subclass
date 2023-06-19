//
//  YPhotoPreviewView.m
//  仿小红书裁剪
//
//  Created by 韩倩云 on 2019/8/16.
//  Copyright © 2019 yy. All rights reserved.
//

#import "YPhotoPreviewView.h"
#import "YPhotoAlbumModel.h"
#import "YPhotoManager.h"
#import "UIImage+CropImage.h"

@interface YPhotoPreviewView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIButton * zoomBtn;

@property (nonatomic, strong) UIImage * image;

@property (nonatomic, assign) BOOL isRecoverScale;

@end

@implementation YPhotoPreviewView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.maximumZoomScale = 2.5;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.multipleTouchEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.scrollsToTop = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.delaysContentTouches = NO;
        _scrollView.canCancelContentTouches = YES;
        _scrollView.alwaysBounceVertical = NO;
        _scrollView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_scrollView];
        
        _imageView = [[UIImageView alloc]init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [_scrollView addSubview:_imageView];
        
        [self addSubview:self.zoomBtn];
    }
    return self;
}

- (void)setModel:(YAssetModel *)model {
    _model = model;
    if (self.hasSelected) {
        if (self.model.isFirstSelected && model.type != 0) {
            self.zoomBtn.hidden = NO;
        }else {
            self.zoomBtn.hidden = YES;
        }
    }else {
        if (model.type == 0) {
            self.zoomBtn.hidden = YES;
        }else {
            self.zoomBtn.hidden = NO;
        }
    }
    self.asset = model.asset;
}

- (void)setAsset:(PHAsset *)asset {
    _asset = asset;
    [[YPhotoManager sharedManager] requestImageForAsset:asset size:self.frame.size resizeMode:PHImageRequestOptionsResizeModeFast completion:^(UIImage * _Nonnull image, NSDictionary * _Nonnull info) {
        self.imageView.image = image;
        self.image = image;
        self.hasSelected?[self recoverSubviews]:[self recoverScollView];
    }];
}

- (void)setType:(YFirstSelectPhotoType)type {
    _type = type;
    [_scrollView setZoomScale:1 animated:NO];
    self.model.scale = 1;
    self.scrollView.frame = self.bounds;
    [self resizeSubviewsScrollView];
}

- (void)setHasSelected:(BOOL)hasSelected {
    _hasSelected = hasSelected;
}

- (void)recoverSubviews {
    [_scrollView setZoomScale:self.model.scale animated:NO];
//    self.isRecoverScale = NO;
    [self resizeSubviews];
}

- (void)recoverScollView {
    [_scrollView setZoomScale:1 animated:NO];
    self.zoomBtn.selected = NO;
    self.scrollView.frame = self.bounds;
    [self resizeSubviewsScrollView];
}

- (void)resizeSubviews {
    UIImage * image = self.imageView.image;
    CGSize imgSize = image.size;
    CGFloat scrollViewW = self.scrollView.frame.size.width;
    CGFloat scrollViewH = scrollViewW * imgSize.height/imgSize.width;
    if (imgSize.width >= imgSize.height) {
        scrollViewH = self.frame.size.height;
        scrollViewW = scrollViewH/(imgSize.height/imgSize.width);
    }
//    _scrollView.zoomScale = self.model.scale;
    _scrollView.contentSize = self.model.isChangeFrame?CGSizeMake(scrollViewW*self.model.scale, scrollViewH*self.model.scale):CGSizeMake(scrollViewW, scrollViewH);
    _scrollView.contentOffset = self.model.isChangeFrame?self.model.finallyOffset: CGPointMake((scrollViewW-self.frame.size.width)/2, (scrollViewH-self.frame.size.height) /2);
    _imageView.frame = CGRectMake(0, 0, _scrollView.contentSize.width, _scrollView.contentSize.height);
}

//宽高比全屏1：1
- (void)resizeSubviewsScrollView {
    UIImage * image = self.imageView.image;
    CGSize imgSize = image.size;
    CGFloat scrollViewW = self.scrollView.frame.size.width;
    CGFloat scrollViewH = scrollViewW * imgSize.height/imgSize.width;
    if (imgSize.width > imgSize.height) {
        scrollViewH = self.scrollView.frame.size.height;
        scrollViewW = scrollViewH/(imgSize.height/imgSize.width);
    }else {
        scrollViewW = self.scrollView.frame.size.width;
        scrollViewH = scrollViewW/(imgSize.width/imgSize.height);
    }
    _scrollView.contentSize = CGSizeMake(scrollViewW, scrollViewH);
    _scrollView.contentOffset = CGPointMake((scrollViewW-self.scrollView.frame.size.width)/2, (scrollViewH-self.scrollView.frame.size.height) /2);
    _imageView.frame = CGRectMake(0, 0, _scrollView.contentSize.width, _scrollView.contentSize.height);
}

- (void)clickZoomBtn:(UIButton *)btn {
//    self.model.cropImage = [self.image cropImgWithSize:[self imageCropFrame]];
    btn.selected = !btn.selected;
    self.model.scale = 1;
    [self.scrollView setZoomScale:1 animated:YES];
    [UIView animateWithDuration:0.25 animations:^{
        if (btn.selected) {
            //长图
            if (self.model.aspectRatio > 1) {
                self.scrollView.frame = CGRectMake(0, self.frame.size.width*0.25/2, self.frame.size.width, self.frame.size.width*3/4);
            }else if (self.model.aspectRatio < 1) {
                self.scrollView.frame = CGRectMake(self.frame.size.height*0.25/2, 0, self.frame.size.height*3/4, self.frame.size.height);;
            }
        }else {
            //方图
            self.scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        }
        [self resizeSubviewsScrollView];
    }];
}

- (void)saveCropImgforModel {
    if (self.model.isSelected) {
        self.model.cropImage = [self.image cropImgWithSize:[self imageCropFrameWithImage]];
    }
}

- (CGRect)imageCropFrameWithImage {
    CGRect frame = CGRectZero;
    CGSize imageSize = self.image.size;
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

#pragma mark ---uiscrollview delegate---
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
//    NSLog(@"缩放倍数：%f--X轴偏移量：%ff--Y轴偏移量：%f",scrollView.zoomScale, scrollView.contentOffset.x,scrollView.contentOffset.y);
//    self.model.scale = scrollView.zoomScale;
//    self.model.isChangeFrame = YES;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
//    self.model.scale = scrollView.zoomScale;
//    self.model.isChangeFrame = YES;
//    NSLog(@"%f---%f",scrollView.zoomScale,scale);
    [self changeModelProperty:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self changeModelProperty:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    self.model.finallyOffset = scrollView.contentOffset;
//    self.model.isChangeFrame = YES;
//    NSLog(@"缩放倍数：%f--X轴偏移量：%ff--Y轴偏移量：%f",scrollView.zoomScale, scrollView.contentOffset.x,scrollView.contentOffset.y);
    [self changeModelProperty:scrollView];
}

- (void)changeModelProperty:(UIScrollView *)scrollView {
    self.model.scale = scrollView.zoomScale;
    self.model.finallyOffset = scrollView.contentOffset;
    self.model.isChangeFrame = YES;
    if (self.model.isSelected) {
//        self.model.cropImage = [self.image cropImgWithSize:[self imageCropFrame]];
    }
}

- (UIButton *)zoomBtn {
    if (!_zoomBtn) {
        _zoomBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width-10-44, self.frame.size.width-10-44, 44, 44)];
        [_zoomBtn setTitle:@"长" forState:UIControlStateNormal];
        [_zoomBtn setTitle:@"方" forState:UIControlStateSelected];
        _zoomBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _zoomBtn.titleLabel.textColor = [UIColor whiteColor];
        [_zoomBtn addTarget:self action:@selector(clickZoomBtn:) forControlEvents:UIControlEventTouchUpInside];
        _zoomBtn.layer.cornerRadius = 22;
        
    }
    return _zoomBtn;
}
@end
