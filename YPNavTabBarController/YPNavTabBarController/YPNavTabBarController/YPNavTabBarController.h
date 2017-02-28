//
//  YPNavTabBarController.h
//  YPNavTabBarController
//
//  Created by 胡云鹏 on 15/9/24.
//  Copyright (c) 2015年 MichaelPPP. All rights reserved.
//

#import "YPNavTabBar.h"
#import <UIKit/UIKit.h>

@interface YPNavTabBarController : UIViewController

/** 子控制器 */
@property (nonatomic, strong) NSArray* subViewControllers;

/** 选线条 */
@property (nonatomic, weak) YPNavTabBar* navTabBar;

/** 选项条顶端距离父视图顶端的距离 */
@property (nonatomic, assign) CGFloat navTabBar_Y;

/** 内容视图的高度 */
@property (nonatomic, assign) CGFloat contentViewH;

/** 设置风格 */
@property (nonatomic, assign) YPNavTabBarType navTabBar_type;

/** 设置选项排列风格 */
@property (nonatomic, assign) YPNavTabBarStyle navTabBar_style;

/** 设置选项卡的背景颜色 */
@property (nonatomic, strong) UIColor* navTabBar_color;

/** 选项条横条的颜色 */
@property (nonatomic, strong) UIColor* navTabBarLine_color;

/** 选项标题普通状态文字的颜色 */
@property (nonatomic, strong) UIColor* navTabBar_normalTitle_color;

/** 选项标题选中状态文字的颜色 */
@property (nonatomic, strong) UIColor* navTabBar_selectedTitle_color;

/** 选项标题普通状态文字的字体 */
@property (nonatomic, strong) UIFont* navTabBar_normalTitle_font;

/** 选项标题普选中态文字的字体 */
@property (nonatomic, strong) UIFont* navTabBar_selectedTitle_font;

/** 索引(如果使用请在所有属性赋值之前调用) 注意  请在最后设置这个*/
@property (nonatomic, assign) NSInteger currentIndex;

/** 下标线的宽度 */
@property (nonatomic, assign) CGFloat lineWidth;

/** 如果不是全屏大小， 设置这个选项来控制整个VC的大小符合要求 */
@property (nonatomic, assign) CGSize presetSize;


/** 右上角红点的颜色 **/
@property (nonatomic, strong) UIColor *redDotColor;

/** 设置小红点， 是否在点击后自动消失(但是目前不支持常驻的小红花点， 所以isAutoDisappear目前并没有生效， 默认该界面出现了就直接消掉) **/
- (void)markRedDotAtIndex:(NSUInteger)index autoDisappear:(BOOL)isAutoDisappear;

/** 移除小红点 (但是目前不支持常驻的小红花点， 所以isAutoDisappear目前并没有生效， 默认该界面出现了就直接消掉) **/
- (void)removeRedDotAtIndex:(NSUInteger)index;

/** 构造方法 */
- (instancetype)initWithParentViewController:(UIViewController*)parentViewController;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

@end

@interface UIViewController (YPNavTabBarControllerItem)

@property (nonatomic, strong, readonly) YPNavTabBarController* navTabBarController;

@end














































