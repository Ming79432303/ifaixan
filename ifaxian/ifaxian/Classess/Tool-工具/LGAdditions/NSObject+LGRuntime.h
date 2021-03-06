//
//  NSObject+lgRuntime.h
//
//  Created by ming on 16/6/11.
//  Copyright © 2016年 ming All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (lgRuntime)

/// 使用字典数组创建当前类对象的数组
///
/// @param array 字典数组
///
/// @return 当前类对象的数组
+ (NSArray *)lg_objectsWithArray:(NSArray *)array;

/// 返回当前类的属性数组
///
/// @return 属性数组
+ (NSArray *)lg_propertiesList;

/// 返回当前类的成员变量数组
///
/// @return 成员变量数组
+ (NSArray *)lg_ivarsList;

@end
