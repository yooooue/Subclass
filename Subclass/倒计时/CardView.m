//
//  CardView.m
//  Subclass
//
//  Created by 韩倩云 on 2020/1/4.
//  Copyright © 2020 yy. All rights reserved.
//

#import "CardView.h"

@interface CardView ()
{
    NSMutableArray * imageViewArray;
    UIImageView * currentImgView;
    NSInteger _currentPage;
    
}
@property (nonatomic, assign) NSInteger number;

@end

@implementation CardView

- (instancetype)initWithFrame:(CGRect)frame cardNumber:(NSInteger)number currentPage:(NSInteger)currentPage {
    self = [super initWithFrame:frame];
    if (self) {
        self.number = number;
        _currentPage = currentPage;
        [self initDataWithNumber:number];
        [self initUI];
//        [self time];
    }
    return self;
}

- (void)startOnce {
    _currentPage = (_currentPage-1+self.number)%self.number;
    currentImgView.image = imageViewArray[_currentPage];
}

- (void)initUI {
    currentImgView = [[UIImageView alloc]initWithFrame:self.bounds];
    currentImgView.image = imageViewArray[_currentPage];
    [self addSubview:currentImgView];
}

- (void)initDataWithNumber:(NSInteger)number {
    imageViewArray = [NSMutableArray array];
    for (int a=0; a<number; a++) {
        UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png",a]];
        [imageViewArray addObject:image];
    }
}


@end
