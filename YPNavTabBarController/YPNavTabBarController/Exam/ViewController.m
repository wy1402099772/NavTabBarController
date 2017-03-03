//
//  ViewController.m
//  YPNavTabBarController
//
//  Created by 胡云鹏 on 15/9/24.
//  Copyright (c) 2015年 MichaelPPP. All rights reserved.
//

#import "ViewController.h"
#import "YPNavTabBarController.h"
#import "YPNavTabBarControllerConst.h"
#import "TestViewController.h"

@interface ViewController () <YPNavTabBarControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    TestViewController* oneVc = [[TestViewController alloc] init];
    oneVc.title = @"test0";
    TestViewController* twoVc = [[TestViewController alloc] init];
    twoVc.title = @"test01";
    TestViewController* threeVc = [[TestViewController alloc] init];
    threeVc.title = @"test10";
    TestViewController* fourVc = [[TestViewController alloc] init];
    fourVc.title = @"test11";
    TestViewController* fiveVc = [[TestViewController alloc] init];
    fiveVc.title = @"test100";

    
    YPNavTabBarController* navTabBarController = [[YPNavTabBarController alloc] initWithParentViewController:self];
    navTabBarController.subViewControllers = @[ oneVc, twoVc, threeVc, fourVc, fiveVc];
    
    navTabBarController.presetSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    navTabBarController.contentViewH = 44; // 默认44
    navTabBarController.navTabBar_Y = self.navigationController.toolbar.frame.size.height + 20; // 默认为0
    
    navTabBarController.navTabBar_type = YPNavTabBarTypeLine;
    
    navTabBarController.lineWidth = 20;
    
    navTabBarController.navTabBar_color = [UIColor grayColor];
    
    navTabBarController.navTabBarLine_color = [UIColor yellowColor];
    
    navTabBarController.navTabBar_normalTitle_color = [UIColor purpleColor];
    
    navTabBarController.navTabBar_selectedTitle_color = [UIColor orangeColor];
    
    navTabBarController.navTabBar_style = YPNavTabBarStyleCenter;
    
    navTabBarController.navTabBar_normalTitle_font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:20];
    
    navTabBarController.navTabBar_selectedTitle_font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:23];
    
    navTabBarController.currentIndex = 1;
    
    navTabBarController.redDotColor = [UIColor colorWithRed:0.3 green:0.2 blue:0.1 alpha:1];
    
    navTabBarController.delegate = self;
    
    for(NSUInteger i = 0; i < navTabBarController.subViewControllers.count; i++) {
        [navTabBarController markRedDotAtIndex:i autoDisappear:YES];
    }
}

#pragma mark - YPNavTabBarControllerDelegate
- (void)ypNavTabBar:(YPNavTabBarController *)control DidScrollToIndex:(NSUInteger)index {
    NSLog(@"Has Reach index : %ld", (long)index);
}

@end
