//
//  MainViewController.m
//  HaoChang
//
//  Created by apple on 16/5/15.
//  Copyright © 2016年 zhulei. All rights reserved.
//

#import "MainViewController.h"
#import "TabBarItemButton.h"
#import "MusicHallViewController.h"
#import "DiscoverViewController.h"
#import "MineViewController.h"

@interface MainViewController ()

@property (nonatomic, strong) MusicHallViewController *musicHallVC;
@property (nonatomic, strong) DiscoverViewController *discoverVC;
@property (nonatomic, strong) MineViewController *mineVC;
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
            
            break;
        }
        case 2:
        {
            
            break;
        }
        case 3:
        {
            
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
