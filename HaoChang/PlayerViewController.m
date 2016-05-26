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

@end

@implementation PlayerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView addSubview:self.contentView];
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.contentView.bounds), CGRectGetHeight(self.contentView.bounds));
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
