//
//  PlayerViewController.h
//  HaoChang
//
//  Created by apple on 16/5/26.
//  Copyright © 2016年 zhulei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerViewController : UIViewController

@property (atomic, copy) void (^willCloseBlock)(void);
@property (atomic, copy) void (^didCloseBlock)(void);

@end
