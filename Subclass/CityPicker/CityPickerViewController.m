//
//  ViewController.m
//  Demo_CityPickerView
//
//  Created by 韩倩云 on 2018/10/26.
//  Copyright © 2018年 demo. All rights reserved.
//

#import "CityPickerViewController.h"
#import "CustomPickView.h"

@interface CityPickerViewController ()<CustomPickerViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) CustomPickView * pickerView;

@property (nonatomic, assign) CustomPickerViewType pickerViewType;

@property (nonatomic, assign) NSInteger provinceIndex;

@property (nonatomic, assign) NSInteger cityIndex;

@property (nonatomic, copy) NSString * province;

@property (nonatomic, copy) NSString * city;

@property (nonatomic, copy) NSString * area;
@end

@implementation CityPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUI];
}

- (void)setUI {
    for (int i = 0; i < 3; i++) {
        UITextField * textF = [[UITextField alloc]initWithFrame:CGRectMake(50, 100+100*i, self.view.frame.size.width-100, 50)];
        textF.delegate = self;
        textF.tag = 100+i;
        textF.borderStyle = UITextBorderStyleLine;
        textF.text = @"请选择";
        [self.view addSubview:textF];
    }
}

- (CustomPickView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[CustomPickView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 258) andPickerViewType:self.pickerViewType andProvinceIndex:self.provinceIndex andCityIndex:self.cityIndex];
        _pickerView.delegate = self;
    }
    return _pickerView;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([self judgeShowAlertOrPickerViewWith:textField]) {
        [self showPickerView];
    }
    return NO;
}

- (BOOL)judgeShowAlertOrPickerViewWith:(UITextField *)textField {
    if (textField.tag == 100) {
        self.pickerViewType = 0;
        return YES;
    }else if (textField.tag == 101) {
        if ([self.province isEqualToString:@"请选择"] || !self.province) {
            //提示 先选择省
            [self showAlertWithTitle:@"先选择省"];
            return NO;
        }else {
            self.pickerViewType = 1;
            return YES;
        }
    }else {
        if ([self.province isEqualToString:@"请选择"] || !self.province) {
            //提示 先选择省
            [self showAlertWithTitle:@"先选择省"];
            return NO;
        }else if ([self.city isEqualToString:@"请选择"] || !self.city) {
            //提示 先选择市
            [self showAlertWithTitle:@"先选择市"];
            return NO;
        }else {
            self.pickerViewType = 2;
            return YES;
        }
    }
}

- (void)showAlertWithTitle:(NSString *)title {
     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)clickSureBtnWithIndex:(NSInteger)selectedIndex andTitle:(NSString *)title {
    if (self.pickerViewType == 0) {
        self.provinceIndex = selectedIndex;
        self.province = title;
    }else if (self.pickerViewType == 1) {
        self.cityIndex = selectedIndex;
        self.city = title;
    }else {
        self.area = title;
    }
    
    UITextField * currentTextF = (UITextField *)[self.view viewWithTag:100+self.pickerViewType];
    
    //值改变
    if (![currentTextF.text isEqualToString:title]){
        if (self.pickerViewType == 0) {
            UITextField * cityTextF = (UITextField *)[self.view viewWithTag:101];
            UITextField * areaTextF = (UITextField *)[self.view viewWithTag:102];
            cityTextF.text = @"请选择";
            areaTextF.text = @"请选择";
        }else if (self.pickerViewType == 1) {
            UITextField * areaTextF = (UITextField *)[self.view viewWithTag:102];
            areaTextF.text = @"请选择";
        }
    }
    
    currentTextF.text = title;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.pickerView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 258);
    } completion:^(BOOL finished) {
        [self.pickerView removeFromSuperview];
        self.pickerView = nil;
    }];
    
}

- (void)clickCancelBtn {
    [UIView animateWithDuration:0.3 animations:^{
        self.pickerView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 258);
    } completion:^(BOOL finished) {
        [self.pickerView removeFromSuperview];
        self.pickerView = nil;
    }];
}

- (void)clickTextF:(UITextField *)textF {
    switch (textF.tag) {
        case 100:
            self.pickerViewType = 0;
            break;
        case 101:
            self.pickerViewType = 1;
            break;
        case 102:
            self.pickerViewType = 2;
            break;
        default:
            break;
    }
    [self showPickerView];
}

- (void)showPickerView {
    
    [self.view addSubview:self.pickerView];
    [UIView animateWithDuration:0.3 animations:^{
        self.pickerView.frame = CGRectMake(0, self.view.frame.size.height-258, self.view.frame.size.width, 258);
    } completion:^(BOOL finished) {
        
    }];
}

@end
