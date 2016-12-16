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

singleM(Net)

- (LGAccount *)account{
    
    if (_account == nil) {
        _account = [[LGAccount alloc] init];
    }
    
    return _account;
}



- (instancetype)initWithBaseURL:(NSURL *)url{
    if (self = [super initWithBaseURL:url]) {
#warning cookie为空处理
      self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        if (![self isLogin]) {
            
            //通知用户登录
            [[NSNotificationCenter defaultCenter] postNotificationName:LGUserLoginNotification object:nil];
        }
        
        //[self.requestSerializer setValue:[NSString stringWithFormat:@"%@=%@",self.account.cookie_name,self.account.cookie] forHTTPHeaderField:@"Cookie"];
               
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

//因为每次请求都依赖于token，所以创建一个带token请求的方法
/**
 *  封装带token方法
 *
 *  @param method     请求的方法
 *  @param urlString  请求的地址
 *  @param parameters 请求的参数
 *  @param completion 请求结果回调
 */
-(void)tokenReques:(LGNetMethod)method urlString:(NSString *)urlString parameters:(NSMutableDictionary *)parameters completion:(LGRequestCompletion)completion{
    
    if (parameters == nil) {
        parameters = [NSMutableDictionary dictionary];
    }
    
    //token为空处理
    if (self.account.cookie) {
        
        parameters[self.account.cookie_name] = self.account.cookie;
    }else{
        //通知登录
        //[[NSNotificationCenter defaultCenter] postNotificationName:UserLoginNitification object:nil];
        
    }
    
    
    
    
    [self request:(LGNetMethod)method urlString:(NSString *)urlString parameters:(NSDictionary *)parameters completion:completion];
}

//
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



@end
