//
//  ScoreLabel.m
//  HaoChang
//
//  Created by apple on 16/5/19.
//  Copyright © 2016年 zhulei. All rights reserved.
//

#import "ScoreLabel.h"

@implementation ScoreLabel

- (CGSize)intrinsicContentSize
{
    CGSize size = [super intrinsicContentSize];
    size.width += 6; //两边圆角预留宽度
    return size;
}

@end
