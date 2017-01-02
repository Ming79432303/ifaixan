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
 *  发送一篇文章
 *
 *  @param title       标题
 *  @param contentText 内容
 *  @param completion  完成回调
 */
- (void)requestPostThearticleTitle:(NSString *)title content:(NSString *)contentText :(LGSuccess)completion;
/**
 *  更新一篇文章
 *
 *  @param title       文章的标题
 *  @param contentText 文章的内容
 *  @param slug        文章的slug
 *  @param id          文章的id
 *  @param completion  完成回调
 */
- (void)requestUpdateArticleTitle:(NSString *)title content:(NSString *)contentText post_slug:(NSString *)post_slug post_id:(NSString *)post_id contentText :(LGSuccess)completion;
/**
 *  发送一条评论
 *
 *  @param comment       评论内容
 *  @param postId        文章的ID
 *  @param commentParent 父评的ID
 *  @param completion    完成回调
 */
- (void)requestPostComment:(NSString *)comment commentPostId:(NSString *)postId commentParent:(NSString *)commentParent completion:(LGSuccess)completion;
/**
 *  获取搜索的数据
 *
 *  @param search     搜索的内容
 *  @param page       搜索的页码
 *  @param completion 完成回调
 */
- (void)requestSearch:(NSString *)search page:(NSInteger)page completion:(LGRequestCompletion)completion;
/**
 *  发送一条分享的数据
 *
 *  @param title       帖子的标题
 *  @param contentText 帖子的内容
 *  @param completion  完成回调
 */
- (void)requestPostImageTitle:(NSString *)title content:(NSString *)contentText :(LGSuccess)completion;
/**
 *  点赞
 *
 *  @param action     点赞的动作:顶和踩
 *  @param ID         文章的ID
 *  @param completion 完成回调
 */
- (void)requestAddLikeAction:(NSString *)action umid:(NSString *)ID completion:(LGRequestCompletion)completion;
/**
 *  删除一篇文章
 *
 *  @param post_slug  文章的slug
 *  @param post_id    文章的id
 *  @param completion 完成回调
 */
- (void)requestDeleteArticlePost_slug:(NSString *)post_slug post_id:(NSString *)post_id completion:(LGSuccess)completion;
/**
 *  跟新用户的cookie
 */
- (void)updateUserCookie;

@end
