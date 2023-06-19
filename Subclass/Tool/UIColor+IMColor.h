//
//  UIColor+IMColor.h
//  ImedMaster
//
//  Created by Johnny Shi on 16/5/5.
//  Copyright © 2016年 xinghui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (IMColor)
+(UIColor*)colorWithHexStr:(NSString*)hexStr;
+ (NSArray *)getColorRGBsWithHexStr:(NSString *)hexColor;

@end
