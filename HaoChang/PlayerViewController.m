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

@interface PlayerViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *bottomBarView;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) HCPlayer *HCPlayer;
@property (strong, nonatomic) NSObject *playbackTimeObserver;

@end

@implementation PlayerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
    _HCPlayer = [HCPlayer sharedInstance];
    [self.HCPlayer addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
    [self.HCPlayer addObserver:self forKeyPath:@"currentTime" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
}

- (void)initView
{
    //进度条
    [self.slider setThumbImage:[UIImage imageNamed:@"play_barmove"] forState:UIControlStateNormal];
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
        [self.slider setValue:self.HCPlayer.currentTime animated:YES];
    }
}

- (UIStatusBarStyle) preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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
            NSURL *songURL = [NSURL URLWithString:@"http://sc1.111ttt.com/2016/5/02/25/195251254501.mp3"];
            [self.HCPlayer setSongURL:songURL];
        }
        [self.HCPlayer play];
        [self.playBtn setImage:[UIImage imageNamed:@"play_pause"] forState:UIControlStateNormal];
    }
}
@end
