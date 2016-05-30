//
//  PlayerViewController.m
//  HaoChang
//
//  Created by apple on 16/5/26.
//  Copyright © 2016年 zhulei. All rights reserved.
//

#import "PlayerViewController.h"

@interface PlayerViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UIView *bottomBarView;

@end

@implementation PlayerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.slider setThumbImage:[UIImage imageNamed:@"play_barmove"] forState:UIControlStateNormal];
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

-(UIStatusBarStyle) preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (IBAction)close:(id)sender
{
    self.willCloseBlock();
    [self dismissViewControllerAnimated:YES completion:self.didCloseBlock];
}

@end
