//
//  LGHTTPSessionManager.m
//  ifaxian
//
//  Created by ming on 16/11/28.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGHTTPSessionManager.h"

@implementation LGHTTPSessionManager




- (void)requestUsercompletion:(LGRequestCompletion)completion{
    
    NSString *url = @"http://112.74.45.39/api/user/get_user_meta";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"cookie"] = [LGNetWorkingManager manager].account.cookie;
    parameters[@"insecure"] = @"cool";
    [self request:LGRequeTypeGET urlString:url parameters:parameters completion:^(BOOL isSuccess, id responseObject) {
        if (completion) {
            
            completion(isSuccess,responseObject);
        }
    }];
}



/**
 *  获取首页数据
 *
 *  @param completion 结果回调
 */
- (void)requsetHomelist:(LGRequestCompletion)completion{
    
    [self request:LGRequeTypePOST urlString:[NSString requestBasiPathAppend:@"/category/home/?json=1"] parameters:nil completion:^(BOOL isSuccess, id responseObject) {
        if (completion) {
            completion(isSuccess,responseObject[@"posts"]);
        }
        
        
    }];
    
}
/**
 *  回去文章数据
 *
 *  @param LGRequeTypePOSTUrl    请求地址
 *  @param completion 完成回调
 */
- (void)requsetUrl:(NSString *)postUrl completion:(LGRequestCompletion)completion{
    
    
    [self request:LGRequeTypePOST urlString:postUrl parameters:nil completion:^(BOOL isSuccess, id responseObject) {
        
        
        if (completion) {
            completion(isSuccess,responseObject[@"posts"]);
        }
        
        
    }];
    
}
/**
 *  获取评论的请求方法
 *
 *  @param LGRequeTypePOSTUrl    请求的评论的地址
 *  @param completion 完成回调
 */
- (void)requsetCommentUrl:(NSString *)postUrl completion:(LGRequestCompletion)completion{
    
    
    [self request:LGRequeTypeGET urlString:postUrl parameters:nil completion:^(BOOL isSuccess, id responseObject) {
        
        NSDictionary *post = responseObject[@"post"];
        NSArray *array = post[@"comments"];
        if (completion) {
            completion(isSuccess,array);
        }
        
        
    }];
    
}


- (void)requestPostUrl:(NSString *)url completion:(LGRequestCompletion)completion{
    
    [self request:LGRequeTypePOST urlString:url parameters:nil completion:completion];
    
    
}

- (void)requestPOstCategory:(NSString *)category page:(NSString *)page completion:(LGRequestCompletion)completion{
    NSString *url = [NSString requestBasiPathAppend:@"/api/get_category_posts"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"slug"] = category;
    parameters[@"page"] = page;
    [self request:LGRequeTypePOST urlString:url parameters:parameters completion:completion];
    
}



- (void)request:(LGNetMethod)method urlString:(NSString *)urlString parameters:(NSDictionary *)parameters completion:(LGRequestCompletion)completion{
    
    
    //成功回调
    void(^success)() = ^(NSURLSessionDataTask * _Nonnull task ,id  _Nullable responseObject) {
        completion(YES,responseObject);
        
    };
    //失败回调
    void(^failure)() = ^(NSURLSessionDataTask * _Nonnull task ,NSError *error) {
#warning 403 token过期处理
        NSLog(@"%@",error);
        NSHTTPURLResponse *respon = (NSHTTPURLResponse *)task.response;
        
        
        if(respon.statusCode == 200){
            completion(YES,nil);
            
            return ;
            
        }
        NSLog ( @"operation: %@" ,task.response);
        // [SVProgressHUD showErrorWithStatus:@"请求失败"];
        completion(NO,nil);
        
    };
    if (method == LGRequeTypeGET) {
        
        [self GET:urlString parameters:parameters success:success failure:failure];
        
        
    }else{
        
        [self POST:urlString parameters:parameters success:success failure:failure];
        
    }
    
    
    
}

- (void)requestPostNonceArgument:(LGRequiredArgumen)argumen completion:(void(^)(BOOL isSuccess,NSString *nonce))completion{
    
    
    
    //[self.requestSerializer setValue:self.account.cookie forHTTPHeaderField:self.account.cookie_name];
    NSString *method;
    switch (argumen) {
            
        case LGRequiredArgumenRegister:
            method = @"register";
            break;
        case LGRequiredArgumenCreate:
            method = @"create_post";
            break;
        case LGRequiredArgumenUpdate:
            method = @"update_post";
            break;
        case LGRequiredArgumenDelete:
            method = @"delete_post";
            break;
    }
    
    NSString *url = [NSString requestBasiPathAppend:[NSString stringWithFormat:@"/api/get_nonce/?controller=posts&method=%@",method]];
    
    if (argumen == LGRequiredArgumenRegister) {
        url = [NSString requestBasiPathAppend:@"/api/get_nonce/?controller=user&method=register"];
    }
    
    [self request:LGRequeTypePOST urlString:url parameters:nil completion:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (completion) {
            
            completion(isSuccess,responseObject[@"nonce"]);
        }
        
    }];
    
    
    
}


@end
