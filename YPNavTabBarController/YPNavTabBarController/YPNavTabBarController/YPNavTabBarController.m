//
//  YPNavTabBarController.m
//  YPNavTabBarController
//
//  Created by 胡云鹏 on 15/9/24.
//  Copyright (c) 2015年 MichaelPPP. All rights reserved.
//

#import "YPNavTabBarController.h"
#import "YPNavTabBarControllerConst.h"
#import <objc/runtime.h>

@interface UIViewController ()

@property (nonatomic, strong, readwrite) YPNavTabBarController* navTabBarController;

@end

@interface YPNavTabBarController () <YPNavTabBarDelegate, UIScrollViewDelegate>

/** 选项标题数组 */
@property (nonatomic, strong) NSMutableArray* titles;

/** 滚动主视图 */
@property (nonatomic, weak) UIScrollView* mainView;

/** 开始拖动时的偏移量 */
@property (nonatomic, assign) CGFloat startContentOffsetX;

@end

@implementation YPNavTabBarController

@synthesize navTabBar_normalTitle_font = _navTabBar_normalTitle_font;
@synthesize navTabBar_selectedTitle_font = _navTabBar_selectedTitle_font;

#pragma mark - 初始化

- (void)addParentController:(UIViewController*)viewController
{
    viewController.automaticallyAdjustsScrollViewInsets = NO;
    [viewController addChildViewController:self];
    [viewController.view addSubview:self.view];
}

- (instancetype)initWithParentViewController:(UIViewController*)parentViewController
{
    if (self = [super init]) {
        parentViewController.navTabBarController = self;
        parentViewController.automaticallyAdjustsScrollViewInsets = NO;
        [parentViewController addChildViewController:self];
        [parentViewController.view addSubview:self.view];
    }
    return self;
}

- (void)setup
{
    // 初始化选项卡标题数组
    self.titles = [[NSMutableArray alloc] initWithCapacity:self.subViewControllers.count];

    for (UIViewController* viewController in self.subViewControllers) {
        [self.titles addObject:viewController.title];
    }

    // 默认navBar高度为0
    _navTabBar_Y = 0;
}

- (void)setSubViewControllers:(NSArray*)subViewControllers
{
    if (!subViewControllers || subViewControllers.count == 0) return;
    
    _subViewControllers = subViewControllers;

    // 初始化基本信息
    [self setup];

    // 初始化选项条
    [self navTabBar];

    // 初始化滚动主视图
    [self mainView];

    // 开启KVO监听
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;

    [self.mainView addObserver:self forKeyPath:@"contentOffset" options:options context:nil];

    [self.view bringSubviewToFront:self.navTabBar];
}

#pragma mark - viewDidLoad &dealloc
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)dealloc
{
    [self.mainView removeObserver:self forKeyPath:@"contentOffset"];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context
{
    UIScrollView* scrollView = (UIScrollView*)object;

    if ([keyPath isEqualToString:@"contentOffset"] && object == self.mainView) {

        _currentIndex = scrollView.contentOffset.x / (YPScreenW + 1);

        // 左方目前的index
        int leftCurrentIndex = scrollView.contentOffset.x / (YPScreenW - 1);

        _navTabBar.currentItemIndex = _currentIndex;

        CGFloat progress = scrollView.contentOffset.x / YPScreenW;

        _navTabBar.progress = progress;

        // 加载子视图
        [_subViewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {

            if (_startContentOffsetX < scrollView.contentOffset.x) {
                if (_currentIndex >= idx) {
                    return;
                }
                UIViewController* vc = (UIViewController*)self.subViewControllers[_currentIndex + 1];
                vc.view.frame = CGRectMake(YPScreenW * (_currentIndex + 1), 0, YPScreenW, self.mainView.frame.size.height);
                [self.mainView addSubview:vc.view];
                [self addChildViewController:vc];
            }
            else if (_startContentOffsetX > scrollView.contentOffset.x) {

                UIViewController* vc = (UIViewController*)self.subViewControllers[leftCurrentIndex];
                vc.view.frame = CGRectMake(YPScreenW * leftCurrentIndex, 0, YPScreenW, self.mainView.frame.size.height);
                [self.mainView addSubview:vc.view];
                [self addChildViewController:vc];
            }

        }];
    }
}

#pragma mark - YPNavTabBarDelegate

- (void)itemDidSelectedWithIndex:(YPNavTabBar*)navTabBar index:(NSInteger)index
{
    
    
    UIViewController* selectedVc = (UIViewController*)self.subViewControllers[index];
    selectedVc.view.frame = CGRectMake(YPScreenW * index, 0, YPScreenW, self.mainView.frame.size.height);
    [self.mainView addSubview:selectedVc.view];
    [self addChildViewController:selectedVc];

    [self.mainView setContentOffset:CGPointMake(index * YPScreenW, 0) animated:NO];

    for (int i = 0; i < (int)navTabBar.items.count; i++) {

        UIButton* btn = navTabBar.items[i];
        if (i == index) {
            btn.selected = YES;
            
            btn.titleLabel.font = self.navTabBar_selectedTitle_font;
        }
        else {
            btn.selected = NO;
            
            btn.titleLabel.font = self.navTabBar_normalTitle_font;
        }
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView*)scrollView
{ // 记录拖动前的起始坐标

    _startContentOffsetX = scrollView.contentOffset.x;
}

#pragma mark - Public
- (void)setNavTabBar_Y:(CGFloat)navTabBar_Y
{
    _navTabBar_Y = navTabBar_Y;

    self.navTabBar.yp_y = navTabBar_Y;

    self.mainView.frame = CGRectMake(0, CGRectGetMaxY(self.navTabBar.frame), _presetSize.width, _presetSize.height - CGRectGetMaxY(self.navTabBar.frame));
}

- (void)setContentViewH:(CGFloat)contentViewH
{
    _contentViewH = contentViewH;

    _mainView.yp_height = contentViewH;
    
    self.navTabBar.contentViewH = contentViewH;
}

- (void)setNavTabBar_color:(UIColor*)navTabBar_color
{
    navTabBar_color = navTabBar_color;

    self.navTabBar.navgationTabBar_color = navTabBar_color;
}

- (void)setNavTabBarLine_color:(UIColor*)navTabBarLine_color
{
    _navTabBarLine_color = navTabBarLine_color;

    self.navTabBar.navgationTabBar_lineColor = navTabBarLine_color;
}

- (void)setNavTabBar_normalTitle_color:(UIColor*)navTabBar_normalTitle_color
{
    _navTabBar_normalTitle_color = navTabBar_normalTitle_color;

    self.navTabBar.navTabBar_normalTitle_color = navTabBar_normalTitle_color;
}

- (void)setNavTabBar_selectedTitle_color:(UIColor*)navTabBar_selectedTitle_color
{
    _navTabBar_selectedTitle_color = navTabBar_selectedTitle_color;

    self.navTabBar.navTabBar_selectedTitle_color = navTabBar_selectedTitle_color;
}

- (void)setNavTabBar_normalTitle_font:(UIFont *)navTabBar_normalTitle_font {
    _navTabBar_normalTitle_font = navTabBar_normalTitle_font;
    self.navTabBar.navTabBar_normalTitle_font = navTabBar_normalTitle_font;
}

- (void)setNavTabBar_selectedTitle_font:(UIFont *)navTabBar_selectedTitle_font {
    _navTabBar_selectedTitle_font = navTabBar_selectedTitle_font;
    self.navTabBar.navTabBar_selectedTitle_font = navTabBar_selectedTitle_font;
    
    if(self.currentIndex < self.navTabBar.items.count) {
        UIButton *btn = self.navTabBar.items[self.currentIndex];
        btn.titleLabel.font = self.navTabBar_selectedTitle_font;
    }
}

- (void)setNavTabBar_type:(YPNavTabBarType)navTabBar_type
{
    _navTabBar_type = navTabBar_type;

    self.navTabBar.type = navTabBar_type;
}

- (void)setNavTabBar_style:(YPNavTabBarStyle)navTabBar_style
{
    _navTabBar_style = navTabBar_style;

    self.navTabBar.style = navTabBar_style;
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    if (currentIndex < 0 || currentIndex >= self.subViewControllers.count)
        return;

    _currentIndex = currentIndex;

    self.navTabBar.progress = currentIndex;
}

- (void)setLineWidth:(CGFloat)lineWidth {
    self.navTabBar.lineWidth = lineWidth;
}

- (CGSize)presetSize {
    if(_presetSize.height == 0 && _presetSize.width == 0) {
        return [UIScreen mainScreen].bounds.size;
    } else {
        return _presetSize;
    }
}


#pragma mark - Getter
- (UIScrollView*)mainView
{
    if (_mainView == nil) {
        UIScrollView* mainView = [[UIScrollView alloc] init];
        mainView.frame = CGRectMake(0, CGRectGetMaxY(self.navTabBar.frame), YPScreenW, YPScreenH - CGRectGetMaxY(self.navTabBar.frame));
        mainView.pagingEnabled = YES;
        mainView.bounces = NO;
        mainView.showsHorizontalScrollIndicator = NO;
        mainView.contentSize = CGSizeMake(YPScreenW * self.subViewControllers.count, 0);
        mainView.delegate = self;
        [self.view addSubview:mainView];
        self.mainView = mainView;
    }
    return _mainView;
}

- (YPNavTabBar*)navTabBar
{
    if (_navTabBar == nil) {
        YPNavTabBar* navTabBar = [[YPNavTabBar alloc] init];
        navTabBar.frame = CGRectMake(0, 0, YPScreenW, 44);
        navTabBar.delegate = self;
        navTabBar.itemTitles = _titles;
        // 更新选项条标题数据
        [navTabBar updateData];
        [self.view addSubview:navTabBar];
        self.navTabBar = navTabBar;
    }
    return _navTabBar;
}


- (UIFont *)navTabBar_selectedTitle_font {
    if(!_navTabBar_selectedTitle_font) {
        return [UIFont systemFontOfSize:[UIFont systemFontSize]];
    } else {
        return _navTabBar_selectedTitle_font;
    }
}

- (UIFont *)navTabBar_normalTitle_font {
    if(!_navTabBar_normalTitle_font) {
        return [UIFont systemFontOfSize:[UIFont systemFontSize]];
    } else {
        return _navTabBar_normalTitle_font;
    }
}

@end

@implementation UIViewController (YPNavTabBarControllerItem)

const char key;

- (void)setNavTabBarController:(YPNavTabBarController*)navTabBarController
{
    objc_setAssociatedObject(self, &key, navTabBarController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (YPNavTabBarController*)navTabBarController
{
    return objc_getAssociatedObject(self, &key);
}

@end
