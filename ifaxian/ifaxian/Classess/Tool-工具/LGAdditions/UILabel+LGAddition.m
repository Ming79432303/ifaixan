//
//  UILabel+CZAddition.m
//
//  Created by ming on 16/4/21.
//  Copyright © 2016年 ming All rights reserved.
//

#import "UILabel+LGAddition.h"

@implementation UILabel (CZAddition)

+ (instancetype)lg_labelWithText:(NSString *)text fontSize:(CGFloat)fontSize color:(UIColor *)color {
    UILabel *label = [[self alloc] init];
    
    label.text = text;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textColor = color;
    label.numberOfLines = 0;
    
    [label sizeToFit];
    
    return label;
}

@end
