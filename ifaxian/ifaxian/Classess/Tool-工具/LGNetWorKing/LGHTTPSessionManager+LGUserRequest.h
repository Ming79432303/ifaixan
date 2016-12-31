//
//  LGHTTPSessionManager+LGUserRequest.h
//  ifaxian
//
//  Created by ming on 16/12/16.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGHTTPSessionManager.h"

@interface LGHTTPSessionManager (LGUserRequest)

-(void)requestRegiterUserName:(NSString *)userName passWord:(NSString *)passWord email:(NSString *)email completion:(LGSuccess)completion;

- (void)requestRetrievePasswordUserLogin:(NSString *)userlogin completion:(LGSuccess)completion;
- (void)requestUserIfo:(NSString *)userName completion:(LGRequestCompletion)completion;
- (void)requestUserAvatar:(NSString *)userId copletion:(void(^)(NSString *url))completion;

@end
