//
//  PlayerViewController.m
//  HaoChang
//
//  Created by apple on 16/5/26.
//  Copyright © 2016年 zhulei. All rights reserved.
//

#import "PlayerViewController.h"
#import "MacroDefinition.h"
#import "HCPlayer.h"
#import "ThickSlider.h"

@interface PlayerViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *bottomBarView;
@property (weak, nonatomic) IBOutlet ThickSlider *slider;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) HCPlayer *HCPlayer;
@property (strong, nonatomic) NSObject *playbackTimeObserver;
@property (assign, nonatomic) BOOL isDragingSlider;

@end

@implementation PlayerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
    _HCPlayer = [HCPlayer sharedInstance];
    [self.HCPlayer addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
    [self.HCPlayer addObserver:self forKeyPath:@"currentTime" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
    [self.HCPlayer addObserver:self forKeyPath:@"receivedDataPercent" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    UIImage *image = [self.HCPlayer isPlaying] ? [UIImage imageNamed:@"player_pause"] :
    [UIImage imageNamed:@"player_play"];
    [self.playBtn setImage:image forState:UIControlStateNormal];
}

- (void)initView
{
    //进度条
    [self.slider setThumbImage:[UIImage imageNamed:@"play_barmove"] forState:UIControlStateNormal];
    [self.slider addTarget:self action:@selector(playSliderChange:) forControlEvents:UIControlEventValueChanged]; //拖动滑竿更新时间
    [self.slider addTarget:self action:@selector(playSliderChangeEnd:) forControlEvents:UIControlEventTouchUpInside];  //松手,滑块拖动停止
    [self.slider addTarget:self action:@selector(playSliderChangeEnd:) forControlEvents:UIControlEventTouchUpOutside];
    [self.slider addTarget:self action:@selector(playSliderChangeEnd:) forControlEvents:UIControlEventTouchCancel];
    //scrollView
    CGRect contentFrame = self.contentView.frame;
    contentFrame.size.width = kDeviceWidth;
    self.contentView.frame = contentFrame;
    [self.scrollView addSubview:self.contentView];
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.contentView.bounds), CGRectGetHeight(self.contentView.bounds));
    //添加分割线
    CGFloat btnSpacing = CGRectGetWidth([UIScreen mainScreen].bounds) / 3;
    CGFloat splitLineHeight = 20;
    CGFloat splitLineFrameY = (CGRectGetHeight(self.bottomBarView.bounds) - splitLineHeight) / 2;
    for (int i = 0; i < 2; i++)
    {
        CALayer *splitLine = [[CALayer alloc] init];
        splitLine.backgroundColor = [UIColor colorWithWhite:0.5 alpha:1].CGColor;
        splitLine.frame = CGRectMake(btnSpacing * (i + 1), splitLineFrameY, 0.5, splitLineHeight);
        [self.bottomBarView.layer addSublayer:splitLine];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"duration"]) {
        [self.slider setMaximumValue:self.HCPlayer.duration];
    } else if ([keyPath isEqualToString:@"currentTime"]) {
        if (!self.isDragingSlider) {
            [self.slider setValue:self.HCPlayer.currentTime animated:YES];
        }
    } else if ([keyPath isEqualToString:@"receivedDataPercent"]) {
        [self.slider setCacheDataPercent:self.HCPlayer.receivedDataPercent];
        [self.slider setNeedsDisplay];
    }
}

- (UIStatusBarStyle) preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Seek

//手指结束拖动，播放器从当前点开始播放，开启滑竿的时间走动
- (void)playSliderChangeEnd:(UISlider *)slider
{
    self.isDragingSlider = NO;
    [self seekToTime:slider.value];
}

//手指正在拖动，播放器继续播放，但是停止滑竿的时间走动
- (void)playSliderChange:(UISlider *)slider
{
    self.isDragingSlider = YES;
    // [self updateCurrentTime:slider.value];
}

- (void)seekToTime:(CGFloat)seconds
{
    if (!self.HCPlayer.isPlaying) {
        return;
    }
    seconds = MAX(0, seconds);
    seconds = MIN(seconds, self.HCPlayer.duration);
    if ((seconds / self.HCPlayer.duration) > self.HCPlayer.receivedDataPercent) {
        return;
    }
    [self.HCPlayer pause];
    [self.HCPlayer seekToTime:CMTimeMakeWithSeconds(seconds, NSEC_PER_SEC) completionHandler:^(BOOL finished) {
        [self.HCPlayer play];
    }];
}

#pragma mark - Action

- (IBAction)close:(id)sender
{
    self.willCloseBlock();
    [self dismissViewControllerAnimated:YES completion:self.didCloseBlock];
}

- (IBAction)play:(id)sender
{
    if (self.HCPlayer.isPlaying) {
        [self.HCPlayer pause];
        [self.playBtn setImage:[UIImage imageNamed:@"play_play"] forState:UIControlStateNormal];
    } else {
        if (![self.HCPlayer currentSongURL]) {
            NSURL *songURL = [NSURL URLWithString:@"http://up.haoduoge.com/mp3/2016-06-05/1465110357.mp3"];
            [self.HCPlayer setSongURL:songURL];
        }
        [self.HCPlayer play];
        [self.playBtn setImage:[UIImage imageNamed:@"play_pause"] forState:UIControlStateNormal];
    }
}
@end
