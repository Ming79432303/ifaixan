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







#pragma mark - 发送一篇文章
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
#pragma mark - 发送一条分享的数据
/**
 *  发送一条分享的数据
 *
 *  @param title       帖子的标题
 *  @param contentText 帖子的内容
 *  @param completion  完成回调
 */
- (void)requestPostImageTitle:(NSString *)title content:(NSString *)contentText :(LGSuccess)completion{
    
    [self requestPostNonceArgument:LGRequiredArgumenCreate completion:^(BOOL isSuccess, NSString *nonce) {
        if (isSuccess) {
            NSString *url = [NSString requestBasiPathAppend:@"/api/create_post"];
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            parameters[@"nonce"] = nonce;
            parameters[@"title"] = title;
            parameters[@"content"] = contentText;
            parameters[@"categories"] = @"share";
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



#pragma mark - 更新一篇文章
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

#pragma mark - 发送一条评论
/**
 *  发送一条评论
 *
 *  @param comment       评论内容
 *  @param postId        文章的ID
 *  @param commentParent 父评的ID
 *  @param completion    完成回调
 */
- (void)requestPostComment:(NSString *)comment commentPostId:(NSString *)postId commentParent:(NSString *)commentParent completion:(LGSuccess)completion{
   
   NSString *url = [NSString requestBasiPathAppend:@"/wp-comments-post.php"];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"comment"] = comment;
    parameters[@"comment_post_ID"] = postId;
    parameters[@"comment_parent"] = commentParent;
    parameters[@"submit"] = @"确定";
    [self request:LGRequeTypePOST urlString:url parameters:parameters completion:^(BOOL isSuccess, id responseObject) {
        if (completion) {
            completion(isSuccess);
        }
    }];
}
#pragma mark - 获取搜索的数据
/**
 *  获取搜索的数据
 *
 *  @param search     搜索的内容
 *  @param page       搜索的页码
 *  @param completion 完成回调
 */
- (void)requestSearch:(NSString *)search page:(NSInteger)page completion:(LGRequestCompletion)completion{
    //get方法不能识别中文
    //需要转码
    NSString *parame = [search stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
   NSString *url = [NSString requestBasiPathAppend:[NSString stringWithFormat:@"/?s=%@&json=1&page=%zd",parame,page]];
    [self request:LGRequeTypeGET urlString:url parameters:nil completion:^(BOOL isSuccess, id responseObject) {
        if (completion) {
            completion(isSuccess,responseObject);
        }
    }];
}

#pragma mark -点赞
/**
 *  点赞
 *
 *  @param action     点赞的动作:顶和踩
 *  @param ID         文章的ID
 *
 **/
- (void)requestAddLikeAction:(NSString *)action umid:(NSString *)ID completion:(LGRequestCompletion)completion{
    [self   requestSetProfilecompletion:^(BOOL isSuccess, id responseObject) {
        
    }];
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
#warning 待做
- (void)requestSetProfilecompletion:(LGRequestCompletion)completion{
    
//  NSDictionary *dict = @{@"1":@"Test UserName",@"5":@"About Content :: Lorem Ipsum is simply dummy text of the \n",@"2":@"Male",@"3":@"Native American",@"4":@"Average",@"21":@"Fit",@"32":@"Kosher",@"39":@"Sometimes",@"43":@"Sometimes",@"47":@"English",@"6":@"USA",@"7":@"New York"};
// NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:nil];
//    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"website"] = @"www.baidu.com";
    parameters[@"city"] = @"贵港";
    parameters[@"country"] = @"中国";
    parameters[@"skills"] = @"ios开发";
    parameters[@"cookie"] = self.account.cookie;
    parameters[@"insecure"] = @"cool";
    [self request:LGRequeTypePOST urlString:@"https://ifaxian.cc/api/user/update_user_meta_vars" parameters:parameters completion:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
    }];
    
    
}
#pragma mark - 删除一篇文章

 /**
 *  删除一篇文章
 *
 *  @param post_slug  文章的slug
 *  @param post_id    文章的id
 *  @param completion 完成回调
 */
- (void)requestDeleteArticlePost_slug:(NSString *)post_slug post_id:(NSString *)post_id completion:(LGSuccess)completion{
    
    [self requestPostNonceArgument:LGRequiredArgumenDelete completion:^(BOOL isSuccess, NSString *nonce) {
        if (isSuccess) {
            NSString *url = [NSString requestBasiPathAppend:@"/api/posts/delete_post"];
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            parameters[@"nonce"] = nonce;
            parameters[@"id"] = post_id;
            parameters[@"slug"] = post_slug;
            [self request:LGRequeTypePOST urlString:url parameters:parameters completion:^(BOOL isSuccess, id responseObject) {
                if (completion) {
                    completion(isSuccess);
                }
            }];
        }
    }];
}
#pragma mark -更新用户的cookie
/**
 *  更新用户的cookie
 */
- (void)updateUserCookie{
    
    //自动更新cookie用的
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"updataUserName"];
    NSString *userPas = [[NSUserDefaults standardUserDefaults] objectForKey:@"updataPassword"];
    [self requestAuthcookie:userName passWord:userPas completion:nil];
    
}



@end
