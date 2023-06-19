//
//  CustomPickView.m
//  Demo_CityPickerView
//
//  Created by 韩倩云 on 2018/10/26.
//  Copyright © 2018年 demo. All rights reserved.
//

#import "CustomPickView.h"

@interface CustomPickView ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView * pickerView;

@property (nonatomic, strong) UIButton * cancelBtn;

@property (nonatomic, strong) UIButton * sureBtn;

@property (nonatomic, strong) NSMutableArray * provinceArr;

@property (nonatomic, strong) NSMutableArray * cityArr;

@property (nonatomic, strong) NSMutableArray * areaArr;

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, copy) NSString * selectTitle;

@property (nonatomic, strong) NSArray * currentArr;

@end

@implementation CustomPickView


- (instancetype)initWithFrame:(CGRect)frame andPickerViewType:(CustomPickerViewType)type andProvinceIndex:(NSInteger)provinceIndex andCityIndex:(NSInteger)cityIndex {
    self = [super initWithFrame:frame];
    if (self) {
        self.pickerViewType = type;
        self.provinceIndex = provinceIndex;
        self.cityIndex = cityIndex;
        [self getAreaInformation];
        [self setUI];
    }
    return self;
}

#pragma mark ---selector---

- (void)clickBtn:(UIButton *)btn {
    switch (btn.tag) {
        case 100://cancel
            if ([self.delegate respondsToSelector:@selector(clickCancelBtn)]) {
                [self.delegate clickCancelBtn];
            }
            break;
        case 101://sure
            if ([self.delegate respondsToSelector:@selector(clickSureBtnWithIndex:andTitle:)]) {
                if (self.selectTitle == nil) {
                    self.selectTitle = self.currentArr[0];
                    self.selectedIndex = 0;
                }
                [self.delegate clickSureBtnWithIndex:self.selectedIndex andTitle:self.selectTitle];
            }
            break;
        default:
            break;
    }
}

#pragma mark ---pickerview delegate---
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (self.pickerViewType) {
        case CustomPickerViewTypeProvince:
            self.currentArr = self.provinceArr;
//            return self.provinceArr.count;
            break;
        case CustomPickerViewTypeCity:
            self.currentArr = self.cityArr;
//            return self.cityArr.count;
            break;
        case CustomPickerViewTypeArea:
            self.currentArr = self.areaArr;
//            return self.areaArr.count;
            break;
        default:
            break;
    }
    return self.currentArr.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    switch (self.pickerViewType) {
        case CustomPickerViewTypeProvince:
            return self.provinceArr[row];
            break;
        case CustomPickerViewTypeCity:
            return self.cityArr[row];
            break;
        case CustomPickerViewTypeArea:
            return self.areaArr[row];
            break;
        default:
            break;
    }
     
//    return self.currentArr[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectedIndex = row;
    self.selectTitle = self.currentArr[row];
}

- (void)getAreaInformation {
    NSString * path = [[NSBundle mainBundle] pathForResource:@"areaArr" ofType:@"plist"];
    NSArray * areaArr = [[NSArray alloc]initWithContentsOfFile:path];
    
    for (NSDictionary * pDic in areaArr) {
        NSArray * pArr = [pDic allKeys];
        [self.provinceArr addObjectsFromArray:pArr];
        //        NSArray * cArr = [pDic allValues];//这个省下面的所有市的数组
        //        [self.cityArr addObjectsFromArray:cArr];
    }
    // 0 是当前province的inde
    NSArray * selectArr = [areaArr[self.provinceIndex] allValues];
    NSLog(@"%@",selectArr);
    NSMutableArray * cityMArr = [NSMutableArray array];
    for (NSArray * arr in selectArr) {
        [cityMArr addObjectsFromArray:arr];
    }
    for (NSDictionary * dic in cityMArr) {
        [self.cityArr addObjectsFromArray:[dic allKeys]];
    }
    
    // 0 当前city的index
    if (cityMArr.count > self.cityIndex)
        [self.areaArr addObjectsFromArray:[cityMArr[self.cityIndex] objectForKey:self.cityArr[self.cityIndex]]];
    NSLog(@"%@",self.areaArr);
}

- (void)setUI {
    [self addSubview:self.cancelBtn];
    [self addSubview:self.sureBtn];
    [self addSubview:self.pickerView];
}

#pragma mark ---懒载---
- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, self.frame.size.width, self.frame.size.height-40)];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        
    }
    return _pickerView;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _cancelBtn.tag = 100;
        [_cancelBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width-80, 0, 80, 40)];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _sureBtn.tag = 101;
        [_sureBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

- (NSMutableArray *)provinceArr {
    if (!_provinceArr) {
        _provinceArr = [NSMutableArray array];
    }
    return _provinceArr;
}

- (NSMutableArray *)cityArr {
    if (!_cityArr) {
        _cityArr = [NSMutableArray array];
    }
    return _cityArr;
}

- (NSMutableArray *)areaArr {
    if (!_areaArr) {
        _areaArr = [NSMutableArray array];
    }
    return _areaArr;
}

@end
