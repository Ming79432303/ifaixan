//
//  LGNetWorkingManager.m
//  ifaxian
//
//  Created by ming on 16/11/17.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGNetWorkingManager.h"


@interface LGNetWorkingManager()

@property(nonatomic, strong) NSURLSessionDataTask *task;
@end

@implementation LGNetWorkingManager
#pragma mark - d单列
singleM(Net)
#pragma mark - 懒加载
- (LGAccount *)account{
    
    if (_account == nil) {
        _account = [[LGAccount alloc] init];
    }
    
    return _account;
}



- (instancetype)initWithBaseURL:(NSURL *)url{
    if (self = [super initWithBaseURL:url]) {

      //self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        
        
    }
    
    return self;
}
/**
 *  判断是否已经登录
 *
 *  @return 是否登录,已经登录返回yes
 */
- (BOOL)isLogin{
    
    
    return self.account.cookie.length;
    
}

/**
 *  封装afn方法
 *
 *  @param method     请求的方法
 *  @param urlString  请求的地址
 *  @param parameters 请求的参数
 *  @param completion 请求结果回调
 */

- (void)requestPostUrl:(NSString *)url completion:(LGRequestCompletion)completion{
    
    [self request:LGRequeTypePOST urlString:url parameters:nil completion:completion];
    
    
}
/**
 *  网络请求方法
 *
 *  @param method     方法类型get/post
 *  @param urlString  请求的地址
 *  @param parameters 请求的参数
 *  @param completion 完成回调
 */
- (void)request:(LGNetMethod)method urlString:(NSString *)urlString parameters:(NSDictionary *)parameters completion:(LGRequestCompletion)completion{
    
    if (![self isLogin]) {
        //通知用户登录
        [[NSNotificationCenter defaultCenter] postNotificationName:LGUserLoginNotification object:nil];
    }else{
        //添加cookie到请求中
        [self.requestSerializer setValue:[NSString stringWithFormat:@"%@=%@",self.account.cookie_name,self.account.cookie] forHTTPHeaderField:@"Cookie"];
    }
    //执行父类方法
    [super request:method urlString:urlString parameters:parameters completion:completion];
    
}


@end
