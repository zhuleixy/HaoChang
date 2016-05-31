//
//  playControlBarSlider.m
//  HaoChang
//
//  Created by apple on 16/5/31.
//  Copyright © 2016年 zhulei. All rights reserved.
//

#import "playControlBarSlider.h"

@implementation playControlBarSlider

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self initView];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    [self initView];
    return self;
}

-(void)initView
{
    UIImage *thumbImage = [[UIImage alloc] init];
    [self setThumbImage:thumbImage forState:UIControlStateNormal];
}

- (CGRect)trackRectForBounds:(CGRect)bounds
{
    bounds.size.height = 2;
    return bounds;
}

@end
