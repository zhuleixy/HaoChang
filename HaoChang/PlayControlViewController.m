//
//  PlayControlViewController.m
//  HaoChang
//
//  Created by apple on 16/5/20.
//  Copyright © 2016年 zhulei. All rights reserved.
//

#import "PlayControlViewController.h"
#import "UIImage+RoundedCorner.h"

@interface PlayControlViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;

@end

@implementation PlayControlViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *coverImage = [UIImage imageNamed:@"albumArt5"];
    CGSize imageSize = coverImage.size;
    self.coverImageView.image = [coverImage roundedCornerImageWithCornerRadius:imageSize.width / 2];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}



@end
