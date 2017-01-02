//
//  LGHTTPSessionManager.m
//  ifaxian
//
//  Created by ming on 16/11/28.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGHTTPSessionManager.h"

@implementation LGHTTPSessionManager


#pragma mark - 初始化方法
- (instancetype)initWithBaseURL:(NSURL *)url{
    if (self = [super initWithBaseURL:url]) {

        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        self.securityPolicy = [self customSecurityPolicy];
    }
    return self;
}
#pragma mark - 获取登录用户的信息
/**
 *  获取登录用户的信息
 *
 *  @param completion 完成回调
 */
- (void)requestUsercompletion:(LGRequestCompletion)completion{
    
    NSString *cookie = [LGNetWorkingManager manager].account.cookie;
    NSString *url = [NSString stringWithFormat:@"https://ifaxian.cc/api/user/get_user_meta?cookie=%@",cookie];
    if ([LGNetWorkingManager manager].account.isOtherLogin) {
        
    }else{
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    [self request:LGRequeTypePOST urlString:url parameters:nil completion:^(BOOL isSuccess, id responseObject) {
        if (completion) {
            
            completion(isSuccess,responseObject);
        }
    }];
}
#pragma mark - 新浪用户登录获取信息
/**
 *  新浪用户登录获取信息
 *
 *  @param completion 完成回调
 */
- (void)requestSinaUsercompletion:(LGRequestCompletion)completion{
    
    NSString *k = [LGNetWorkingManager manager].account.cookie;
    NSString *str = [NSString stringWithFormat:@"https://ifaxian.cc/api/user/get_user_meta?cookie=%@",k];
    [self request:LGRequeTypePOST urlString:str parameters:nil completion:^(BOOL isSuccess, id responseObject) {
        if (completion) {
            
            completion(isSuccess,responseObject);
        }
    }];
}
#pragma mark - 获取首页数据
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
#pragma mark - 获取文章数据
/**
 *  获取文章数据
 *
 *  @param postUrl    请求地址
 *  @param completion 完成回调
 */
- (void)requsetUrl:(NSString *)postUrl completion:(LGRequestCompletion)completion{
    
    [self request:LGRequeTypePOST urlString:postUrl parameters:nil completion:^(BOOL isSuccess, id responseObject) {
        if (completion) {
            completion(isSuccess,responseObject);
        }
    }];
}
#pragma mark - 获取评论的请求方法
/**
 *  获取评论的请求方法
 *
 *  @param postUrl    请求的评论的地址
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
#pragma mark - post请求方法
/**
 *  post请求方法
 *
 *  @param url        请求地址
 *  @param completion 完成回调
 */
- (void)requestPostUrl:(NSString *)url completion:(LGRequestCompletion)completion{
    
    [self request:LGRequeTypePOST urlString:url parameters:nil completion:completion];
}
#pragma mark - 获取分类文章的数据
/**
 *  获取分类文章的数据
 *
 *  @param category   分类的Sulg
 *  @param page       分类的第几页
 *  @param completion 完成回调
 */
- (void)requestPOstCategory:(NSString *)category page:(NSString *)page completion:(LGRequestCompletion)completion{
    NSString *url = [NSString requestBasiPathAppend:@"/api/get_category_posts"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"slug"] = category;
    parameters[@"page"] = page;
    [self request:LGRequeTypePOST urlString:url parameters:parameters completion:completion];
}

#pragma mark - 隔离AFN的请求方法
/**
 *  隔离AFN的请求方法
 *
 *  @param method     请求方法
 *  @param urlString  请求地址
 *  @param parameters 请求参数
 *  @param completion 完成回调
 */
- (void)request:(LGNetMethod)method urlString:(NSString *)urlString parameters:(NSDictionary *)parameters completion:(LGRequestCompletion)completion{
    //成功回调
    void(^success)() = ^(NSURLSessionDataTask * _Nonnull task ,id  _Nullable responseObject) {
        completion(YES,responseObject);
    };
    //失败回调
    void(^failure)() = ^(NSURLSessionDataTask * _Nonnull task ,NSError *error) {
        
        NSHTTPURLResponse *respon = (NSHTTPURLResponse *)task.response;
        if(respon.statusCode == 200){
            completion(YES,nil);
            return ;
        }
        completion(NO,nil);
    };
    if (method == LGRequeTypeGET) {
        [self GET:urlString parameters:parameters success:success failure:failure];
        
    }else{
        [self POST:urlString parameters:parameters success:success failure:failure];
    }
}
#pragma mark - 获取一个授权nonce
/**
 *  获取一个授权nonce
 *
 *  @param argumen    LGRequiredArgumen
 *  @param completion 完成回调
 */
- (void)requestPostNonceArgument:(LGRequiredArgumen)argumen completion:(void(^)(BOOL isSuccess,NSString *nonce))completion{
    
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
        if (completion) {
            completion(isSuccess,responseObject[@"nonce"]);
        }
    }];
}
- (AFSecurityPolicy *)customSecurityPolicy
{
    //先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"ifaxian.cer" ofType:nil];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    // AFSSLPinningModeCertificate 使用证书验证模式
    //AFSSLPinningModeNone: 代表客户端无条件地信任服务器端返回的证书。
    //AFSSLPinningModePublicKey: 代表客户端会将服务器端返回的证书与本地保存的证书中，PublicKey的部分进行校验；如果正确，才继续进行。
    //AFSSLPinningModeCertificate: 代表客户端会将服务器端返回的证书和本地保存的证书中的所有内容，包括PublicKey和证书部分，全部进行校验；如果正确，才继续进行。
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
//    securityPolicy.allowInvalidCertificates = YES;
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    //对应域名的校验我认为应该在url中去逻辑判断。--》冯龙腾写
    securityPolicy.validatesDomainName = YES;
    if (certData) {
        securityPolicy.pinnedCertificates = @[certData];
    }
    return securityPolicy;
}



@end
