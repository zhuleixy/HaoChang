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
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
    [self.pageControl setCurrentPageIndicatorTintColor:[UIColor redColor]];
    [self.pageControl setPageIndicatorTintColor:[UIColor whiteColor]];
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
    [self addConstraints:pageControlH];
    NSArray *pageControlV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=0)-[pageControl(32)]-(0)-|" options:0 metrics:nil views:viewDic];
    [self addConstraints:pageControlV];
    NSLayoutConstraint *pageControlCenter = [NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    [self addConstraint:pageControlCenter];
    
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
    self.currentPage = 0;
    self.totalPage = imageArray.count - 1;
    self.pageControl.numberOfPages = self.totalPage + 1;
    self.pageControl.currentPage = self.currentPage;
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.bounds) *  imageArray.count, CGRectGetHeight(self.scrollView.bounds));
}

#pragma mark - UIScrollViewDelegate
//同步pageControl红点
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int currentPage = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;//当前是第几个视图
    self.pageControl.currentPage = currentPage;
    self.currentPage = currentPage;
}

#pragma mark - Pravite

- (void)switchBanner
{
    if (self.currentPage == self.totalPage) {
        self.moveRight = YES;
    } else if (self.currentPage == 0) {
        self.moveRight = NO;
    }
    
    if (self.moveRight) {
        self.currentPage--;
    } else {
        self.currentPage++;
    }
    
    CGFloat offsetX = self.currentPage * CGRectGetWidth(self.scrollView.bounds);
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = offsetX;
    [self.scrollView setContentOffset:offset animated:YES];
}



@end
