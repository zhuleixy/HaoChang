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
@property (nonatomic, assign) NSInteger dataLength;
@end

@implementation ResourceProvider

- (instancetype)init
{
    if (self = [super init]) {
        _pendingRequests = [NSMutableArray array];
    }
    return self;
}

#pragma mark - AVAssetResourceLoaderDelegate

- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest
{
    if (self.connection) {
        [self respondPendingRequest];
    }
    [self.pendingRequests addObject:loadingRequest];
    [self requestData:loadingRequest];
    
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
    NSInteger dataLength = [array.lastObject integerValue];
    if (dataLength == 0) {
        dataLength = (NSUInteger)httpResponse.expectedContentLength;
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
            informationRequest.contentLength = dataLength;
        }
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (!self.receivedData) {
        self.receivedData = [NSMutableData data];
    }
    [self.receivedData appendData:data];
    NSLog(@"开始处理请求（from新数据）");
    [self respondPendingRequest];
    
}

#pragma mark - Private

- (void)requestData:(AVAssetResourceLoadingRequest *)loadingRequest
{
    
    if (self.connection)
        return;
    NSURL *requestURL = [loadingRequest.request URL];
    NSURLComponents *components = [[NSURLComponents alloc] initWithURL:requestURL resolvingAgainstBaseURL:NO];
    components.scheme = @"http";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[components URL] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0];
    
    // [request addValue:[NSString stringWithFormat:@"bytes=%ld-%ld",(unsigned long)0, (unsigned long)self.dataLength - 1] forHTTPHeaderField:@"Range"];
    
    [self.connection cancel];
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    [self.connection setDelegateQueue:[NSOperationQueue mainQueue]];
    [self.connection start];
}

- (BOOL)respondPendingRequest
{
    NSMutableArray *completeRequest = [NSMutableArray array];
    for (AVAssetResourceLoadingRequest *loadingRequest in self.pendingRequests)
    {
  
        BOOL isComplete = [self respondWithDataForRequest:loadingRequest.dataRequest];
        if (isComplete) {
            NSLog(@"完成请求：%@", loadingRequest);
            [completeRequest addObject:loadingRequest];
            [loadingRequest finishLoading];
        }
    }
    [self.pendingRequests removeObjectsInArray:completeRequest];
    return YES;
}

- (BOOL)respondWithDataForRequest:(AVAssetResourceLoadingDataRequest *)dataRequest
{
    long long startOffset = dataRequest.requestedOffset;
    startOffset = dataRequest.currentOffset;
    if (startOffset == 0) {
        startOffset = dataRequest.requestedOffset;
    }
    if ((0 +self.receivedData.length) < startOffset)
    {
        //NSLog(@"NO DATA FOR REQUEST");
        return NO;
    }
    
    if (startOffset < 0) {
        return NO;
    }
    NSUInteger unreadBytes = self.receivedData.length - ((NSInteger)startOffset);
    
    // Respond with whatever is available if we can't satisfy the request fully yet
    NSUInteger numberOfBytesToRespondWith = MIN((NSUInteger)dataRequest.requestedLength, unreadBytes);
    
    NSData *respondData = [self.receivedData subdataWithRange:NSMakeRange((NSUInteger)startOffset, (NSUInteger)numberOfBytesToRespondWith)];
    [dataRequest respondWithData:respondData];
    
    long long endOffset = startOffset + dataRequest.requestedLength;
    BOOL didRespondFully = (0 + self.receivedData.length) >= endOffset;
    
    return didRespondFully;
    
}


@end
