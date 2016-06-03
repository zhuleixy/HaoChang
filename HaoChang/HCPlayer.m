//
//  HCPlayer.m
//  HaoChang
//
//  Created by apple on 16/5/21.
//  Copyright © 2016年 zhulei. All rights reserved.
//

#import "HCPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import "ResourceProvider.h"

@interface HCPlayer ()
@property (nonatomic, strong) AVURLAsset *asset;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *currentPlayerItem;
@property (nonatomic, strong) ResourceProvider *resourceProvider;
@property (nonatomic, strong) id playbackTimeObserver;
@property (nonatomic, strong) NSURL *resourceURL;
@property (nonatomic, strong) NSDictionary *resourceCacheInfo;
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
    [self.player removeTimeObserver:self.playbackTimeObserver];
    self.playbackTimeObserver = nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"status"]) {
        if ([self.currentPlayerItem status] == AVPlayerStatusReadyToPlay) {
            [self updateInfo:self.currentPlayerItem];
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
}

- (NSURL*)currentSongURL
{
    return self.resourceURL;
}

- (BOOL)isPlaying
{
    return self.player.rate != 0.f;
}

- (void)play
{
    [self.player play];
}

- (void)pause
{
    [self.player pause];
}

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

@end
