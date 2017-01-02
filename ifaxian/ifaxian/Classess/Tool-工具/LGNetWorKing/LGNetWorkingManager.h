//
//  LGNetWorkingManager.h
//  ifaxian
//
//  Created by ming on 16/11/17.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "LGAccount.h"
#import "Single.h"
#import "NSString+LGRequestBasiPath.h"
#import "LGHTTPSessionManager.h"

@interface LGNetWorkingManager : LGHTTPSessionManager
@property(nonatomic, strong) LGAccount *account;
singleH(Net)



/**
 *  隔离AFN方法请求数据
 *
 *  @param method     请求的方法
 *  @param urlString  请求的地址
 *  @param parameters 请求的参数
 *  @param completion 请求结果回调
 */
- (void)requestPostUrl:(NSString *)url completion:(LGRequestCompletion)completion;

/**
 *  判断用户是否登录
 *
 *  @return Bool
 */
- (BOOL)isLogin;




@end
