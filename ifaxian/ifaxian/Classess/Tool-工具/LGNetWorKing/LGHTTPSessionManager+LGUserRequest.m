//
//  LGHTTPSessionManager+LGUserRequest.m
//  ifaxian
//
//  Created by ming on 16/12/16.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGHTTPSessionManager+LGUserRequest.h"

@implementation LGHTTPSessionManager (LGUserRequest)
#pragma mark - 注册一个用户
/**
 *  注册一个用户
 *
 *  @param userName   用户名
 *  @param passWord   密码
 *  @param email      邮箱
 *  @param completion 完成回调
 */
-(void)requestRegiterUserName:(NSString *)userName passWord:(NSString *)passWord email:(NSString *)email completion:(LGSuccess)completion{
    
    [self requestPostNonceArgument:LGRequiredArgumenRegister completion:^(BOOL isSuccess, NSString *nonce) {
        NSString *url = [NSString requestBasiPathAppend:@"/api/user/register"];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"nonce"] = nonce;
        parameters[@"username"] = userName;
        parameters[@"user_pass"] = passWord;
        parameters[@"email"] = email;
        parameters[@"display_name"] = userName;
        parameters[@"notify"] = @"both";
        parameters[@"insecure"] = @"cool";
        [self request:LGRequeTypePOST urlString:url parameters:parameters completion:^(BOOL isSuccess, id responseObject) {
            if (!completion) {
                return ;
            }
            if (isSuccess) {
                if (!responseObject[@"error"]) {
                    completion(YES);
                }else{
                    completion(NO);
                }
            }else{
                completion(NO);
            }
        }];
    }];
    
}
#pragma mark - 忘记密码
/**
 *  忘记密码
 *
 *  @param userlogin  用户名或者邮箱
 *  @param completion 完成回调
 */
- (void)requestRetrievePasswordUserLogin:(NSString *)userlogin completion:(LGSuccess)completion{
    NSString *url = [NSString requestBasiPathAppend:@"/api/user/retrieve_password"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"user_login"] = userlogin;
    parameters[@"insecure"] = @"cool";
    [self request:LGRequeTypePOST urlString:url parameters:parameters completion:^(BOOL isSuccess, id responseObject) {
        if (!completion) {
            return ;
        }
        if (isSuccess) {
            if ([responseObject[@"status"] isEqualToString:@"ok"]) {
                completion(YES);
            }else{
                completion(NO);
            }
        }else{
            
            completion(isSuccess);
        }
    }];
}
#pragma mark - 获取用户信息
/**
 *  获取用户信息
 *
 *  @param userName   用户昵称
 *  @param completion 完成回调
 */
- (void)requestUserIfo:(NSString *)userName completion:(LGRequestCompletion)completion{
    
    NSString *url = [NSString stringWithFormat:@"https://ifaxian.cc/author/%@?json=1&count=1",userName];
    [self requestPostUrl:url completion:^(BOOL isSuccess, id responseObject) {
            if (completion) {
                completion(isSuccess,responseObject);
            }
    }];
}
#pragma mark - 获取用户头像
/**
 *  获取用户头像
 *
 *  @param userId     用户的ID
 *  @param completion 完成回调
 */
- (void)requestUserAvatar:(NSString *)userId copletion:(void(^)(NSString *url))completion{
    NSString *url = [NSString requestBasiPathAppend:[NSString stringWithFormat:@"/api/user/get_avatar/?user_id=%@&insecure=cool&type=full",userId]];
    [self requestPostUrl:url completion:^(BOOL isSuccess, id responseObject) {
        completion(responseObject[@"avatar"]);
    }];
}
#pragma mark - 获取用户信息
/**
 *  获取用户信息
 *
 *  @param userName   用户名
 *  @param completion 完成回调
 */
- (void)requestUserIfoList:(NSString *)userName completion:(LGRequestCompletion)completion{
    
    NSString *url = @"https://ifaxian.cc/api/user/get_user_meta";
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"cookie"] = [LGNetWorkingManager manager].account.cookie;
    parameters[@"insecure"] = @"cool";
    [self request:LGRequeTypeGET urlString:url parameters:parameters completion:^(BOOL isSuccess, id responseObject) {
        completion(isSuccess,responseObject);
    }];
    
}
#pragma mark - 获取用户的cookie
/**
 *  获取用户的cookie
 *
 *  @param userName   用户的昵称
 *  @param passWord   用户的密码
 *  @param completion 完成回调
 */
- (void)requestAuthcookie:(NSString *)userName passWord:(NSString *)passWord completion:(void(^)(BOOL isSuccess, BOOL isSuccessLogin))completion{

    NSString *url = [NSString requestBasiPathAppend:@"/api/user/generate_auth_cookie"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"username"] = userName;
    parameters[@"password"] = passWord;
    parameters[@"insecure"] = @"cool";
    [self request:LGRequeTypePOST urlString:url parameters:parameters completion:^(BOOL isSuccess, id responseObject) {
        if (responseObject[@"error"]) {
            completion(isSuccess,NO);
        }else{
            if (isSuccess) {
                //字典专模型
                LGAccount *account = [LGAccount mj_objectWithKeyValues:responseObject];
                //保存用户数据
                [account accountSave];
                if (completion) {
                    completion(isSuccess,YES);
                }
                NSHTTPCookieStorage * cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
                [cookieStorage setCookie:[[NSHTTPCookie alloc] initWithProperties:@{account.cookie_name:account.cookie}]];
            }
        }
    }];
}

@end
