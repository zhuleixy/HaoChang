//
//  SongCollectionViewCell.m
//  HaoChang
//
//  Created by apple on 16/5/18.
//  Copyright © 2016年 zhulei. All rights reserved.
//

#import "SongCollectionViewCell.h"
#import<QuartzCore/QuartzCore.h>
#import "ScoreLabel.h"

@implementation SongCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self makeConstraint];
    }
    return self;
}

- (void)initView
{
    _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.imageView];
    
    _scoreLabel = [[ScoreLabel alloc] initWithFrame:CGRectZero];
    [self.scoreLabel setTextColor:[UIColor whiteColor]];
    [self.scoreLabel setFont:[UIFont systemFontOfSize:10]];
    [self.scoreLabel setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.5]];
    [self.scoreLabel setTextAlignment:NSTextAlignmentCenter];
    [self.scoreLabel.layer setCornerRadius:6.0];
    [self.scoreLabel.layer setMasksToBounds:YES];
    [self addSubview:self.scoreLabel];
    
    _singerNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.singerNameLabel setTextColor:[UIColor whiteColor]];
    [self.singerNameLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [self addSubview:self.singerNameLabel];
    
    _songNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.songNameLabel setTextColor:[UIColor whiteColor]];
    [self.songNameLabel setFont:[UIFont systemFontOfSize:13]];
    [self addSubview:self.songNameLabel];
}

- (void)makeConstraint
{
    [self.imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.songNameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.singerNameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.scoreLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSDictionary *viewDic = @{@"imageView": self.imageView,
                              @"songNameLabel": self.songNameLabel,
                              @"singerNameLabel": self.singerNameLabel,
                              @"scoreLabel": self.scoreLabel};
    //背景图
    NSArray *imageViewH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[imageView]-(0)-|" options:0 metrics:nil views:viewDic];
    NSArray *imageViewV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[imageView]-(0)-|" options:0 metrics:nil views:viewDic];
    [self addConstraints:imageViewH];
    [self addConstraints:imageViewV];
    //得分
    NSArray *scoreLabelH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=0)-[scoreLabel]-(8)-|" options:0 metrics:nil views:viewDic];
    NSArray *scoreLabelV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(5)-[scoreLabel]-(>=0)-|" options:0 metrics:nil views:viewDic];
    [self addConstraints:scoreLabelH];
    [self addConstraints:scoreLabelV];
    //歌曲名称
    NSArray *songNameLabelH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(5)-[songNameLabel]-(0)-|" options:0 metrics:nil views:viewDic];
    NSArray *songNameLabelV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=0)-[songNameLabel]-(5)-|" options:0 metrics:nil views:viewDic];
    [self addConstraints:songNameLabelH];
    [self addConstraints:songNameLabelV];
    //歌手
    NSArray *singerNameLabelH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(5)-[singerNameLabel]-(0)-|" options:0 metrics:nil views:viewDic];
    NSArray *singerNameLabelV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=0)-[singerNameLabel]-(3)-[songNameLabel]" options:0 metrics:nil views:viewDic];
    [self addConstraints:singerNameLabelH];
    [self addConstraints:singerNameLabelV];
}

@end
