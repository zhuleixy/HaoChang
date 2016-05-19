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
