//
//  LGUserList.h
//  ifaxian
//
//  Created by ming on 16/12/13.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGUserList : NSObject
/**
 *  标题
 */
@property(nonatomic, copy) NSString *title;
/**
 *  内容
 */
@property(nonatomic, copy) NSString *content;
/**
 *  对应的参数，更新用户数据需要的请求参数
 */
@property(nonatomic, copy) NSString *parameter;
+ (instancetype)userTitle:(NSString *)title content:(NSString *)content parameter:(NSString *)parameter;
@end
