//
//  CustomPickView.h
//  Demo_CityPickerView
//
//  Created by 韩倩云 on 2018/10/26.
//  Copyright © 2018年 demo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, CustomPickerViewType) {
    CustomPickerViewTypeProvince = 0,
    CustomPickerViewTypeCity,
    CustomPickerViewTypeArea
};

@protocol CustomPickerViewDelegate <NSObject>

- (void)clickCancelBtn ;

- (void)clickSureBtnWithIndex:(NSInteger)selectedIndex andTitle:(NSString *)title ;

@end

@interface CustomPickView : UIView

@property (nonatomic, weak) id <CustomPickerViewDelegate> delegate;

@property (nonatomic, assign) CustomPickerViewType pickerViewType;

@property (nonatomic, assign) NSInteger provinceIndex;

@property (nonatomic, assign) NSInteger cityIndex;

- (instancetype)initWithFrame:(CGRect)frame andPickerViewType:(CustomPickerViewType)type andProvinceIndex:(NSInteger)provinceIndex andCityIndex:(NSInteger)cityIndex ;

@end

NS_ASSUME_NONNULL_END
