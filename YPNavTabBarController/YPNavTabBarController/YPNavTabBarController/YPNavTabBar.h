//
//  YPNavTabBar.h
//  YPNavTabBarController
//
//  Created by 胡云鹏 on 15/9/24.
//  Copyright (c) 2015年 MichaelPPP. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    /** 横线风格 */
    YPNavTabBarTypeLine = 0,
    /** 椭圆风格 */
    YPNavTabBarTypeEllipse,
} YPNavTabBarType;

typedef enum {
    /** 自适应模式 */
    YPNavTabBarStyleAdjust,
    /** 紧凑模式 */
    YPNavTabBarStyleCompact,
    /** 居中模式 */
    YPNavTabBarStyleCenter
} YPNavTabBarStyle;

@class YPNavTabBar;

@protocol YPNavTabBarDelegate <NSObject>

@optional

/** 当选项被选择时候的回调代理方法 */
- (void)itemDidSelectedWithIndex:(YPNavTabBar*)navTabBar index:(NSInteger)index;

@end

@interface YPNavTabBar : UIView

/** 代理 */
@property (nonatomic, assign) id<YPNavTabBarDelegate> delegate;

/** 当前索引 */
@property (nonatomic, assign) NSInteger currentItemIndex;

/** 选项标题数组 */
@property (nonatomic, strong) NSArray* itemTitles;

/** 横条颜色 */
@property (nonatomic, strong) UIColor* navgationTabBar_lineColor;

/** 拖动比例 */
@property (nonatomic, assign) CGFloat progress;

/** 选项卡的背景颜色 */
@property (nonatomic, strong) UIColor* navgationTabBar_color;

/** 被按压的选项数组 */
@property (nonatomic, strong) NSMutableArray* items;

/** 选项标题普通状态文字的颜色 */
@property (nonatomic, strong) UIColor* navTabBar_normalTitle_color;

/** 选项标题选中状态文字的颜色 */
@property (nonatomic, strong) UIColor* navTabBar_selectedTitle_color;

/** 选项标题普通状态文字的字体 */
@property (nonatomic, strong) UIFont* navTabBar_normalTitle_font;

/** 选项标题普通状态文字的字体 */
@property (nonatomic, strong) UIFont* navTabBar_selectedTitle_font;

/** 选项风格 */
@property (nonatomic, assign) YPNavTabBarType type;

/** 选项文字排列风格 */
@property (nonatomic, assign) YPNavTabBarStyle style;

/** 下划线的宽度 */
@property (nonatomic, assign) CGFloat lineWidth;

/** 内容视图的高度 */
@property (nonatomic, assign) CGFloat contentViewH;

/** 右上角红点的颜色 **/
@property (nonatomic, strong) NSMutableArray<UIView *> *redDotItems;

/** 右上角红点的颜色 **/
@property (nonatomic, strong) UIColor *redDotColor;

/** 设置小红点， 是否在点击后自动消失(但是目前不支持常驻的小红花点， 所以isAutoDisappear目前并没有生效， 默认该界面出现了就直接消掉) **/
- (void)markRedDotAtIndex:(NSUInteger)index autoDisappear:(BOOL)isAutoDisappear;

/** 移除小红点 (但是目前不支持常驻的小红花点， 所以isAutoDisappear目前并没有生效， 默认该界面出现了就直接消掉) **/
- (void)removeRedDotAtIndex:(NSUInteger)index;

/**
 *  刷新数据
 */
- (void)updateData;

@end
