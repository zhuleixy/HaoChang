//
//  HCPlayer.h
//  HaoChang
//
//  Created by apple on 16/5/21.
//  Copyright © 2016年 zhulei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "ResourceProvider.h"

@interface HCPlayer : NSObject <ResourceProviderDelegate>

@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) NSTimeInterval currentTime;
@property (nonatomic, assign) float receivedDataPercent;

+ (instancetype)sharedInstance;

- (void)setSongURL:(NSURL *)songURL;
- (NSURL*)currentSongURL;
- (void)play;
- (void)pause;

- (BOOL)isPlaying;
- (void)seekToTime:(CMTime)time completionHandler:(void (^)(BOOL finished))completionHandler;

@end
