//
//  LGHeaderModel.h
//  ifaxian
//
//  Created by ming on 16/12/31.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGHeaderModel : NSObject
/**
 *  发现轮播器的图片
 */
@property(nonatomic, copy) UIImage *image;
/**
 *  点击轮播器的url
 */
@property(nonatomic, copy) NSString *url;
/**
 *  创建模型的类方法
 *
 *  @param image 图
 *  @param url   url
 *
 *  @return 发现界面轮播器模型
 */
+ (instancetype)headerImage:(UIImage *)image url:(NSString *)url;
@end
