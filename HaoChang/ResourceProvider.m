//
//  ResourceProvider.m
//  HaoChang
//
//  Created by apple on 16/5/21.
//  Copyright © 2016年 zhulei. All rights reserved.
//

#import "ResourceProvider.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface ResourceProvider ()
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableArray *pendingRequests;
@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, strong) NSDictionary *resourceCacheInfo;
@property (nonatomic, assign) NSInteger dataLength;
@end

@implementation ResourceProvider

- (instancetype)init
{
    if (self = [super init]) {
        _pendingRequests = [NSMutableArray array];
        _resourceCacheInfo = [NSDictionary dictionaryWithContentsOfFile:[self cacheInfoFilePath]];
    }
    return self;
}

#pragma mark - AVAssetResourceLoaderDelegate

- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest
{
    if (!self.connection) {
        //发起请求
        [self sendRequest:loadingRequest];
    }
    //如果本地已收到数据，试试已有数据能不能满足这次请求
    if (self.receivedData.length > 0) {
        //如果已有数据不能完全满足请求，则加入到待处理队列
        if (![self respondRequest:loadingRequest.dataRequest]) {
            [self.pendingRequests addObject:loadingRequest];
        }
    } else {
        [self.pendingRequests addObject:loadingRequest];
    }
    return YES;
}

- (void)resourceLoader:(AVAssetResourceLoader *)resourceLoader didCancelLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest
{
    [self.pendingRequests removeObject:loadingRequest];
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //获取音频信息
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    NSDictionary *dic = (NSDictionary *)[httpResponse allHeaderFields];
    NSString *content = [dic valueForKey:@"Content-Range"];
    NSArray *array = [content componentsSeparatedByString:@"/"];
    self.dataLength = [array.lastObject integerValue];
    if (self.dataLength == 0) {
        self.dataLength = (NSUInteger)httpResponse.expectedContentLength;
    }
    //将信息填入请求中，模拟服务器回复
    for (AVAssetResourceLoadingRequest *loadingRequest in self.pendingRequests)
    {
        AVAssetResourceLoadingContentInformationRequest *informationRequest = loadingRequest.contentInformationRequest;
        if (informationRequest) {
            NSString *sourceType = @"audio/mpeg";
            CFStringRef contentType = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, (__bridge CFStringRef)(sourceType), NULL);
            informationRequest.byteRangeAccessSupported = YES;
            informationRequest.contentType = CFBridgingRelease(contentType);
            informationRequest.contentLength = self.dataLength;
            break;
        }
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (!self.receivedData) {
        self.receivedData = [NSMutableData data];
    }
    [self.receivedData appendData:data];
    [self processPendingRequests];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (!self.resourceCacheInfo) {
        self.resourceCacheInfo = [NSDictionary dictionary];
    }
    NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithDictionary:self.resourceCacheInfo];
    NSURL *URL = [[connection currentRequest] URL];
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *cacheFileName = [NSString stringWithFormat:@"%@.mp3", [self ret32bitString]];//不加后缀无法播放？？？
    [self.receivedData writeToFile:[documentPath stringByAppendingPathComponent:cacheFileName] atomically:YES];
    [tmpDic setObject:cacheFileName forKey:[URL absoluteString]];
    self.resourceCacheInfo = [NSDictionary dictionaryWithDictionary:tmpDic];
    [self.resourceCacheInfo writeToFile:[self cacheInfoFilePath] atomically:YES];
}

#pragma mark - Private

- (void)sendRequest:(AVAssetResourceLoadingRequest *)loadingRequest
{
    if (self.connection)
        return;
    NSURL *requestURL = [loadingRequest.request URL];
    NSURLComponents *components = [[NSURLComponents alloc] initWithURL:requestURL resolvingAgainstBaseURL:NO];
    components.scheme = @"http";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[components URL] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0];
    [self.connection cancel];
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    [self.connection setDelegateQueue:[NSOperationQueue mainQueue]];
    [self.connection start];
}

- (BOOL)processPendingRequests
{
    NSMutableArray *completeRequest = [NSMutableArray array];
    for (AVAssetResourceLoadingRequest *loadingRequest in self.pendingRequests)
    {
        BOOL isComplete = [self respondRequest:loadingRequest.dataRequest];
        if (isComplete) {
            [completeRequest addObject:loadingRequest];
            [loadingRequest finishLoading];
        }
    }
    [self.pendingRequests removeObjectsInArray:completeRequest];
    return YES;
}

/*
 *  currentOffset与requestedOffset的区别
 *  假定数据总长度100，某个请求的requestedOffset为20，currentOffset为30，requestedLength为50
 *  则本此请求起始位置为20，请求的数据长度为50，先前已通过respondWithData返回了长度为10的数据，因此currentOffset为20＋10＝30
 */
- (BOOL)respondRequest:(AVAssetResourceLoadingDataRequest *)dataRequest
{
    long long offset = dataRequest.currentOffset;//可能之前已经返回部分数据，所以要用currentOffset
    if (dataRequest.currentOffset == 0) {
        offset = dataRequest.requestedOffset;
    }
    if (offset < 0 || offset > self.receivedData.length) {
        return NO;
    }
    
    NSUInteger unreadBytes = self.receivedData.length - ((NSInteger)offset);
    NSUInteger numberOfBytesToRespondWith = MIN((NSUInteger)dataRequest.requestedLength, unreadBytes);
    NSData *respondData = [self.receivedData subdataWithRange:NSMakeRange((NSUInteger)offset, (NSUInteger)numberOfBytesToRespondWith)];
    [dataRequest respondWithData:respondData];
    return dataRequest.currentOffset == dataRequest.requestedOffset + dataRequest.requestedLength;
}

- (NSString *)cacheInfoFilePath
{
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *infoFilePath = [documentPath stringByAppendingPathComponent:@"/cacheInfo"];
    return infoFilePath;
}

- (NSString *)ret32bitString
{
    char data[32];
    for (int x=0;x<32;data[x++] = (char)('A' + (arc4random_uniform(26))));
    return [[NSString alloc] initWithBytes:data length:32 encoding:NSUTF8StringEncoding];
}

@end
