//
//  UIColor+CZAddition.m
//
//  Created by ming on 16/4/21.
//  Copyright © 2016年 ming All rights reserved.
//

#import "UIColor+LGAddition.h"

@implementation UIColor (LGAddition)

+ (instancetype)lg_colorWithHex:(uint32_t)hex {
    
    uint8_t r = (hex & 0xff0000) >> 16;
    uint8_t g = (hex & 0x00ff00) >> 8;
    uint8_t b = hex & 0x0000ff;
    
    return [self lg_colorWithRed:r green:g blue:b];
}

+ (instancetype)lg_randomColor {
    return [UIColor lg_colorWithRed:arc4random_uniform(256) green:arc4random_uniform(256) blue:arc4random_uniform(256)];
}

+ (instancetype)lg_colorWithRed:(uint8_t)red green:(uint8_t)green blue:(uint8_t)blue {
    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:1.0];
}

@end
