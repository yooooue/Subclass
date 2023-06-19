//
//  ViewController.m
//  Subclass
//
//  Created by 韩倩云 on 2019/6/10.
//  Copyright © 2019 yy. All rights reserved.
//

#import "ViewController.h"
#import "TableViewClickCellUnfoldViewController.h"
#import "CollectionViewClickCellUnfoldViewController.h"
#import "CardViewController.h"
#import "CountDownViewController.h"
#import "FoldCellViewController.h"
#import "PrinterViewController.h"
#import "LocalPushViewController.h"
#import "TimeDownViewController.h"
#import "SelectPhotosViewController.h"
#import "MoveCellViewController.h"
#import "CityPickerViewController.h"
#import "VideoPlayerViewController.h"
#import "TableBaseViewController.h"
#import "SearchViewController.h"
#import "KeyboardViewController.h"
#import "AlbumViewController.h"
#import "ShareToWXViewController.h"
#import "ScaleViewController.h"
#import <dlfcn.h>
#import <libkern/OSAtomic.h>
#import "Subclass-Swift.h"
#import "WaterfallCollectionViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSArray * titleArr;

@property (nonatomic, strong) NSArray * classArr;

@end

@implementation ViewController

void __sanitizer_cov_trace_pc_guard_init(uint32_t *start,
                                                    uint32_t *stop) {
  static uint64_t N;  // Counter for the guards.
  if (start == stop || *start) return;  // Initialize only once.
  printf("INIT: %p %p\n", start, stop);
  for (uint32_t *x = start; x < stop; x++)
    *x = ++N;  // Guards should start from 1.
}

// This callback is inserted by the compiler on every edge in the
// control flow (some optimizations apply).
// Typically, the compiler will emit the code like this:
//    if(*guard)
//      __sanitizer_cov_trace_pc_guard(guard);
// But for large functions it will emit a simple call:
//    __sanitizer_cov_trace_pc_guard(guard);


/// hook到了所有函数
/// @param guard 只给了首位 load首位是0
void __sanitizer_cov_trace_pc_guard(uint32_t *guard) {
//  if (!*guard) return;  // Duplicate the guard check.
  
  void *PC = __builtin_return_address(0); //
    
//    创建结构体
    SYNode *node = (SYNode *)malloc(sizeof(SYNode));
    *node = (SYNode){PC,NULL};
//    进入  offsetof(t, d) 当前成员d 在该结构体t中位置的偏移
    OSAtomicEnqueue(&symbolList, node, offsetof(SYNode, next));
    
    
        //通过地址 拿函数名称
    //    Dl_info info;
    //    const char      *dli_fname;     /* Pathname of shared object */  路径
    //    void            *dli_fbase;     /* Base address of shared object */ 地址
    //    const char      *dli_sname;     /* Name of nearest symbol */ 函数名
    //    void            *dli_saddr;     /* Address of nearest symbol */ 函数起始地址
    //    dladdr(PC, &info);
    //    printf("fname：%s \n fbase：%p \n sname:%s \n saddr:%p",info.dli_fname,info.dli_fbase,info.dli_sname,info.dli_saddr);
    //    NSLog(@"fname：%s \n fbase：%p \n sname:%s \n saddr:%p",info.dli_fname,info.dli_fbase,info.dli_sname,info.dli_saddr);
        
}

//原子队列
static OSQueueHead symbolList = OS_ATOMIC_QUEUE_INIT;//先进后出
//定义符号结构体
typedef struct {
    void *pc;
    void *next;
}SYNode;


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSMutableArray<NSString *> *symbolNames = [NSMutableArray array];
    while (YES) {
         SYNode *node = (SYNode *)OSAtomicDequeue(&symbolList, offsetof(SYNode, next));
        if (node==NULL) {
            break;
        }
        Dl_info info;
        dladdr(node->pc, &info);
        //加符号
        NSString * name = @(info.dli_sname);
        BOOL isObjc = [name hasPrefix:@"+["] || [name hasPrefix:@"-["];
        NSString * symbolName = isObjc? name:[@"_" stringByAppendingString:name];
        [symbolNames addObject:symbolName];
//        printf("%s \n", info.dli_sname);
    }
   
    NSEnumerator * emumerator = [symbolNames reverseObjectEnumerator];//取反
    NSMutableArray <NSString *> * funcs = [NSMutableArray arrayWithCapacity:symbolNames.count];
    //去重
    NSString * name;
    while (name = [emumerator nextObject]) {
        if (![funcs containsObject:name]) {
            [funcs addObject:name];
        }
    }
    NSLog(@"%@",funcs);
    [funcs removeObject:[NSString stringWithFormat:@"@",__FUNCTION__]];
    
    
    NSString * funcStr = [funcs componentsJoinedByString:@"\n"];
    NSString * filePath = [NSTemporaryDirectory() stringByAppendingString:@"sub.order"];
    NSData * fileContents = [funcStr dataUsingEncoding:NSUTF8StringEncoding];
    [[NSFileManager defaultManager] createFileAtPath:filePath contents:fileContents attributes:nil];
    NSLog(@"filePath%@",filePath);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"首页";
    self.view.backgroundColor = [UIColor whiteColor];
    self.titleArr = @[@"TableView点击cell展开",@"CollectionView点击cell展开",@"卡片左滑右滑",@"3D翻转倒计时",@"cell折叠",@"打印机",@"本地推送",@"倒计时",@"选择编辑照片",@"移动Cell",@"CityPicker",@"视频播放",@"TableView和CollectionView嵌套滑动",@"搜索",@"表情键盘",@"相册",@"微信分享",@"view缩放",@"Lottie动画",@"自定义转场",@"AVFoundation"];
    self.classArr = @[@"TableViewClickCellUnfoldViewController",@"CollectionViewClickCellUnfoldViewController",@"CardViewController",@"CountDownViewController",@"FoldCellViewController",@"PrinterViewController",@"LocalPushViewController",@"TimeDownViewController",@"SelectPhotosViewController",@"MoveCellViewController",@"CityPickerViewController",@"VideoPlayerViewController",@"TableBaseViewController",@"SearchViewController",@"KeyboardViewController",@"AlbumViewController",@"ShareToWXViewController",@"ScaleViewController",@"SwiftViewController",@"WaterfallCollectionViewController",@"AVFViewController"];
    [self.view addSubview:self.tableView];
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];

    CGFloat top = window.safeAreaInsets.top;
    
    CGFloat bottom = window.safeAreaInsets.bottom;

    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.titleArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            {
                TableViewClickCellUnfoldViewController * vc = [[TableViewClickCellUnfoldViewController alloc]init];
                vc.title = @"点击Cell展开";
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
        case 1:
            {
                CollectionViewClickCellUnfoldViewController * vc = [[CollectionViewClickCellUnfoldViewController alloc]init];
                vc.title = @"点击Cell展开";
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
        case 2:
            {
                CardViewController * vc = [[CardViewController alloc]init];
                vc.title = @"卡片左右滑动";
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
        case 3:
        {
            CountDownViewController * vc = [[CountDownViewController alloc]init];
            vc.title = @"3D翻转倒计时";
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4:
        {
            FoldCellViewController * vc = [[FoldCellViewController alloc]init];
            vc.title = self.titleArr[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5:
        {
            PrinterViewController * vc = [[PrinterViewController alloc]init];
            vc.title = self.titleArr[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 6:
        {
            LocalPushViewController * vc = [[LocalPushViewController alloc]init];
            vc.title = self.titleArr[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 7:
        {
            TimeDownViewController * vc = [[TimeDownViewController alloc]init];
            vc.title = self.titleArr[indexPath.row];
            vc.timeStr = @"2020-01-15 16:00:00";
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 8:
        {
            SelectPhotosViewController * vc = [[SelectPhotosViewController alloc]init];
            vc.title = self.titleArr[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 9:
        {
            MoveCellViewController * vc = [[MoveCellViewController alloc]init];
            vc.title = self.titleArr[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 10:
        {
            CityPickerViewController * vc = [[CityPickerViewController alloc]init];
            vc.title = self.titleArr[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 11:
        {
            VideoPlayerViewController * vc = [[VideoPlayerViewController alloc]init];
            vc.title = self.titleArr[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 12:
        {
            TableBaseViewController * vc = [[TableBaseViewController alloc]init];
            vc.title = self.titleArr[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 13:
        {
            SearchViewController * vc = [[SearchViewController alloc]init];
            vc.title = self.titleArr[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 14:
        {
            KeyboardViewController * vc = [[KeyboardViewController alloc]init];
            vc.title = self.titleArr[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 15:
        {
            AlbumViewController * vc = [[AlbumViewController alloc]init];
            vc.title = self.titleArr[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 16:
        {
            ShareToWXViewController * vc = [[ShareToWXViewController alloc]init];
            vc.title = self.titleArr[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 18:
        {
            SwiftViewController * vc = [[SwiftViewController alloc]init];
            vc.title = self.titleArr[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
//        case 20:
//        {
//            AVFViewController * vc = [[AVFViewController alloc]init];
//            vc.title = self.titleArr[indexPath.row];
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//            break;
        default:
        {
            Class myClass = NSClassFromString(self.classArr[indexPath.row]);
            UIViewController * vc = [[myClass alloc] init];
            vc.title = self.titleArr[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
@end
