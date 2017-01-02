//
//  LGHTTPSessionManager+LGUserRequest.h
//  ifaxian
//
//  Created by ming on 16/12/16.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGHTTPSessionManager.h"

@interface LGHTTPSessionManager (LGUserRequest)
/**
 *  注册一个用户
 *
 *  @param userName   用户名
 *  @param passWord   密码
 *  @param email      邮箱
 *  @param completion 完成回调
 */
-(void)requestRegiterUserName:(NSString *)userName passWord:(NSString *)passWord email:(NSString *)email completion:(LGSuccess)completion;
/**
 *  忘记密码
 *
 *  @param userlogin  用户名或者邮箱
 *  @param completion 完成回调
 */
- (void)requestRetrievePasswordUserLogin:(NSString *)userlogin completion:(LGSuccess)completion;
/**
 *  获取用户信息
 *
 *  @param userName   用户昵称
 *  @param completion 完成回调
 */
- (void)requestUserIfo:(NSString *)userName completion:(LGRequestCompletion)completion;
/**
 *  获取用户头像
 *
 *  @param userId     用户的ID
 *  @param completion 完成回调
 */
- (void)requestUserAvatar:(NSString *)userId copletion:(void(^)(NSString *url))completion;
/**
 *  获取用户的cookie
 *
 *  @param userName   用户的昵称
 *  @param passWord   用户的密码
 *  @param completion 完成回调
 */
- (void)requestAuthcookie:(NSString *)userName passWord:(NSString *)passWord completion:(void(^)(BOOL isSuccess, BOOL isSuccessLogin))completion;

@end
