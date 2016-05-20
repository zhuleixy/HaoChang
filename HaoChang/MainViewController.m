//
//  MainViewController.m
//  HaoChang
//
//  Created by apple on 16/5/15.
//  Copyright © 2016年 zhulei. All rights reserved.
//

#import "MainViewController.h"
#import "TabBarItemButton.h"
#import "MacroDefinition.h"

@interface MainViewController ()

@property (nonatomic, strong) UIViewController *musicHallInitialVC;
@property (nonatomic, strong) UIViewController *discoverInitialVC;
@property (nonatomic, strong) UIViewController *mineInitialVC;
@property (nonatomic, strong) TabBarItemButton *currentSelectedButton;
@property (weak, nonatomic) IBOutlet TabBarItemButton *musicHallBtn;

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
    //选中乐馆
    [self.musicHallBtn setSelected:YES];
    [self onTabBarButtonClicked:self.musicHallBtn];
}

- (void)viewWillLayoutSubviews
{
    CGRect tabFrame = self.tabBar.frame;
    tabFrame.size.height = BOTTOM_BAR_HEIGHT;//改成与底栏高度相同，这样tabbar下的VC都不同再设置contentInset
    tabFrame.origin.y = self.view.frame.size.height;
    self.tabBar.frame = tabFrame;
}

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
    [self setHidesBottomBarWhenPushed:NO];
    UIViewController *VC = [[UIViewController alloc] init];
    VC.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:VC animated:YES];
    
    //[self presentViewController:VC animated:YES completion:nil];
}

- (IBAction)showMessage:(id)sender
{
    
}
@end
