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

@interface ViewController ()

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
    navTabBarController.navTabBar_Y = 20 + self.navigationController.toolbar.frame.size.height; // 默认为0
    
    navTabBarController.currentIndex = 2;
    

    navTabBarController.navTabBar_type = YPNavTabBarTypeLine;
    
    navTabBarController.navTabBar_color = [UIColor redColor];
    
    navTabBarController.navTabBarLine_color = [UIColor greenColor];

    navTabBarController.navTabBar_color = [UIColor whiteColor];
    
    navTabBarController.navTabBarLine_color = [UIColor yellowColor];
    
    navTabBarController.navTabBar_normalTitle_color = [UIColor purpleColor];
    
    navTabBarController.navTabBar_selectedTitle_color = [UIColor orangeColor];
    
    navTabBarController.navTabBar_style = YPNavTabBarStyleCenter;
    
    navTabBarController.navTabBar_normalTitle_font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:40];
}

@end
