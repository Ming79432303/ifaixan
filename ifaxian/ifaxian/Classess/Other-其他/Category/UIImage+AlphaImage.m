//
//  UIButton+AlphaImage.m
//  微博个人详情
//
//  Created by ming on 17/8/16.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "UIImage+AlphaImage.h"

@implementation UIImage (AlphaImage)
+ (UIImage *)imageWithAlpha:(CGFloat )alpha{
    
    CGSize size = CGSizeMake(20, 2);
    //开启图片上线文
    UIGraphicsBeginImageContext(size);
    //创建一个路径
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 20, 2)];
    //设置填充颜色
    [[UIColor colorWithRed:0 green:0 blue:0 alpha:alpha] set];
    //[[UIColor colorWithWhite:1 alpha:alpha] set];
    //填充
    [path fill];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //关闭上下文
    UIGraphicsEndImageContext();
    return image;
    
    
}
+ (UIImage *)WhiteimageWithAlpha:(CGFloat )alpha{
    
    CGSize size = CGSizeMake(20, 2);
    //开启图片上线文
    UIGraphicsBeginImageContext(size);
    //创建一个路径
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 20, 2)];
    //设置填充颜色
   
    [[UIColor colorWithWhite:1 alpha:alpha] set];
    //填充
    [path fill];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //关闭上下文
    UIGraphicsEndImageContext();
    return image;
    
    
}

@end
