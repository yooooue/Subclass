//
//  ViewController.m
//  Demo_CollectionCell移动
//
//  Created by 韩倩云 on 2018/11/9.
//  Copyright © 2018年 demo. All rights reserved.
//

#import "MoveCellViewController.h"
#import "NorCollectionViewController.h"
#import "WaterfallCollectionViewViewController.h"
#import "CustomViewController.h"
#import "Subclass-Swift.h"

@interface MoveCellViewController ()

@end

@implementation MoveCellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"cell移动重排";
    [self setUI];
}

- (void)setUI {
    NSArray * arr = @[@"普通collectionView", @"瀑布流", @"自定义布局",@"SupplementaryView"];
    for (int i = 0; i < arr.count; i++) {
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(50, 100+i*100, self.view.frame.size.width-100, 50)];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        btn.tag = 100+i;
        btn.backgroundColor = [UIColor blackColor];
        [btn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
}

- (void)onClick:(UIButton *)btn {
    switch (btn.tag) {
        case 100:
            {
                NorCollectionViewController * vc = [[NorCollectionViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
        case 101:
        {
            WaterfallCollectionViewViewController * vc = [[WaterfallCollectionViewViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 102:
        {
            CustomViewController * vc = [[CustomViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        default:
            break;
    }
}



@end
