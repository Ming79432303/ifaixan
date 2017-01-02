//
//  LGHTTPSessionManager.h
//  ifaxian
//
//  Created by ming on 16/11/28.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
typedef void(^LGRequestCompletion)(BOOL isSuccess,id responseObject);
typedef void(^LGSuccess)(BOOL isSuccess);
@interface LGHTTPSessionManager : AFHTTPSessionManager
/**
 *  网络请求类型
 */
typedef NS_ENUM(NSInteger , LGNetMethod) {
    /**
     *  GET请求
     */
    LGRequeTypeGET,
    /**
     *  POST请求
     */
    LGRequeTypePOST,
};
/**
 *  用户请求操作类型
 */
typedef NS_ENUM(NSInteger , LGRequiredArgumen) {
    /**
     *  注册一个用户
     */
    LGRequiredArgumenRegister,
    /**
     *  发布一篇文章
     */
    LGRequiredArgumenCreate,
    /**
     *  更新一篇文章
     */
    LGRequiredArgumenUpdate,
    /**
     *  删除一篇文章
     */
    LGRequiredArgumenDelete,
};
/**
 *  获取首页数据
 *
 *  @param completion 完成回调
 */
- (void)requsetHomelist:(LGRequestCompletion)completion;
/**
 *  获取文章数据
 *
 *  @param LGRequeTypePOSTUrl    请求地址
 *  @param completion 完成回调
 */
- (void)requsetUrl:(NSString *)postUrl completion:(LGRequestCompletion)completion;
/**
 *  获取评论的请求方法
 *
 *  @param postUrl    文章的地址
 *  @param completion 完成回调
 */
- (void)requsetCommentUrl:(NSString *)postUrl completion:(LGRequestCompletion)completion;
/**
 *  post请求方法
 *
 *  @param url        请求地址
 *  @param completion 完成回调
 */
- (void)requestPostUrl:(NSString *)url completion:(LGRequestCompletion)completion;
/**
 *  获取分类文章的数据
 *
 *  @param category   分类的Sulg
 *  @param page       分类的第几页
 *  @param completion 完成回调
 */
- (void)requestPOstCategory:(NSString *)category page:(NSString *)page completion:(LGRequestCompletion)completion;
/**
 *  隔离AFN的请求方法
 *
 *  @param method     请求方法
 *  @param urlString  请求地址
 *  @param parameters 请求参数
 *  @param completion 完成回调
 */
- (void)request:(LGNetMethod)method urlString:(NSString *)urlString parameters:(NSDictionary *)parameters completion:(LGRequestCompletion)completion;
/**
 *  获取登录用户的信息
 *
 *  @param completion 完成回调
 */
- (void)requestUsercompletion:(LGRequestCompletion)completion;
/**
 *  获取一个授权nonce
 *
 *  @param argumen    LGRequiredArgumen
 *  @param completion 完成回调
 */
- (void)requestPostNonceArgument:(LGRequiredArgumen)argumen completion:(void(^)(BOOL isSuccess,NSString *nonce))completion;
/**
 *  新浪用户登录获取信息
 *
 *  @param completion 完成回调
 */
- (void)requestSinaUsercompletion:(LGRequestCompletion)completion;


@end
