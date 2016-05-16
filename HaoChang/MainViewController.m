//
//  MainViewController.m
//  HaoChang
//
//  Created by apple on 16/5/15.
//  Copyright © 2016年 zhulei. All rights reserved.
//

#import "MainViewController.h"
#import "TabBarItemButton.h"


@interface MainViewController ()

@property (nonatomic, strong) UIViewController *musicHallInitialVC;
@property (nonatomic, strong) UIViewController *discoverInitialVC;
@property (nonatomic, strong) UIViewController *mineInitialVC;
@property (nonatomic, strong) TabBarItemButton *currentSelectedButton;

@end

@implementation MainViewController

-(void)viewDidLoad
{
    [self initNavigationBarItem];
    [self initView];
}

- (void)initNavigationBarItem
{
    //右侧选歌按钮
    UIButton *selectSongsbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *bgImage = [UIImage imageNamed:@"homepage_record.png"];
    selectSongsbutton.frame = CGRectMake(0, 0, bgImage.size.width, bgImage.size.height);
    [selectSongsbutton setBackgroundImage:bgImage forState:UIControlStateNormal];
    [selectSongsbutton addTarget:self action:@selector(selectSongs:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:selectSongsbutton];
    self.navigationItem.rightBarButtonItem = rightItem;
    //左侧通知按钮
    UIButton *messagebutton = [UIButton buttonWithType:UIButtonTypeCustom];
    bgImage = [UIImage imageNamed:@"homepage_notice.png"];
    messagebutton.frame = CGRectMake(0, 0, bgImage.size.width, bgImage.size.height);
    [messagebutton setBackgroundImage:bgImage forState:UIControlStateNormal];
    [messagebutton addTarget:self action:@selector(showMessage:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:messagebutton];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)initView
{
   
    
}

#pragma mark - Setter & Gatter



#pragma mark - Action

- (IBAction)onTabBarButtonClicked:(TabBarItemButton *)sender
{
    self.currentSelectedButton.selected = NO;
    sender.selected = YES;
    self.currentSelectedButton = sender;
    
    switch (sender.tag) {
        case 1:
        {
            if (!self.musicHallInitialVC) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"MusicHall" bundle:nil];
                _musicHallInitialVC = [storyboard instantiateInitialViewController];
                [self addChildViewController:self.musicHallInitialVC];
            }
            [self setSelectedViewController:self.musicHallInitialVC];
            break;
        }
        case 2:
        {
            if (!self.discoverInitialVC) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Discover" bundle:nil];
                _discoverInitialVC = [storyboard instantiateInitialViewController];
                [self addChildViewController:self.discoverInitialVC];
            }
            [self setSelectedViewController:self.discoverInitialVC];
            break;
            break;
        }
        case 3:
        {
            if (!self.mineInitialVC) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Mine" bundle:nil];
                _mineInitialVC = [storyboard instantiateInitialViewController];
                [self addChildViewController:self.mineInitialVC];
            }
            [self setSelectedViewController:self.mineInitialVC];
            break;
            break;
        }
        default:
            break;
    }
}

- (IBAction)selectSongs:(id)sender
{
    
}

- (IBAction)showMessage:(id)sender
{
    
}
@end
