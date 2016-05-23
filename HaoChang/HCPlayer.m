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

- (void)playWithURL:(NSURL *)songURL
{
    NSURLComponents *components = [[NSURLComponents alloc] initWithURL:songURL resolvingAgainstBaseURL:NO];
    components.scheme = @"streaming";
    NSURL *playUrl = [components URL];
    if (!self.resourceProvider) {
        self.resourceProvider = [[ResourceProvider alloc] init];
    }
    self.asset = [AVURLAsset URLAssetWithURL:playUrl options:nil];
    [self.asset.resourceLoader setDelegate:self.resourceProvider queue:dispatch_get_main_queue()];
    self.currentPlayerItem = [AVPlayerItem playerItemWithAsset:self.asset];
    if (!self.player) {
        self.player = [AVPlayer playerWithPlayerItem:self.currentPlayerItem];
    } else {
        [self.player replaceCurrentItemWithPlayerItem:self.currentPlayerItem];
    }
    
    [self.player play];

}

@end
