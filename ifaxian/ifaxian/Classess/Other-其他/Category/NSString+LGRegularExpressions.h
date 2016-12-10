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
- (NSString *)lg_getVideoUrl;
- (NSArray *)lg_getImages;
- (NSArray *)lg_getAllImages;
@end
