//
//  UILabel+CZAddition.h
//
//  Created by ming on 16/4/21.
//  Copyright © 2016年 ming All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (CZAddition)

/// 创建文本标签
///
/// @param text     文本
/// @param fontSize 字体大小
/// @param color    颜色
///
/// @return UILabel
+ (instancetype)lg_labelWithText:(NSString *)text fontSize:(CGFloat)fontSize color:(UIColor *)color;

@end
