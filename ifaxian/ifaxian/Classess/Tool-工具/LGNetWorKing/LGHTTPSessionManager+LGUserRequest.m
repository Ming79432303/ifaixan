//
//  LGHTTPSessionManager+LGUserRequest.m
//  ifaxian
//
//  Created by ming on 16/12/16.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGHTTPSessionManager+LGUserRequest.h"

@implementation LGHTTPSessionManager (LGUserRequest)


/**
 *  用户注册
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

/**
 *  忘记密码
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

- (void)requestUserIfo:(NSString *)userName completion:(LGRequestCompletion)completion{
    //http://112.74.45.39/author/ming?json=1&count=1
    
    NSString *url = [NSString stringWithFormat:@"https://ifaxian.cc/author/%@?json=1&count=1",userName];
    
    [self requestPostUrl:url completion:^(BOOL isSuccess, id responseObject) {
       
            if (completion) {
                completion(isSuccess,responseObject);
            }
        
    }];
}

- (void)requestUserAvatar:(NSString *)userId copletion:(void(^)(NSString *url))completion{
    NSString *url = [NSString requestBasiPathAppend:[NSString stringWithFormat:@"/api/user/get_avatar/?user_id=%@&insecure=cool&type=full",userId]];
    [self requestPostUrl:url completion:^(BOOL isSuccess, id responseObject) {
        completion(responseObject[@"avatar"]);
        
    }];

    
    
}


- (void)requestUserIfoList:(NSString *)userName completion:(LGRequestCompletion)completion{
    
    
    NSString *url = @"https://ifaxian.cc/api/user/get_user_meta";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"cookie"] = [LGNetWorkingManager manager].account.cookie;
    parameters[@"insecure"] = @"cool";
    [self request:LGRequeTypeGET urlString:url parameters:parameters completion:^(BOOL isSuccess, id responseObject) {
        completion(isSuccess,responseObject);
    }];
    
}


@end
