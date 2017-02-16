//
//  YPNavTabBar.m
//  YPNavTabBarController
//
//  Created by 胡云鹏 on 15/9/24.
//  Copyright (c) 2015年 MichaelPPP. All rights reserved.
//

#import "YPNavTabBar.h"
#import "YPNavTabBarControllerConst.h"

@interface YPNavTabBar()

/** 存储所有选项标题长度的数组 */
@property (nonatomic, strong) NSArray *itemsWidth;

/** 所有的选项标题都在这个ScrollView上 */
@property (nonatomic, weak) UIScrollView *navgationTabBar;

/** 横条 */
@property (nonatomic, weak) UIView *line;

/** 椭圆条 */
@property (nonatomic, weak) UIView *ellipse;



@end

@implementation YPNavTabBar

@synthesize contentViewH = _contentViewH;
@synthesize navTabBar_normalTitle_color = _navTabBar_normalTitle_color;
@synthesize navTabBar_selectedTitle_color = _navTabBar_selectedTitle_color;
@synthesize navTabBar_normalTitle_font = _navTabBar_normalTitle_font;
@synthesize navTabBar_selectedTitle_font = _navTabBar_selectedTitle_font;

#pragma mark - lazy -

- (UIScrollView *)navgationTabBar
{
    if (_navgationTabBar == nil) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.backgroundColor = YPClearColor;
        [self addSubview:scrollView];
        self.navgationTabBar = scrollView;
    }
    return _navgationTabBar;
}


- (UIView *)ellipse
{
    if (_ellipse == nil) {
        UIView *view = [[UIView alloc] init];
        view.layer.cornerRadius = 10;
        view.backgroundColor = YPColor_RGBA(200, 200, 200, 0.3);
        [self.navgationTabBar addSubview:view];
        self.ellipse = view;
        self.ellipse.hidden = YES;
    }
    return _ellipse;
}


- (UIView *)line
{
    if (_line == nil) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = YPColor_RGBA(20.0f, 80.0f, 200.0f, 0.7f);
        [self.navgationTabBar addSubview:view];
        self.line = view;
        self.line.hidden = NO;
    }
    return _line;
}

- (NSMutableArray *)items
{
    if (_items == nil) {
        _items = [NSMutableArray array];
    }
    return _items;
}

#pragma mark - Life Cycle -
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 准备工作
        [self prepare];
    }
    return self;
}

- (void)prepare
{
    self.navgationTabBar.frame = CGRectMake(0, 0, YPScreenW, self.contentViewH);
}

#pragma mark - 公共方法 -
- (void)updateData
{
    // 如果没有值直接返回
    if (!self.itemTitles.count) return;
    

    if (self.itemTitles.count <= 4) { // 当按钮小于等于4个的时候并列排布
        CGFloat btnWidth = YPScreenW / self.itemTitles.count;
        self.navgationTabBar.contentSize = CGSizeMake(btnWidth * self.itemTitles.count, 0);
        [self contentWidthAndAddNavTabBarItemsWithButtonsWidth:[self getButtonsWidthWithTitles:self.itemTitles]];
    } else { // 对于4个的时候紧凑排布
        CGFloat contentWidth = [self contentWidthAndAddNavTabBarItemsWithButtonsWidth:[self getButtonsWidthWithTitles:self.itemTitles]];
        self.navgationTabBar.contentSize = CGSizeMake(contentWidth, 0);
    }
}

#pragma mark - 私有方法 -
- (NSArray *)getButtonsWidthWithTitles:(NSArray *)titles
{
    NSMutableArray *widths = [NSMutableArray arrayWithCapacity:titles.count];

    if (titles.count <= 4) { // 当按钮小于等于4个的时候并列排布
        for (int i = 0; i < titles.count; i++) {
            NSNumber *width = [NSNumber numberWithFloat:self.navgationTabBar.contentSize.width / titles.count];
            NSLog(@"%@",width);
            [widths addObject:width];
        }
    } else { // 当按钮多于4个的时候紧凑排布
        for (NSString *title in titles)
        {
            CGSize size = CGSizeMake(MAXFLOAT, MAXFLOAT);
            NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
            UIFont *font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
            if(self.navTabBar_normalTitle_font) {
                font = self.navTabBar_normalTitle_font;
            }
            attributes[NSFontAttributeName] = font;
            
            size = [title boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
            
            NSNumber *width = [NSNumber numberWithFloat:size.width + 40.0f];
            [widths addObject:width];
        }
    }
    
    
    // 存储所有按钮的长度
    self.itemsWidth = widths;
    
    return widths;
}

- (CGFloat)contentWidthAndAddNavTabBarItemsWithButtonsWidth:(NSArray *)widths
{
    CGFloat buttonX = 0;
    for (UIButton *btn in self.items) {
        [btn removeFromSuperview];
    }
    [self.items removeAllObjects];
    for (NSInteger index = 0; index < self.itemTitles.count; index++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(buttonX, 0, [widths[index] floatValue], self.contentViewH);
        [button setTitle:_itemTitles[index] forState:UIControlStateNormal];
        [button setTitleColor:self.navTabBar_normalTitle_color forState:UIControlStateNormal];
        [button setTitleColor:self.navTabBar_selectedTitle_color forState:UIControlStateSelected];
        [button addTarget:self action:@selector(itemPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        UIFont *font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
        if(self.navTabBar_normalTitle_font) {
            font = self.navTabBar_normalTitle_font;
        }
        button.titleLabel.font = font;
        
        [_navgationTabBar addSubview:button];
        
        [self.items addObject:button];
        
        buttonX += [widths[index] floatValue];
    }
    
    [self showLineWithButtonWidth:[widths[0] floatValue]];
    
    [self showEllipseWithButtonWidth:[widths[0] floatValue]];

    return buttonX;
}

- (void)itemPressed:(UIButton *)button
{
    NSInteger index = [self.items indexOfObject:button];
    
    if ([_delegate respondsToSelector:@selector(itemDidSelectedWithIndex:index:)]) {
        [_delegate itemDidSelectedWithIndex:self index:index];
    }
    
}


- (void)showLineWithButtonWidth:(CGFloat)width
{
    CGFloat lineX = 0;
    if(self.currentItemIndex && self.currentItemIndex < self.items.count) {
        UIButton *btn = self.items[self.currentItemIndex];
        lineX = btn.frame.origin.x;
        
    }
    if(self.lineWidth) {
        
    } else {
        self.line.frame = CGRectMake(lineX + 2.0f, self.contentViewH - 3.0f, width - 4.0f, 3.0f);
    }
}

- (void)showEllipseWithButtonWidth:(CGFloat)width
{
    CGFloat lineX = 0;
    if(self.currentItemIndex && self.currentItemIndex < self.items.count) {
        UIButton *btn = self.items[self.currentItemIndex];
        lineX = btn.frame.origin.x;
        
    }
    self.ellipse.frame = CGRectMake(lineX + 2.0f, 8.0f, width - 4.0f, self.contentViewH - 16.0f);
}


#pragma mark - setter -
- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    _currentItemIndex = (int)progress;
    
    UIButton *oldBtn;
    
    if (_currentItemIndex > 0) {
        oldBtn = _items[_currentItemIndex - 1];
    }
    
    
    UIButton *button = _items[_currentItemIndex];
    
    CGFloat flag = YPScreenW;
    
    if (button.frame.origin.x + button.frame.size.width > flag)
    {
        CGFloat offsetX = button.frame.origin.x + button.frame.size.width - flag;
        if (_currentItemIndex < [_itemTitles count] - 1)
        {
            offsetX = offsetX + 40.0f;
        }
        
        [_navgationTabBar setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }
    else
    {
        [_navgationTabBar setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    
    [UIView animateWithDuration:0.2f animations:^{
        
        CGFloat lineX = 0;
        
        if (oldBtn) { // 如果有上一个按钮
            lineX = button.frame.origin.x + oldBtn.frame.size.width * (_progress - (int)_progress);
        } else { // 如果没有上一个按钮
            lineX = button.frame.size.width * (_progress - (int)_progress);
        }
        
        if ((_progress - (int)_progress) == 0) {
            lineX = button.frame.origin.x;
            // 回调代理方法
            if ([_delegate respondsToSelector:@selector(itemDidSelectedWithIndex:index:)]) {
                [self.delegate itemDidSelectedWithIndex:self index:_progress];
            }
        }
        
        
        CGFloat lineY = _line.frame.origin.y;
        CGFloat lineW = (self.lineWidth) ? (self.lineWidth) : [_itemsWidth[_currentItemIndex] floatValue] - 4.0f;
        CGFloat lineH = _line.frame.size.height;
        
        if(self.lineWidth) {
            self.line.frame = CGRectMake(lineX + [_itemsWidth[_currentItemIndex] floatValue] / 2 - lineW / 2, lineY, lineW, lineH);
        } else {
            self.line.frame = CGRectMake(lineX + 2.0f, lineY, lineW, lineH);
        }
        
        self.ellipse.frame = CGRectMake(self.line.frame.origin.x, self.ellipse.frame.origin.y, self.line.frame.size.width, self.ellipse.frame.size.height);
        
        
    }];
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    
    CGPoint center = self.line.center;
    self.line.frame = CGRectMake(self.line.frame.origin.x, self.line.frame.origin.y, lineWidth, self.line.frame.size.height);
    self.line.center = center;
}

- (void)setNavgationTabBar_color:(UIColor *)navgationTabBar_color
{
    _navgationTabBar_color = navgationTabBar_color;
    
    self.navgationTabBar.backgroundColor = navgationTabBar_color;
}

- (void)setNavgationTabBar_lineColor:(UIColor *)navgationTabBar_lineColor
{
    _navgationTabBar_lineColor = navgationTabBar_lineColor;
    
    self.line.backgroundColor = navgationTabBar_lineColor;
}

- (void)setNavTabBar_normalTitle_color:(UIColor *)navTabBar_normalTitle_color
{
    _navTabBar_normalTitle_color = navTabBar_normalTitle_color;
    
    
    for (UIButton *btn in self.items) {
        [btn setTitleColor:navTabBar_normalTitle_color forState:UIControlStateNormal];
    }
}

- (void)setNavTabBar_selectedTitle_color:(UIColor *)navTabBar_selectedTitle_color
{
    _navTabBar_selectedTitle_color = navTabBar_selectedTitle_color;
    
    for (UIButton *btn in self.items) {
        [btn setTitleColor:navTabBar_selectedTitle_color forState:UIControlStateSelected];
    }
}

- (void)setNavTabBar_normalTitle_font:(UIFont *)navTabBar_normalTitle_font
{
    _navTabBar_normalTitle_font = navTabBar_normalTitle_font;
    
    
    for (NSInteger i = 0; i < self.items.count; i++) {
        UIButton *btn = self.items[i];
        if(i != self.currentItemIndex) {
            btn.titleLabel.font = navTabBar_normalTitle_font;
        } else {
            btn.titleLabel.font = self.navTabBar_selectedTitle_font;
        }
    }
    
    [self updateData];
}

- (void)setNavTabBar_selectedTitle_font:(UIFont *)navTabBar_selectedTitle_font {
//    _navTabBar_selectedTitle_font = navTabBar_selectedTitle_font;
//    
//    if(self.currentItemIndex < self.items.count) {
//        UIButton *btn = self.items[self.currentItemIndex];
//        btn.titleLabel.font = navTabBar_selectedTitle_font
//    }
}

- (void)setType:(YPNavTabBarType)type
{
    _type = type;
    
    switch (type) {
        case YPNavTabBarTypeLine:
            self.line.hidden = NO;
            self.ellipse.hidden = YES;
            break;
        case YPNavTabBarTypeEllipse:
            self.line.hidden = YES;
            self.ellipse.hidden = NO;
            break;
        default:
            break;
    }
}

- (void)setStyle:(YPNavTabBarStyle)style
{
    _style = style;
}

- (void)setContentViewH:(CGFloat)contentViewH {
    _contentViewH = contentViewH;
    
    CGRect frame = self.navgationTabBar.frame;
    frame.size.height = contentViewH;
    [self.navgationTabBar setFrame:frame];
    
    frame = self.line.frame;
    frame.origin.y = contentViewH - 3;
    [self.line setFrame:frame];
    
    frame = self.ellipse.frame;
    frame.size.height = contentViewH - 16;
    [self.ellipse setFrame:frame];
    
    for (UIButton *btn in self.items)
    {
        frame = btn.frame;
        frame.size.height = contentViewH;
        [btn setFrame:frame];
    }
}

#pragma mark - Getter
- (CGFloat)contentViewH {
    if(0 <= _contentViewH) {
        return 44;
    } else {
        return _contentViewH;
    }
}

- (UIColor *)navTabBar_normalTitle_color {
    if(!_navTabBar_normalTitle_color) {
        return [UIColor blackColor];
    } else {
        return _navTabBar_normalTitle_color;
    }
}

- (UIColor *)navTabBar_selectedTitle_color {
    if(!_navTabBar_selectedTitle_color) {
        return [UIColor blueColor];
    } else {
        return _navTabBar_selectedTitle_color;
    }
}


@end





















