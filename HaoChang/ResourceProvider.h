//
//  ResourceProvider.h
//  HaoChang
//
//  Created by apple on 16/5/21.
//  Copyright © 2016年 zhulei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@class ResourceProvider;

@protocol ResourceProviderDelegate <NSObject>

- (void)resourceProvider:(ResourceProvider *)provider receivedDataLengthDidChange:(float)receivedDataLength;

@end


/**
 *  ResourceProvider用于缓存服务器数据
 *
 *  （1）通常情况下，播放器发出一个或多个请求向服务器分段请求数据，服务器直接将数据返回给播放器
 *  （2）设置播放器代理后，播放器向ResourceProvider要数据，ResourceProvider截获播放器的请求，并解析出URL，
 *  通过NSURLConnection去向服务器请求数据, 服务器先将数据（音频／视频）长度类型等信息返回给ResourceProvider，
 *  ResourceProvider将这些信息填入第一个请求并返回给播放器，之后服务器将数据返回给ResourceProvider，
 *  ResourceProvider缓存到NSData后再返回给播放器
 */

@interface ResourceProvider : NSObject <AVAssetResourceLoaderDelegate, NSURLConnectionDataDelegate>

@property (nonatomic, readonly) float totalDataLength;
@property (weak) id <ResourceProviderDelegate> delegate;

@end
