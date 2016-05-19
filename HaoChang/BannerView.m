//
//  BannerView.m
//  HaoChang
//
//  Created by apple on 16/5/19.
//  Copyright © 2016年 zhulei. All rights reserved.
//

#import "BannerView.h"

@interface BannerView ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger totalPage;
@property (nonatomic, assign) BOOL moveRight;

@end

@implementation BannerView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.scrollView];
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
    [self addSubview:self.pageControl];
    [self makeConstraint];
    
    self.timer = [NSTimer timerWithTimeInterval:3
                                         target:self
                                       selector:@selector(switchBanner)
                                       userInfo:nil
                                        repeats:YES];
    [[NSRunLoop  currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    // [self.timer setFireDate:[NSDate distantFuture]];//关闭定时器
}

- (void)makeConstraint
{
    [self.scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.pageControl setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSDictionary *viewDic = @{@"scrollView": self.scrollView,
                              @"pageControl": self.pageControl};
    //scrollView
    NSArray *scrollViewH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[scrollView]-(0)-|" options:0 metrics:nil views:viewDic];
    NSArray *scrollViewV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[scrollView]-(0)-|" options:0 metrics:nil views:viewDic];
    [self addConstraints:scrollViewH];
    [self addConstraints:scrollViewV];
    //pageControl
    NSArray *pageControlH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[pageControl]-(0)-|" options:0 metrics:nil views:viewDic];
    NSArray *pageControlV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=0)-[pageControl]-(0)-|" options:0 metrics:nil views:viewDic];
    [self addConstraints:pageControlH];
    [self addConstraints:pageControlV];
    
}

- (void)setImageArray:(NSArray *)imageArray
{
    for (UIView *view in self.scrollView.subviews)
    {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    for (int i = 0; i < imageArray.count; i++)
    {
        UIImage *image = imageArray[i];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        CGRect imageViewFrame = self.bounds;
        imageViewFrame.origin.x = i * CGRectGetWidth(self.bounds);
        imageView.frame = imageViewFrame;
        imageView.tag = i;
        [self.scrollView addSubview:imageView];
    }
    self.currentPage = 1;
    self.totalPage = imageArray.count;
}

- (void)switchBanner
{
    if (self.currentPage == self.totalPage) {
        self.moveRight = YES;
    } else if (self.currentPage == 1) {
        self.moveRight = NO;
    }
    
    if (self.moveRight) {
        self.currentPage--;
    } else {
        self.currentPage++;
    }
    
    CGFloat offsetX = (self.currentPage - 1) * CGRectGetWidth(self.scrollView.bounds);
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = offsetX;
    [self.scrollView setContentOffset:offset animated:YES];
}

@end
