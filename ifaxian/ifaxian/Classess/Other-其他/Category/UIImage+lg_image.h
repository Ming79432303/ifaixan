//
//  UIImage+lg_image.h
//  裁剪图片
//
//  Created by Apple_Lzzy27 on 16/10/26.
//  Copyright © 2016年 Apple_Lzzy27. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (lg_image)
- (UIImage *)lg_avatarImagesize:(CGSize)size backColor:(UIColor *)backColor lineColor:(UIColor *)linColor;
/**
 * 返回一张圆形图片
 */
- (instancetype)lg_circleImage;

/**
 * 返回一张圆形图片
 */
+ (instancetype)lg_circleImageNamed:(NSString *)name;
@end
