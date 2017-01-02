//
//  LGAccount.h
//  ifaxian
//
//  Created by ming on 16/11/20.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LGAccountUser.h"
@interface LGAccount : NSObject
/**
 *  授权cookie
 */
@property(nonatomic, copy) NSString *cookie;
/**
 * 授权cookie民粹
 */
@property(nonatomic, copy) NSString *cookie_name;
/**
 *  账户模型
 */
@property(nonatomic, strong) LGAccountUser *user;
/**
 *  判断用户是用哪种方式否登录的
 */
@property(nonatomic, assign) BOOL isOtherLogin;
/**
 *  保存账户数据
 */
- (void)accountSave;
/**
 *  读取账户数据
 */
- (void)readAccount;

@end
