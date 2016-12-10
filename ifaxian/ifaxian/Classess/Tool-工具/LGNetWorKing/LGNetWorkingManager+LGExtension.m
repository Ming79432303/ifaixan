//
//  LGNetWorkingManager+LGExtension.m
//  ifaxian
//
//  Created by Apple_Lzzy27 on 16/11/17.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGNetWorkingManager+LGExtension.h"
#import "LGAccount.h"
@implementation LGNetWorkingManager (LGExtension)






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
                LGLog(@"%@",account.cookie);
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

- (void)requestPostNonceArgument:(LGRequiredArgumen)argumen completion:(void(^)(BOOL isSuccess,NSString *nonce))completion{
    


    [self.requestSerializer setValue:self.account.cookie forHTTPHeaderField:self.account.cookie_name];
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
    
    if (method == LGRequiredArgumenRegister) {
        url = [NSString requestBasiPathAppend:@"/api/get_nonce/?controller=user&method=register"];
    }
 
    [self request:LGRequeTypePOST urlString:url parameters:nil completion:^(BOOL isSuccess, id responseObject) {
        if (completion) {
            
            completion(isSuccess,responseObject[@"nonce"]);
        }
        
    }];


    
}
/**
 *  发送一篇文章
 *
 *  @param title       标题
 *  @param contentText 内容
 *  @param completion  完成回调
 */
- (void)requestPostThearticleTitle:(NSString *)title content:(NSString *)contentText :(LGSuccess)completion{
    
    [self requestPostNonceArgument:LGRequiredArgumenCreate completion:^(BOOL isSuccess, NSString *nonce) {
        if (isSuccess) {
       NSString *url = [NSString requestBasiPathAppend:@"/api/create_post"];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"nonce"] = nonce;
        parameters[@"title"] = title;
        parameters[@"content"] = contentText;
        parameters[@"status"] = @"publish";
        [self request:LGRequeTypePOST urlString:url parameters:parameters completion:^(BOOL isSuccess, id responseObject) {
       
            if (completion) {
                
                completion(isSuccess);
            }
            
        }];

     }
        
    }];
    
   
}


- (void)requestPostImageTitle:(NSString *)title content:(NSString *)contentText :(LGSuccess)completion{
    
    [self requestPostNonceArgument:LGRequiredArgumenCreate completion:^(BOOL isSuccess, NSString *nonce) {
        if (isSuccess) {
            NSString *url = [NSString requestBasiPathAppend:@"/api/create_post"];
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            parameters[@"nonce"] = nonce;
            parameters[@"title"] = title;
            parameters[@"content"] = contentText;
            parameters[@"categories"] = @"images";
            parameters[@"status"] = @"publish";
            [self request:LGRequeTypePOST urlString:url parameters:parameters completion:^(BOOL isSuccess, id responseObject) {
                
                if (completion) {
                    
                    completion(isSuccess);
                }
                
            }];
            
        }else{
            
            completion(isSuccess);
        }
        
    }];
    
   
}




/**
 *  更新一篇文章
 *
 *  @param title       文章的标题
 *  @param contentText 文章的内容
 *  @param LGRequeTypePOST_slug   slug
 *  @param LGRequeTypePOST_id     文章的id
 *  @param completion  完成回调
 */
- (void)requestUpdateArticleTitle:(NSString *)title content:(NSString *)contentText post_slug:(NSString *)post_slug post_id:(NSString *)post_id contentText :(LGSuccess)completion{
    
    [self requestPostNonceArgument:LGRequiredArgumenUpdate completion:^(BOOL isSuccess, NSString *nonce) {
        if (isSuccess) {
        //    NSString *url = @"http://112.74.45.39/api/LGRequeTypePOSTs/update_LGRequeTypePOST";
     //  NSString *url  =  @"http://112.74.45.39/api/LGRequeTypePOSTs/update_LGRequeTypePOST/?nonce=b80590f86e&title=7878&content=123&status=publish&id=3349&slug=123";

         NSString *url = [NSString requestBasiPathAppend:@"/api/posts/update_post"];
            
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            parameters[@"nonce"] = nonce;
            parameters[@"title"] = title;
            parameters[@"slug"] = post_slug;
            parameters[@"content"] = contentText;
            parameters[@"status"] = @"publish";
            [self request:LGRequeTypePOST urlString:url parameters:parameters completion:^(BOOL isSuccess, id responseObject) {
                if (completion) {
                     completion(isSuccess);
                }
            }];
            
        }
        
    }];
    
    
}

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
//http://112.74.45.39/wp-comments-LGRequeTypePOST.php
//
//comment=这个世界是非常大的&comment_LGRequeTypePOST_ID=3312&comment_parent=0

- (void)requestPostComment:(NSString *)comment commentPostId:(NSString *)postId commentParent:(NSString *)commentParent completion:(LGSuccess)completion{
   
   NSString *url = [NSString requestBasiPathAppend:@"/wp-comments-post.php"];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"comment"] = comment;
    parameters[@"comment_post_ID"] = postId;
    parameters[@"comment_parent"] = commentParent;
    [self request:LGRequeTypePOST urlString:url parameters:parameters completion:^(BOOL isSuccess, id responseObject) {
        if (completion) {
            completion(isSuccess);
        }
    }];
}
//?search=ming&count=20&page=1


- (void)requestSearch:(NSString *)search page:(NSInteger)page completion:(LGRequestCompletion)completion{
    
//    NSString *url = @"http://ifaxian.cc/api/get_search_results";
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    parameters[@"search"] = search;
//    parameters[@"count"] =@"10";
//    parameters[@"page"] =[NSString stringWithFormat:@"%zd",page];
   NSString *url = [NSString requestBasiPathAppend:[NSString stringWithFormat:@"/?s=%@&json=1&page=%zd",search,page]];
    
   
    [self request:LGRequeTypeGET urlString:url parameters:nil completion:^(BOOL isSuccess, id responseObject) {
        if (completion) {
            completion(isSuccess,responseObject);
        }
        
    }];
    
    
    
}


- (void)requestAddLikeAction:(NSString *)action umid:(NSString *)ID completion:(LGRequestCompletion)completion{
    
    NSString *url = [NSString requestBasiPathAppend:@"/wp-admin/admin-ajax.php"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"action"] = action;
    parameters[@"um_id"] = ID;
    parameters[@"um_action"] = @"ding";
    
 
    
    [self request:LGRequeTypePOST urlString:url parameters:parameters completion:^(BOOL isSuccess, id responseObject) {
        if (completion) {
            completion(isSuccess,responseObject);
        }
        
    }];

    
}





@end
