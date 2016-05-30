//
//  CollectionHeaderViewController.m
//  HaoChang
//
//  Created by apple on 16/5/19.
//  Copyright © 2016年 zhulei. All rights reserved.
//

#import "CollectionHeaderViewController.h"
#import "BannerView.h"

@interface CollectionHeaderViewController ()

@property (nonatomic, strong) BannerView *bannerView;
@property (weak, nonatomic) IBOutlet UIView *btnContainerView;

@end

@implementation CollectionHeaderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
}

- (void)initView
{
    _bannerView = [[BannerView alloc] init];
    [self.view addSubview:self.bannerView];
    [self makeConstraint];
    
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:3];
    [imageArray addObject:[UIImage imageNamed:@"banner1"]];
    [imageArray addObject:[UIImage imageNamed:@"banner2"]];
    [imageArray addObject:[UIImage imageNamed:@"banner3"]];
 
    [self.bannerView performSelector:@selector(setImageArray:) withObject:[NSArray arrayWithArray:imageArray] afterDelay:1];
    //[self.bannerView setImageArray:imageArray];
    
    //添加分割线
    CGFloat btnSpacing = CGRectGetWidth([UIScreen mainScreen].bounds) / 4;
    CGFloat splitLineHeight = 20;
    CGFloat splitLineFrameY = (CGRectGetHeight(self.btnContainerView.bounds) - splitLineHeight) / 2;
    for (int i = 0; i < 3; i++)
    {
        CALayer *splitLine = [[CALayer alloc] init];
        splitLine.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
        splitLine.frame = CGRectMake(btnSpacing * (i + 1), splitLineFrameY, 0.5, splitLineHeight);
        [self.btnContainerView.layer addSublayer:splitLine];
    }
}

- (void)makeConstraint
{
    [self.bannerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSArray *bannerViewH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[bannerView]-(0)-|" options:0 metrics:nil views:@{@"bannerView": self.bannerView}];
    [self.view addConstraints:bannerViewH];
    
    NSArray *bannerViewV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[bannerView]-(>=0)-|" options:0 metrics:nil views:@{@"bannerView": self.bannerView}];
    [self.view addConstraints:bannerViewV];
    
    NSLayoutConstraint *bannerViewHeight = [NSLayoutConstraint constraintWithItem:self.bannerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.bannerView attribute:NSLayoutAttributeWidth multiplier:0.46875 constant:0];
    [self.view addConstraint:bannerViewHeight];
}


@end
