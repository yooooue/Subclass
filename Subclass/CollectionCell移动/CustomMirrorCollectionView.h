//
//  CustomMirrorCollectionView.h
//  MUD004
//
//  Created by 韩倩云 on 2019/6/12.
//  Copyright © 2019 MACCO. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, CustomCollectionViewStyle) {
    CustomCollectionViewStyleBrand = 0,
    CustomCollectionViewStyleMeiDa,
    CustomCollectionViewStylePhotos,
    CustomCollectionViewStyleMakeupPro,
    CustomCollectionViewStyleCategory
};

@protocol CustomCollectionViewDelegate <NSObject>

- (void)clickCellWithStyle:(CustomCollectionViewStyle)style andDataModel:(id)model;

@optional
- (void)clickMoreBtnWithStyle:(CustomCollectionViewStyle)style;

@end

@interface CustomMirrorCollectionView : UIView

@property (nonatomic, assign) CustomCollectionViewStyle collectionStyle;

@property (nonatomic, assign) CGSize itemSize;

@property (nonatomic, copy) NSString * title;

@property (nonatomic, assign) CGFloat lineSpacing;

@property (nonatomic, assign) CGFloat interitemSpacing;

@property (nonatomic, copy) NSString * cellName;

@property (nonatomic, assign) UIEdgeInsets contentInset;

@property (nonatomic, strong) UIColor * collectionViewColor;

@property (nonatomic, assign) BOOL isHidMoreBtn;

@property (nonatomic,weak) id <CustomCollectionViewDelegate > delegate;

@property (nonatomic, assign) BOOL isShowPageView;

- (instancetype)initWithFrame:(CGRect)frame withCellName:(NSString *)cellName;

- (void)setUrl:(NSString *)url andParamDic:(NSDictionary *)dic;

//- (void)setDataArrWithoutNetwork:(NSArray<MirrorProductionModel *> *)dataArr;

@end

NS_ASSUME_NONNULL_END
