//
//  UIButton+PartHighLight.m
//  WYTextStokeAnimation
//
//  Created by wyan assert on 2017/2/21.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import "UIButton+PartHighLight.h"
#import <objc/runtime.h>

static const NSString *PHLAssociateGradientLayerkey = @"PHLAssociateGradientLayerkey";

@implementation UIButton (PartHighLight)

- (void)displayTextColors:(NSArray<UIColor *> *)colors turnPoints:(NSArray<NSNumber *> *)turns {
    if(![self.hlGradientLayer superlayer]) {
        self.hlGradientLayer = [CAGradientLayer layer];
        self.hlGradientLayer.startPoint = CGPointMake(0, 0);
        self.hlGradientLayer.endPoint = CGPointMake(1, 0);
        
        [self.layer addSublayer:self.hlGradientLayer];
        self.hlGradientLayer.frame = self.bounds;
        self.hlGradientLayer.mask = self.titleLabel.layer;
        
        self.hlGradientLayer.startPoint = CGPointMake(0, 0.5);
        self.hlGradientLayer.endPoint = CGPointMake(1, 0.5);

    }
    
    NSMutableArray *displayColors = [NSMutableArray array];
    [colors enumerateObjectsUsingBlock:^(UIColor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [displayColors addObject:(id)obj.CGColor];
    }];
    
    self.hlGradientLayer.colors = [displayColors copy];
    self.hlGradientLayer.locations = turns;
}

- (CAGradientLayer *)hlGradientLayer {
    return (CAGradientLayer *)objc_getAssociatedObject(self, &PHLAssociateGradientLayerkey);
}

- (void)setHlGradientLayer:(CAGradientLayer *)hlGradientLayer {
    objc_setAssociatedObject(self, &PHLAssociateGradientLayerkey, hlGradientLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
