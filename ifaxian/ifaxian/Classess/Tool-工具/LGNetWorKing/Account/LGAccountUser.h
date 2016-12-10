//
//  LGAccountUser.h
//  ifaxian
//
//  Created by ming on 16/11/20.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGAccountUser : NSObject
/**
 *  用户昵称
 */
@property(nonatomic, copy) NSString *nickname;
/**
 *  用户ID
 */
@property(nonatomic, copy) NSString *ID;
/**
 *  用户注册时间
 */
@property(nonatomic, copy) NSString *registered;
/**
 *  用户邮箱
 */
@property(nonatomic, copy) NSString *email;
/**
 *  用户名
 */
@property(nonatomic, copy) NSString *username;
/**
 *  是否为管理员
 */
@property(nonatomic, assign) NSDictionary *capabilities;
//@property(nonatomic, copy) NSString *description;
@end
