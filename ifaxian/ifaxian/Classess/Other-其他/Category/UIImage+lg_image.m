//
//  UIImage+lg_image.m
//  裁剪图片
//
//  Created by Apple_Lzzy27 on 16/10/26.
//  Copyright © 2016年 Apple_Lzzy27. All rights reserved.
//

#import "UIImage+lg_image.h"

@implementation UIImage (lg_image)


- (UIImage *)lg_avatarImagesize:(CGSize)size backColor:(UIColor *)backColor lineColor:(UIColor *)linColor{
    //设置绘制区域
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    //开启图片上下文
    UIGraphicsBeginImageContextWithOptions(rect.size, true, 0);
    //设置背景颜色填充
    [backColor setFill];
    UIRectFill(rect);
    UIBezierPath * path = [UIBezierPath bezierPathWithOvalInRect:rect];
    [path addClip];
    [self drawInRect:rect];
    UIBezierPath *ovaPath = [UIBezierPath bezierPathWithOvalInRect:rect];
    ovaPath.lineWidth = 2;
    [linColor setStroke];
    [ovaPath stroke];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return result;
  
}



@end
