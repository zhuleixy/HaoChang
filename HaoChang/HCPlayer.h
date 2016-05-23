//
//  HCPlayer.h
//  HaoChang
//
//  Created by apple on 16/5/21.
//  Copyright © 2016年 zhulei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HCPlayer : NSObject

+ (instancetype)sharedInstance;

- (void)playWithURL:(NSURL *)songURL;

@end
