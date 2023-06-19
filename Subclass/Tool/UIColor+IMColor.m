//
//  UIColor+IMColor.m
//  ImedMaster
//
//  Created by Johnny Shi on 16/5/5.
//  Copyright © 2016年 xinghui. All rights reserved.
//

#import "UIColor+IMColor.h"
#define DEFAULT_VOID_COLOR [UIColor whiteColor]
@implementation UIColor (IMColor)
+(UIColor *)colorWithHexStr:(NSString *)hexColor{
    NSString *cString = [[hexColor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6 && [cString length] != 8)
        return DEFAULT_VOID_COLOR;
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    NSString *aString=nil;
    if ([cString length]==8) {
        range.location=6;
        aString=[cString substringWithRange:range];
    }
    
    
    
    unsigned int r, g, b, a;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    [[NSScanner scannerWithString:aString] scanHexInt:&a];
//    
//    if (![Convert isNull:aString]) {
//        unsigned int a;
//        [[NSScanner scannerWithString:aString] scanHexInt:&a];
//        return [UIColor colorWithRed:((float) r / 255.0f)
//                               green:((float) g / 255.0f)
//                                blue:((float) b / 255.0f)
//                               alpha:((float) a / 255.0f)];
//    }else{
        return [UIColor colorWithRed:((float) r / 255.0f)
                               green:((float) g / 255.0f)
                                blue:((float) b / 255.0f)
                               alpha:aString?(float)a/100.0:1.0f];
//    }

}

+ (NSArray *)getColorRGBsWithHexStr:(NSString *)hexColor{
    NSString *cString = [[hexColor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6 && [cString length] != 8)
        return @[@1,@1,@1];
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    NSString *aString=nil;
    if ([cString length]==8) {
        range.location=6;
        aString=[cString substringWithRange:range];
    }
    
    
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return @[@((float)r/255.0),@((float)g/255.0),@((float)b/255.0)];
}
@end
