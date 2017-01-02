//
//  NSString+LGRegularExpressions.h
//  ifaxian
//
//  Created by ming on 16/11/24.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LGRegularExpressions)
+ (BOOL)lg_dateEmail:(NSString *)email;
+ (BOOL)lg_datePassword:(NSString *)passWord;
+ (BOOL)lg_dateUserName:(NSString *)name;
+ (NSString *)lg_regularExpression:(NSString *)text;
/**
 *  获取文本中第一个图片url
 *
 *  @param text 需要查找的文本
 *
 *  @return 返回一个url
 */
- (NSString *)lg_getImageUrl;
/**
 *  获取文本中的视频地址
 *
 *  @return 视频地址
 */
- (NSString *)lg_getVideoUrl;
/**
 *  得到最大为6张图片的数组
 *
 *  @return 图片数组
 */
- (NSArray *)lg_getImages;
/**
 *  获取文中全部的图片
 *
 *  @return 图片数组
 */
- (NSArray *)lg_getAllImages;
/**
 *  返回一个(url + title）的数组
 *
 *  @return (url + title）的数组
 */
- (NSArray *)lg_get_lasA_Link_text;
@end
