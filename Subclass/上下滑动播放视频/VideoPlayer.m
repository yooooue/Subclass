//
//  VideoPlayer.m
//  Subclass
//
//  Created by 韩倩云 on 2020/2/18.
//  Copyright © 2020 yy. All rights reserved.
//

#import "VideoPlayer.h"
#import "TXVodPlayer.h"
#import "TXLiveBase.h"
// 引入头文件
//#import <SuperPlayer/SuperPlayer.h>

@interface VideoPlayer ()<TXVodPlayListener>

@property (nonatomic, strong) TXVodPlayer * player;

//@property (nonatomic, strong) SuperPlayerView * sPlayer;

@end

@implementation VideoPlayer

- (void)playVideoWithView:(UIView *)playView url:(NSString *)url {
//    SuperPlayerModel * model = [[SuperPlayerModel alloc]init];
//    model.videoURL = @"https://v3f.imacco.com/Web/Assert/InfoVideo/Info000179946/cf562eab640b4cf1b24d2e7aa2a6d04b.mp4";
//    [self.sPlayer playWithModel:model];
//    self.sPlayer.fatherView = playView;
    [self.player setupVideoWidget:playView insertIndex:0];

    [self playerStatusChageed:VideoPlayerStatusPrepared];
    [self.player startPlay:@"https://v3f.imacco.com/Web/Assert/InfoVideo/Info000029904/bf12f760a5fe4c478d08e92b56c30469.mp4"];
}

- (void)removeVideo {
//    [self.sPlayer setState:StateStopped];
    [self.player stopPlay];
    [self.player removeVideoWidget];
    
    [self playerStatusChageed:VideoPlayerStatusUnload];
}

- (void)pausePlay {
    [self playerStatusChageed:VideoPlayerStatusPaused];
    [self.player pause];
//    [self.sPlayer setState:StatePause];
}

- (void)resumePlay {
    if (self.status == VideoPlayerStatusPaused) {
        [self.player resume];
        [self playerStatusChageed:VideoPlayerStatusPlaying];
    }
}

- (void)resetPlay {
//    [self.sPlayer setState:State];
    [self.player resume];
    [self playerStatusChageed:VideoPlayerStatusPlaying];
}

- (void)playerStatusChageed:(VideoPlayerStatus)status {
    self.status = status;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(player:staatusChanged:)]) {
        [self.delegate player:self staatusChanged:status];
    }
}

#pragma mark -TXVodPlayListener
- (void)onPlayEvent:(TXVodPlayer *)player event:(int)EvtID withParam:(NSDictionary *)param {

}

- (void)onNetStatus:(TXVodPlayer *)player withParam:(NSDictionary *)param {

}

#pragma mark -懒加载
- (TXVodPlayer *)player {
    if (!_player) {
        TXVodPlayConfig *config    = [[TXVodPlayConfig alloc] init];
        config.smoothSwitchBitrate = YES;
//        if (self.playerConfig.maxCacheItem) {
            // https://github.com/tencentyun/SuperPlayer_iOS/issues/64
            config.cacheFolderPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"/TXCache"];
            config.maxCacheItems   = 5;
//        }
        config.progressInterval = 0.02;
        [TXLiveBase setLogLevel:LOGLEVEL_NULL];
        [TXLiveBase setConsoleEnabled:NO];

        _player = [TXVodPlayer new];
        [_player setConfig:config];
        _player.vodDelegate = self;
        [_player setRenderMode:RENDER_MODE_FILL_EDGE];
    }
    return _player;
}

//- (SuperPlayerView *)sPlayer {
//    if (!_sPlayer) {
//        _sPlayer = [[SuperPlayerView alloc]init];
////        _player.delegate = self;
//    }
//    return _sPlayer;
//}
@end
