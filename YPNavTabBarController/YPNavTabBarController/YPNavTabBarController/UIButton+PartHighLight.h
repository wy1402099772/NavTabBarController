//
//  UIButton+PartHighLight.h
//  WYTextStokeAnimation
//
//  Created by wyan assert on 2017/2/21.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (PartHighLight)

- (void)displayTextColors:(NSArray<UIColor *> *)colors turnPoints:(NSArray<NSNumber *> *)turns;

@property (nonatomic, strong) CAGradientLayer *hlGradientLayer;

@end
