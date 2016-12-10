//
//  UIBarButtonItem+HSYExtension.h
//  百思不得姐
//
//  Created by Apple_Lzzy27 on 16/11/2.
//  Copyright © 2016年 Apple_Lzzy27. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (LGExtension)
+ (nonnull instancetype)lg_itemWithImage:(nonnull NSString *)image highImage:(nonnull NSString *)highImage target:(nullable id)target action:(nonnull SEL)action;
/*
 是否带返回按钮
 */
+ (nonnull instancetype)lg_barButtonCustButton:(nonnull NSString *)title fontSize:(CGFloat)fontSize addTarget:(nullable id)addTarget action:(nonnull SEL)action isBack:(BOOL)isBack;
@end
