//
//  ThickSlider.m
//  HaoChang
//
//  Created by apple on 16/5/30.
//  Copyright © 2016年 zhulei. All rights reserved.
//

#import "ThickSlider.h"

@implementation ThickSlider

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
    self.maximumTrackTintColor = [UIColor clearColor];
    self.minimumTrackTintColor = [UIColor whiteColor];
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    NSInteger sliderWidth = CGRectGetWidth(self.bounds);
    rect.origin.x = sliderWidth * (self.value / self.maximumValue);
    if (sliderWidth * self.cacheDataPercent > rect.origin.x) {
        rect.size.width = sliderWidth * self.cacheDataPercent - rect.origin.x;
        rect.size.height = 4;
        [[UIColor colorWithWhite:1.0 alpha:0.5] set];
        UIRectFill(rect);
    }
}

-(void)setCacheDataPercent:(float)cacheDataPercent
{
    _cacheDataPercent = cacheDataPercent;
    [self setNeedsDisplay];
}

- (CGRect)trackRectForBounds:(CGRect)bounds
{
    bounds.size.height = 4;
    return bounds;
}

@end
