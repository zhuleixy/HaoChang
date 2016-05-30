//
//  ThickSlider.m
//  HaoChang
//
//  Created by apple on 16/5/30.
//  Copyright © 2016年 zhulei. All rights reserved.
//

#import "ThickSlider.h"

@implementation ThickSlider

- (CGRect)trackRectForBounds:(CGRect)bounds
{
    bounds.size.height = 4;
    return bounds;
}

@end
