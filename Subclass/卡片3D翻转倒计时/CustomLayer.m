//
//  CustomLayer.m
//  Subclass
//
//  Created by 韩倩云 on 2019/11/27.
//  Copyright © 2019 yy. All rights reserved.
//

#import "CustomLayer.h"

@implementation CustomLayer

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super init];
    if (self) {
        self.frame = frame;
        self.doubleSided = YES;
        self.anchorPoint = CGPointMake(0.5, 1.0);
        self.position = CGPointMake(self.position.x, self.position.y+self.frame.size.height/2);
        
        _frontLayer = [[CALayer alloc]init];
        _frontLayer.frame = self.bounds;
        _frontLayer.backgroundColor = [UIColor grayColor].CGColor;
        _frontLayer.doubleSided = NO;
        _frontLayer.name = @"frontLayer";
        _frontLayer.opaque = NO;
        
        _backLayer = [[CALayer alloc]init];
        _backLayer.frame = self.bounds;
        _backLayer.backgroundColor = [UIColor whiteColor].CGColor;
        _backLayer.doubleSided = YES;
        _backLayer.name = @"backLayer";
        _backLayer.opaque = YES;
        
        [self addSublayer:_backLayer];
        [self addSublayer:_frontLayer];
    }
    return self;
}
@end
