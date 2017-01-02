//
//  UIButton+AlphaImage.h
//  微博个人详情
//
//  Created by ming on 17/8/16.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (AlphaImage)
/**
 *  根据透明度生成一张图片
 *
 *  @param alpha <#alpha description#>
 *
 *  @return 返回一张图片
 */
+ (UIImage *)imageWithAlpha:(CGFloat )alpha;
+ (UIImage *)WhiteimageWithAlpha:(CGFloat )alpha;
@end
