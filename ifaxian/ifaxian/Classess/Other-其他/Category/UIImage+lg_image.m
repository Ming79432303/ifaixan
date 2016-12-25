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
- (instancetype)lg_circleImage
{
    // 开启图形上下文
    UIGraphicsBeginImageContext(self.size);
    
    // 获得上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 矩形框
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    
    // 添加一个圆
    CGContextAddEllipseInRect(ctx, rect);
    
    // 裁剪(裁剪成刚才添加的图形形状)
    CGContextClip(ctx);
    
    // 往圆上面画一张图片
    [self drawInRect:rect];
    
    // 获得上下文中的图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭图形上下文
    UIGraphicsEndImageContext();
    
    return image;
}

+ (instancetype)lg_circleImageNamed:(NSString *)name
{
    return [[self imageNamed:name] lg_circleImage];
}


@end
