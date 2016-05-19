//
//  Song.h
//  HaoChang
//
//  Created by apple on 16/5/18.
//  Copyright © 2016年 zhulei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Song : NSObject

@property (nonatomic, copy) NSString *singerName;
@property (nonatomic, copy) NSString *songName;
@property (nonatomic, copy) NSString *URL;
@property (nonatomic, copy) NSString *albumCoverURL;
@property (nonatomic, assign) NSInteger score;

//方便本地造假数据，零时使用
@property (nonatomic, strong) UIImage *image;

@end
