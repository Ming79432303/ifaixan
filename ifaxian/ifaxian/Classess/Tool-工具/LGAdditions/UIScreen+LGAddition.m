//
//  UIScreen+lgAddition.m
//
//  Created by ming on 16/5/17.
//  Copyright © 2016年 ming All rights reserved.
//

#import "UIScreen+LGAddition.h"

@implementation UIScreen (LGAddition)

+ (CGFloat)lg_screenWidth {
    return [UIScreen mainScreen].bounds.size.width;
}

+ (CGFloat)lg_screenHeight {
    return [UIScreen mainScreen].bounds.size.height;
}

+ (CGFloat)lg_scale {
    return [UIScreen mainScreen].scale;
}

@end
