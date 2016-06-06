//
//  PlayControlViewController.m
//  HaoChang
//
//  Created by apple on 16/5/20.
//  Copyright © 2016年 zhulei. All rights reserved.
//

#import "PlayControlViewController.h"
#import "UIImage+RoundedCorner.h"
#import "MacroDefinition.h"
#import "HCPlayer.h"

@interface PlayControlViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) HCPlayer *HCPlayer;
@end

@implementation PlayControlViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _HCPlayer = [HCPlayer sharedInstance];
    UIImage *coverImage = [UIImage imageNamed:@"albumArt5"];
    CGSize imageSize = coverImage.size;
    self.coverImageView.image = [coverImage roundedCornerImageWithCornerRadius:imageSize.width / 2];
    
    [self.slider setValue:0];
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showPlayer)];
    [self.view addGestureRecognizer:tapGesture];
    [self.HCPlayer addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
    [self.HCPlayer addObserver:self forKeyPath:@"currentTime" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    UIImage *image = [self.HCPlayer isPlaying] ? [UIImage imageNamed:@"player_pause"] :
                                                 [UIImage imageNamed:@"player_play"];
    [self.playBtn setImage:image forState:UIControlStateNormal];
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)showPlayer
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNamePlaySong object:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"duration"]) {
        [self.slider setMaximumValue:self.HCPlayer.duration];
    } else if ([keyPath isEqualToString:@"currentTime"]) {
        [self.slider setValue:self.HCPlayer.currentTime animated:YES];
    }
}

- (IBAction)play:(id)sender
{
    if (self.HCPlayer.isPlaying) {
        [self.HCPlayer pause];
        [self.playBtn setImage:[UIImage imageNamed:@"player_play"] forState:UIControlStateNormal];
    } else {
        if (![self.HCPlayer currentSongURL]) {
            NSURL *songURL = [NSURL URLWithString:@"http://up.haoduoge.com/mp3/2016-06-05/1465110357.mp3"];
            [self.HCPlayer setSongURL:songURL];
        }
        [self.HCPlayer play];
        [self.playBtn setImage:[UIImage imageNamed:@"player_pause"] forState:UIControlStateNormal];
    }
}

- (IBAction)list:(id)sender
{
}
@end
