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
typedef NS_ENUM(NSInteger , LGNetMethod) {
    LGRequeTypeGET,//get方法
    LGRequeTypePOST,//post方法
};
typedef NS_ENUM(NSInteger , LGRequiredArgumen) {
    LGRequiredArgumenRegister,//注册
    LGRequiredArgumenCreate,//创建
    LGRequiredArgumenUpdate,//跟新
    LGRequiredArgumenDelete,//删除
    
};
- (void)requsetHomelist:(LGRequestCompletion)completion;

- (void)requsetUrl:(NSString *)postUrl completion:(LGRequestCompletion)completion;

- (void)requsetCommentUrl:(NSString *)postUrl completion:(LGRequestCompletion)completion;
- (void)requestPostUrl:(NSString *)url completion:(LGRequestCompletion)completion;
- (void)requestPOstCategory:(NSString *)category page:(NSString *)page completion:(LGRequestCompletion)completion;

- (void)request:(LGNetMethod)method urlString:(NSString *)urlString parameters:(NSDictionary *)parameters completion:(LGRequestCompletion)completion;
- (void)requestUsercompletion:(LGRequestCompletion)completion;

- (void)requestPostNonceArgument:(LGRequiredArgumen)argumen completion:(void(^)(BOOL isSuccess,NSString *nonce))completion;

@end
