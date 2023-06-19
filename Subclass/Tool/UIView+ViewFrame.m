//
//  UIView+ViewFrame.m
//  Subclass
//
//  Created by 韩倩云 on 2020/7/2.
//  Copyright © 2020 yy. All rights reserved.
//

#import "UIView+ViewFrame.h"

@implementation UIView (ViewFrame)

- (void)setX:(CGFloat)x {
    CGRect rect = self.frame;
    rect.origin.x = x;
    self.frame = rect;
}

-(void)setY:(CGFloat)y
{
    CGRect rect =self.frame;
    rect.origin.y =y;
    self.frame =rect;
}

- (void)setWidth:(CGFloat)width
{
    CGRect rect =self.frame;
    rect.size.width =width;
    self.frame =rect;
}

- (void)setHeight:(CGFloat)height
{
    CGRect rect =self.frame;
    rect.size.height =height;
    self.frame =rect;
}

- (void)setSize:(CGSize)size {
    CGRect rect = self.frame;
    rect.size = size;
    self.frame = rect;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}
- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center =self.center;
    center.x =centerX;
    self.center =center;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center =self.center;
    center.y =centerY;
    self.center =center;
}

-(CGFloat)centerX
{
    return self.center.x;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (CGSize)size {
    return self.frame.size;
}
@end
