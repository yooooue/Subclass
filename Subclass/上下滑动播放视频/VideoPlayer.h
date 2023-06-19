//
//  VideoPlayer.h
//  Subclass
//
//  Created by 韩倩云 on 2020/2/18.
//  Copyright © 2020 yy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, VideoPlayerStatus) {
    VideoPlayerStatusUnload = 0,      // 未加载
    VideoPlayerStatusPrepared,    // 准备播放
    VideoPlayerStatusLoading,     // 加载中
    VideoPlayerStatusPlaying,     // 播放中
    VideoPlayerStatusPaused,      // 暂停
    VideoPlayerStatusEnded,       // 播放完成
    VideoPlayerStatusError        // 错误
};

@class VideoPlayer;

@protocol VideoPlayerDelegate <NSObject>

- (void)player:(VideoPlayer *)player staatusChanged:(VideoPlayerStatus)status;

- (void)player:(VideoPlayer *)player currentTime:(float)currentTime totalTime:(float)totalTime progress:(float)progress;

@end

@interface VideoPlayer : UIView

@property (nonatomic,weak) id<VideoPlayerDelegate> delegate;

@property (nonatomic, assign) VideoPlayerStatus status;

- (void)playVideoWithView:(UIView *)playView url:(NSString *)url;

- (void)removeVideo;

- (void)pausePlay;

- (void)resumePlay;

- (void)resetPlay;

@end

NS_ASSUME_NONNULL_END
