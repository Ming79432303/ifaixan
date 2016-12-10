//
//  LGNetWorkingManager+LGExtension.h
//  ifaxian
//
//  Created by Apple_Lzzy27 on 16/11/17.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGNetWorkingManager.h"

@interface LGNetWorkingManager (LGExtension)
/**
 *  获取首页数据
 *
 *  @param completion <#completion description#>
 */
//- (void)requsetHomelist:(LGRequestCompletion)completion;
//
//- (void)requsetUrl:(NSString *)postUrl completion:(LGRequestCompletion)completion;
//
//- (void)requsetCommentUrl:(NSString *)postUrl completion:(LGRequestCompletion)completion;

- (void)requestAuthcookie:(NSString *)userName passWord:(NSString *)passWord completion:(void(^)(BOOL isSuccess, BOOL isSuccessLogin))completion;

- (void)requestPostNonceArgument:(LGRequiredArgumen)argumen completion:(void(^)(BOOL isSuccess,NSString *nonce))completion;

- (void)requestPostThearticleTitle:(NSString *)title content:(NSString *)contentText :(LGSuccess)completion;

- (void)requestUpdateArticleTitle:(NSString *)title content:(NSString *)contentText post_slug:(NSString *)post_slug post_id:(NSString *)post_id contentText :(LGSuccess)completion;

-(void)requestRegiterUserName:(NSString *)userName passWord:(NSString *)passWord email:(NSString *)email completion:(LGSuccess)completion;

- (void)requestRetrievePasswordUserLogin:(NSString *)userlogin completion:(LGSuccess)completion;

- (void)requestPostComment:(NSString *)comment commentPostId:(NSString *)postId commentParent:(NSString *)commentParent completion:(LGSuccess)completion;

- (void)requestSearch:(NSString *)search page:(NSInteger)page completion:(LGRequestCompletion)completion;

- (void)requestPostImageTitle:(NSString *)title content:(NSString *)contentText :(LGSuccess)completion;

- (void)requestAddLikeAction:(NSString *)action umid:(NSString *)ID completion:(LGRequestCompletion)completion;


@end
