//
//  UIBarButtonItem+HSYExtension.m
//  百思不得姐
//
//  Created by Apple_Lzzy27 on 16/11/2.
//  Copyright © 2016年 Apple_Lzzy27. All rights reserved.
//

#import "UIBarButtonItem+LGExtension.h"

@implementation UIBarButtonItem (LGExtension)
+ (instancetype)lg_itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    return [[self alloc] initWithCustomView:button];
}
+ (instancetype)lg_barButtonCustButton:(NSString *)title fontSize:(CGFloat)fontSize addTarget:(id)addTarget action:(SEL)action isBack:(BOOL)isBack{
    
    UIButton *butn = [UIButton lg_textButton:title fontSize:fontSize normalColor:[UIColor darkGrayColor] highlightedColor:[UIColor orangeColor]];
    butn.titleLabel.font = [UIFont boldSystemFontOfSize:fontSize];
    
    if (isBack) {
        [butn setImage:[UIImage imageNamed:@"navigationbar_back_withtext_highlighted"] forState:UIControlStateHighlighted];
        [butn setImage:[UIImage imageNamed:@"navigationbar_back_withtext"] forState:UIControlStateNormal];
        
        [butn sizeToFit];
    }
    [butn addTarget:addTarget action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithCustomView:butn];
    return button;
}

@end
