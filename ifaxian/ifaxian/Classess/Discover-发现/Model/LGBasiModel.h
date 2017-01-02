//
//  LGCategory.h
//  ifaxian
//
//  Created by ming on 16/11/28.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  分类和标签的父模型
 */
@interface LGBasiModel : NSObject
/**
 *  路径
 */
@property(nonatomic, copy) NSString *slug;
/**
 *  描述
 */
@property(nonatomic, copy) NSString *describe;
/**
 *  不知道是什么
 */
@property(nonatomic, copy) NSString *post_count;
/**
 *  标题
 */
@property(nonatomic, copy) NSString *title;
/**
 *  id
 */
@property(nonatomic, copy) NSString *ID;
@end
