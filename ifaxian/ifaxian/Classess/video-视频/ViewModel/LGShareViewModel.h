//
//  LGShareViewModel.h
//  ifaxian
//
//  Created by ming on 16/11/30.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LGShare.h"

@interface LGShareViewModel : NSObject
/**
 *  网络请求管理者
 */
@property (nonatomic, strong) LGHTTPSessionManager *manager;
/**
 *  分享界面的数据
 */
@property (nonatomic, strong) NSMutableArray<LGShare *> *shareArray;

/**
 *  获取最新数据
 *
 *  @param completion 完成回调
 */
-(void)loadNewDatacompletion:(void(^)(BOOL isSuccess ,NSArray<LGShare *> *shareArray))completion;
/**
 *  获取下一页数据
 *
 *  @param completion 完成回调
 */
-(void)loadOldDatacompletion:(void(^)(BOOL isSuccess ,NSArray<LGShare *> *shareArray))completion;
/**
 *  下载单张图片
 *
 *  @param array      图片数组
 *  @param isNew      是否是下拉刷新
 *  @param completion 完成回调
 */
- (void)loadImages:(NSArray *)array isNew:(BOOL)isNew Completion:(void(^)(BOOL isSuccess ,NSArray<LGShare *> *shareArray))completion;
/**
 *  获取视频图片
 *
 *  @param array      转换模型完毕后的数据
 *  @param completion 完成回调
 */
- (void)downVideoImage:(NSArray *)array Completion:(void(^)(BOOL isSuccess ,NSArray<LGShare *> *shareArray))completion;
@end
