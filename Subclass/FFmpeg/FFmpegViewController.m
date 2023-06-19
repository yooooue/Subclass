//
//  FFmpegViewController.m
//  Subclass
//
//  Created by 韩倩云 on 2023/5/6.
//  Copyright © 2023 yy. All rights reserved.
//

#import "FFmpegViewController.h"
#import "AVParseHandler.h"

#ifdef __cplusplus
extern "C" {
#endif
    
#include "libavformat/avformat.h"
#include "libavcodec/avcodec.h"
#include "libavutil/avutil.h"
#include "libswscale/swscale.h"
#include "libswresample/swresample.h"
#include "libavutil/opt.h"
    
#ifdef __cplusplus
};
#endif

@interface FFmpegViewController ()

@end

@implementation FFmpegViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)clickBtn:(id)sender {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"MOV"];
        
    AVParseHandler *parseHandler = [[AVParseHandler alloc] initWithPath:path];
        
    [parseHandler startParseGetAVPackeWithCompletionHandler:^(BOOL isVideoFrame, BOOL isFinish, AVPacket packet) {
            
        if (isFinish) {
              
            NSLog(@"Parse finish!");
               
            return;
        }
            
        if (isVideoFrame) {
                
        }else {
                
        }
    }];
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
