//
//  AlbumViewController.m
//  Subclass
//
//  Created by 韩倩云 on 2020/7/20.
//  Copyright © 2020 yy. All rights reserved.
//

#import "AlbumViewController.h"
#import "ImagePickerViewController.h"
#import "HXPhotoManager.h"
#import "HXPhotoView.h"
#import "HXCustomNavigationController.h"
#import "Subclass-Swift.h"
#import <AVFoundation/AVFoundation.h>

@interface AlbumViewController ()<ImagePickerControllerDelegate,HXPhotoViewDelegate,HXCustomNavigationControllerDelegate>

@property (nonatomic, strong) HXPhotoManager * manager;

@end

@implementation AlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
        
    HXPhotoView * photoView = [[HXPhotoView alloc]initWithFrame:self.view.bounds manager:self.manager];
    photoView.delegate = self;
    photoView.frame = CGRectMake(0, 12, self.view.width, 0);
    photoView.collectionView.contentInset = UIEdgeInsetsMake(0, 12, 0, 12);
//    photoView.spacing = kPhotoViewMargin;
//    photoView.lineCount = 1;
    photoView.delegate = self;
//    photoView.cellCustomProtocol = self;
    photoView.outerCamera = YES;
    photoView.previewStyle = HXPhotoViewPreViewShowStyleDark;
    photoView.previewShowDeleteButton = YES;
    photoView.showAddCell = YES;
//    photoView.showDeleteNetworkPhotoAlert = YES;
//    photoView.adaptiveDarkness = NO;
//    photoView.previewShowBottomPageControl = NO;
    [photoView.collectionView reloadData];
//    [photoView refreshView];
    [self.view addSubview:photoView];
    
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"选择照片" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(selectPhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)photoNavigationViewController:(HXCustomNavigationController *)photoNavigationViewController didDoneAllList:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photoList videos:(NSArray<HXPhotoModel *> *)videoList original:(BOOL)original {
    if (@available(iOS 13.0, *)) {
        EditVideoViewController * editVC = [EditVideoViewController new];
        NSMutableArray * mArr = [NSMutableArray<NSURL *> array];
        for (HXPhotoModel * model in videoList) {
            [mArr addObject:model.videoURL];
        }
        editVC.videoArr = mArr;
        [self.navigationController pushViewController:editVC animated:YES];
    } else {
        // Fallback on earlier versions
    }
    
}

- (void)selectPhoto {
    HXCustomNavigationController *nav = [[HXCustomNavigationController alloc] initWithManager:self.manager delegate:self];
    [self presentViewController:nav animated:YES completion:nil];
//    ImagePickerViewController * pickerVC = [[ImagePickerViewController alloc]initWithMaxImagesCount:10 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
//    pickerVC.modalPresentationStyle = UIModalPresentationFullScreen;
//    [self presentViewController:pickerVC animated:YES completion:nil];
}

- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc]initWithType:HXPhotoManagerSelectedTypePhotoAndVideo];
        _manager.configuration.videoMaxNum = 2;
        _manager.configuration.requestImageAfterFinishingSelection = YES;
        _manager.configuration.albumShowMode = HXPhotoAlbumShowModePopup;
    }
    return _manager;
}
@end
