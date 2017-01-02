//
//  UIImageView+LGUIimageView.h
//  微博oc版
//
//  Created by Apple_Lzzy27 on 16/10/21.
//  Copyright © 2016年 Apple_Lzzy27. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (LGUIimageView)
/**
 *  设置用户头像圆形
 *
 *  @param url 图片的url
 */
- (void)setHeader:(NSString *)url;
/**
 *  隔离SD方法
 *
 *  @param url   图片的地址
 *  @param image 占位图
 */
-(void)lg_setImageWithurl:(NSString *)url placeholderImage:(UIImage *)image;
/**
 *  隔离SD方法设置图片圆角
 *
 *  @param url   图片的地址
 *  @param image 占位图
 */
-(void)lg_setCircularImageWithurl:(NSString *)url placeholderImage:(UIImage *)image;
@end
