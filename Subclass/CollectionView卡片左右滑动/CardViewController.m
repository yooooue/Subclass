//
//  CardViewController.m
//  Subclass
//
//  Created by 韩倩云 on 2019/6/11.
//  Copyright © 2019 yy. All rights reserved.
//

#import "CardViewController.h"
#import "StackFlowLayout.h"
#import "CardCollectionViewCell.h"

@interface CardViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView * collectionView;

@property (assign,nonatomic)CGFloat angle;

@property (assign,nonatomic)CGPoint originalCenter;

@property (nonatomic, strong) NSMutableArray * dataArr;

@end

#define kAngleMuti  180

@implementation CardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataArr = [NSMutableArray arrayWithObjects:@0,@1,@2,@3,@4,@5,@6,@7,@8,@9, nil];
    [self.view addSubview:self.collectionView];

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CardCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CardCell" forIndexPath:indexPath];
    self.originalCenter = cell.center;
    cell.label.text = [NSString stringWithFormat:@"%@",self.dataArr[indexPath.item]];
    [cell addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)]];
    return cell;
}

-(void)pan:(UIPanGestureRecognizer *)panGest{
    
    CardCollectionViewCell *cell = (CardCollectionViewCell *)panGest.view;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    if (indexPath.row > 0 ) {
        return;//禁止用户直接拖拽后面的图片
    }
    
    if (panGest.state == UIGestureRecognizerStateChanged) {
        
        CGPoint movePoint = [panGest translationInView:self.collectionView];
        cell.center = CGPointMake(cell.center.x + movePoint.x, cell.center.y + movePoint.y);
        _angle = (cell.center.x - cell.frame.size.width * 0.5) / cell.frame.size.width * 0.5;
        cell.transform = CGAffineTransformMakeRotation(_angle);
        [panGest setTranslation:CGPointZero inView:self.collectionView];
        
    }
    else if (panGest.state == UIGestureRecognizerStateEnded) {
        
        if (ABS(_angle * kAngleMuti) >= 30) {
            [self.dataArr removeObjectAtIndex:indexPath.item];
            [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
        }
        else{
            [UIView animateWithDuration:0.5 animations:^{
                cell.center = self.originalCenter;
                cell.transform = CGAffineTransformMakeRotation(0);
            }];
        }
    }
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        StackFlowLayout * flowLayout = [[StackFlowLayout alloc]init];
        CGFloat itemWidth = self.view.frame.size.width-30;
        CGFloat itemHeight = itemWidth/0.75;
        flowLayout.contentSize = CGSizeMake(itemWidth, itemHeight);
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        [_collectionView registerNib:[UINib nibWithNibName:@"CardCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CardCell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
