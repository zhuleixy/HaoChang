//
//  HCPlayer.m
//  HaoChang
//
//  Created by apple on 16/5/21.
//  Copyright © 2016年 zhulei. All rights reserved.
//

#import "HCPlayer.h"

@interface HCPlayer ()
@property (nonatomic, strong) AVURLAsset *asset;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *currentPlayerItem;
@property (nonatomic, strong) ResourceProvider *resourceProvider;
@property (nonatomic, strong) id playbackTimeObserver;
@property (nonatomic, strong) NSURL *resourceURL;
@property (nonatomic, strong) NSDictionary *resourceCacheInfo;
@property (nonatomic, assign) BOOL isBuffering;
@end

@implementation HCPlayer

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static id sharedHCPlayerInstance;
    dispatch_once(&onceToken, ^{
        sharedHCPlayerInstance = [[self alloc] init];
    });
    return sharedHCPlayerInstance;
}

- (instancetype)init
{
    if (self = [super init]) {
        NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        NSString *infoFilePath = [documentPath stringByAppendingPathComponent:@"/cacheInfo"];
        _resourceCacheInfo = [NSDictionary dictionaryWithContentsOfFile:infoFilePath];
    }
    return self;
}

- (void)dealloc
{
    [self.currentPlayerItem removeObserver:self forKeyPath:@"status"];
    [self.currentPlayerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    [self.currentPlayerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [self.currentPlayerItem removeObserver:self forKeyPath:@"playbackBufferFull"];
    [self.currentPlayerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    
    [self.player removeTimeObserver:self.playbackTimeObserver];
    self.playbackTimeObserver = nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"status"]) {
        if ([self.currentPlayerItem status] == AVPlayerStatusReadyToPlay) {
            [self updateInfo:self.currentPlayerItem];
        }
    } else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
        
        NSLog(@"playbackLikelyToKeepUp:%@", self.currentPlayerItem.playbackLikelyToKeepUp ? @"YES" : @"NO");
        
        
    } else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
        
        NSLog(@"playbackBufferEmpty:%@", self.currentPlayerItem.playbackBufferEmpty ? @"YES" : @"NO");
        
        self.isBuffering = YES;
        
    } else if ([keyPath isEqualToString:@"playbackBufferFull"]) {
        
        NSLog(@"playbackBufferFull:%@", self.currentPlayerItem.playbackBufferFull ? @"YES" : @"NO");
        if (self.currentPlayerItem.playbackBufferFull) {
            
            [self play];
            
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        
        if (self.isBuffering) {
            NSArray *loadedTimeRanges = [self.currentPlayerItem loadedTimeRanges];
            CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
            float startSeconds = CMTimeGetSeconds(timeRange.start);
            float durationSeconds = CMTimeGetSeconds(timeRange.duration);
            
            NSLog(@"缓冲进度：%f",startSeconds + durationSeconds);
            if (startSeconds + durationSeconds > CMTimeGetSeconds(self.currentPlayerItem.currentTime) + 10 ||
                startSeconds + durationSeconds >= CMTimeGetSeconds(self.currentPlayerItem.duration)) {
                [self play];
                self.isBuffering = NO;
            }
                
                
//            NSTimeInterval timeInterval = startSeconds + durationSeconds;// 计算缓冲总进度
//            CMTime duration = playerItem.duration;
//            CGFloat totalDuration = CMTimeGetSeconds(duration);
//            self.loadedProgress = timeInterval / totalDuration;
//            [self.videoProgressView setProgress:timeInterval / totalDuration animated:YES];
        }
    }
}

- (void)setSongURL:(NSURL *)songURL;
{
    self.resourceURL = songURL;
    NSString *cacheFileName = [self.resourceCacheInfo objectForKey:[songURL absoluteString]];
    if (cacheFileName) {
        NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        NSString *cacheFilePath = [documentPath stringByAppendingPathComponent:cacheFileName];
        NSURL *localURL = [NSURL fileURLWithPath:cacheFilePath];
        self.asset = [AVURLAsset URLAssetWithURL:localURL options:nil];
        self.currentPlayerItem = [AVPlayerItem playerItemWithAsset:self.asset];
    } else {
        NSURLComponents *components = [[NSURLComponents alloc] initWithURL:songURL resolvingAgainstBaseURL:NO];
        components.scheme = @"streaming";
        NSURL *playUrl = [components URL];
        if (!self.resourceProvider) {
            self.resourceProvider = [[ResourceProvider alloc] init];
            self.resourceProvider.delegate = self;
        }
        self.asset = [AVURLAsset URLAssetWithURL:playUrl options:nil];
        [self.asset.resourceLoader setDelegate:self.resourceProvider queue:dispatch_get_main_queue()];
        self.currentPlayerItem = [AVPlayerItem playerItemWithAsset:self.asset];
    }
    
    if (!self.player) {
        self.player = [AVPlayer playerWithPlayerItem:self.currentPlayerItem];
    } else {
        [self.player replaceCurrentItemWithPlayerItem:self.currentPlayerItem];
    }
    [self.currentPlayerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [self.currentPlayerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
    [self.currentPlayerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
    [self.currentPlayerItem addObserver:self forKeyPath:@"playbackBufferFull" options:NSKeyValueObservingOptionNew context:nil];
    [self.currentPlayerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    
    
    
}

- (NSURL*)currentSongURL
{
    return self.resourceURL;
}

#pragma mark - Play Control

- (void)play
{
    [self.player play];
}

- (void)pause
{
    [self.player pause];
}

- (void)seekToTime:(CMTime)time completionHandler:(void (^)(BOOL finished))completionHandler
{
    
    [self.player seekToTime:time completionHandler:completionHandler];
}

#pragma mark - States

- (BOOL)isPlaying
{
    return self.player.rate != 0.f;
}

#pragma mark - Other

- (void)updateInfo:(AVPlayerItem *)playerItem
{
    self.duration = CMTimeGetSeconds([self.currentPlayerItem duration]);
    __weak typeof(self)weakSelf = self;
    self.playbackTimeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 2)
                                                                          queue:NULL
                                                                     usingBlock:^(CMTime time) {
                                                                         [weakSelf updateCurrentTime:CMTimeGetSeconds([weakSelf.currentPlayerItem currentTime])];
                                                                     }];
}

- (void)updateCurrentTime:(NSTimeInterval)currentTime
{
    [self setValue:@(currentTime) forKey:@"currentTime"];
}

- (void)resourceProvider:(ResourceProvider *)provider receivedDataLengthDidChange:(float)receivedDataLength
{
    self.receivedDataPercent = receivedDataLength / provider.totalDataLength;
}

@end
