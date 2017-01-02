//
//  LGUserItem.h
//  ifaxian
//
//  Created by ming on 16/12/13.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  用户信息模型
 */
@interface LGUserItem : NSObject
/**
 *  标题
 */
@property(nonatomic, copy) NSString *title;
/**
 *  用户的信息
 */
@property(nonatomic, strong) NSArray *userInfos;
+ (instancetype)userGruopTitle:(NSString *)title userInfo:(NSArray *)userInfo; 
@end
