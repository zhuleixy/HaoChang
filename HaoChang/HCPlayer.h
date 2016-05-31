//
//  HCPlayer.h
//  HaoChang
//
//  Created by apple on 16/5/21.
//  Copyright © 2016年 zhulei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HCPlayer : NSObject

@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) NSTimeInterval currentTime;

+ (instancetype)sharedInstance;

- (void)setSongURL:(NSURL *)songURL;
- (NSURL*)currentSongURL;
- (void)play;
- (void)pause;

- (BOOL)isPlaying;

@end
