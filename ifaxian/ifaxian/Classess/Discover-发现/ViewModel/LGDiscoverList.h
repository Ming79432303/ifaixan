//
//  LGDiscoverList.h
//  ifaxian
//
//  Created by ming on 16/11/28.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGDiscoverList : NSObject
/**
 *  获取单个分类数据
 *
 *  @param completion 单个分类数据数组
 */
- (void)requestCategroie:(void(^)(NSArray *categories))completion;
/**
 *  获取分类展示数据每个分类的前4篇数据
 *
 *  @param completion 分类数据数组
 */
- (void)getAllCategoriesPosts:(void(^)(NSArray *categoryposts))completion;
/**
 *  获取所有标签数据
 *
 *  @param completion 标签数据
 */
- (void)requestTags:(void(^)(NSArray *tags))completion;
/**
 *  获取用户的最新动态
 *
 *  @param completion 用户动态的数据
 */
- (void)getActivity_get_activities:(void(^)(BOOL isSuccess , NSArray *activities))completion;
@end
