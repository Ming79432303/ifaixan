//
//  LGShareViewModel.m
//  ifaxian
//
//  Created by ming on 16/11/30.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGShareViewModel.h"
#import "LGShareImage.h"
#import "LGShareViewModel.h"
#import "LGShare.h"
#import <SDWebImageManager.h>
#import "NSURL+LGGetVideoImage.h"
#import "NSString+LGImageStyle.h"
@interface  LGShareViewModel()


@end
@implementation LGShareViewModel{
    NSInteger index_;
}

#pragma mark - 懒加载
- (LGHTTPSessionManager *)manager{
    
    if (_manager == nil) {
        
        _manager = [[LGHTTPSessionManager alloc] init];
    }
    return _manager;
}

- (instancetype)init{
    
    if (self = [super init]) {
        index_ = 2;
    }
    
    return self;
}

- (NSMutableArray *)shareArray{
    
    if (_shareArray == nil) {
        _shareArray = [NSMutableArray array];
    }
    
    return _shareArray;
    
}


#pragma mark - 获取数据方法
/**
 *  获取最新的数据
 *
 *  @param completion 完成回调
 */
-(void)loadNewDatacompletion:(void(^)(BOOL isSuccess ,NSArray<LGShare *> *shareArray))completion{
    LGWeakSelf;
    [self.manager requestPOstCategory:@"share" page:nil completion:^(BOOL isSuccess, id responseObject) {
        
        
        if (isSuccess) {
            index_ = 2;
            //缓存到磁盘
            [[LGSqliteManager shareSqlite] updateDataTableName:@"t_share" dataArray:responseObject[@"posts"]];
        NSMutableArray *shareM = [NSMutableArray array];
        for (NSDictionary *dict in responseObject[@"posts"]) {
         LGShareImage *model = [LGShareImage mj_objectWithKeyValues:dict];
            LGShare *share = [[LGShare alloc] initWithModel:model];
            [shareM addObject:share];
        }
      
            [weakSelf loadImages:shareM isNew:YES Completion:completion];
            
        }else{
            
            completion(NO,nil);
        }
    }];
}

/**
 *  下载单张图片拿到单张图片的frame
 *
 *  @param array      转换数据后的模型
 *  @param isNew      是否是上下拉刷新
 *  @param completion 完成回调
 */
- (void)loadImages:(NSArray *)array isNew:(BOOL)isNew Completion:(void(^)(BOOL isSuccess ,NSArray<LGShare *> *shareArray))completion{
    
    
    //下载图片
    LGWeakSelf;
     //进入组
        dispatch_group_t group = dispatch_group_create();
    //从当前数组中拿出每个分享cell的单条数据
        for (LGShare *share in array) {
        //如果是一张图片
            if (share.images.count==1) {
                dispatch_group_enter(group);
                NSURL *imageUrl = [NSURL URLWithString:share.images.firstObject];
                //下载图片
                [[SDWebImageManager sharedManager] downloadImageWithURL:imageUrl options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    //拿到图片的尺寸
                    CGSize imageSize = image.size;
                    //从新计算行高
                    
                    [share calculateOneHeight:imageSize];
                    //离开组
                    dispatch_group_leave(group);
                }];
            }
        }
    //当所有文字下载完毕后再刷新tableview
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            //如果是下拉刷新直接赋值
            if (isNew) {
                weakSelf.shareArray = [NSMutableArray arrayWithArray:array];
            }else{
            //如果是下拉加载直接添加到数组中
                [weakSelf.shareArray addObjectsFromArray:array];
            }
            //完成回调
            completion(YES,weakSelf.shareArray);
            //下载视频的图片
            [weakSelf downVideoImage:weakSelf.shareArray Completion:completion];
            
            
        });

    
}
/**
 *  获取视频的图片
 *
 *  @param array       转换数据后的模型
 *  @param completion 完成回调
 */
- (void)downVideoImage:(NSArray *)array Completion:(void(^)(BOOL isSuccess ,NSArray<LGShare *> *shareArray))completion{
    
        //下载视频图片
        dispatch_group_t groupVideo = dispatch_group_create();
        LGWeakSelf;
        for (LGShare *share in array) {
    
            if(share.VideoUrl.length){
                //获取图片
                dispatch_group_enter(groupVideo);
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    //获取图片1.0m秒的截图
                    [NSURL thumbnailImageForVideo:[NSURL URLWithString:share.VideoUrl] atTime:1.0 completion:^(UIImage *thumbnailImage) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (thumbnailImage) {
                                share.videoImage = thumbnailImage;
                                dispatch_group_leave(groupVideo);
                                
                            }
                        });
    
                    }];
    
                });
    
    
            }
    
        }
        
    dispatch_group_notify(groupVideo, dispatch_get_main_queue(), ^{
    //视频图片下载完成刷新tableviewView
        completion(YES,weakSelf.shareArray);
        
        });

}
/**
 *  获取下一页
 *
 *  @param completion 完成回调
 */

-(void)loadOldDatacompletion:(void(^)(BOOL isSuccess ,NSArray<LGShare *> *shareArray))completion{
   
    if (index_ < 2) {
        index_ = 2;
    }
    LGWeakSelf;
    [self.manager requestPOstCategory:@"share" page:[NSString stringWithFormat:@"%zd",index_] completion:^(BOOL isSuccess, id responseObject) {

        //        self.images = [LGShareImage mj_objectArrayWithKeyValuesArray:responseObject[@"posts"]];
        NSMutableArray<LGShare *> *shareM = [NSMutableArray array];
#warning  有问题  //判断当前ID进行比较如果数组中的第一个id和我当前获取数据中最后一个
        //原因，因为数据返回来的是按分页来的，我么的数据并不是实时更新，如果当我们的数据更新比较快是那么第一页的数据有可能就变成第二页了，所以我们要在这里进行逻辑判断，取出重复的数据·
            if (weakSelf.shareArray.lastObject.share.ID > weakSelf.shareArray.firstObject.share.ID) {
                
                for (NSDictionary *dict in responseObject[@"posts"]) {
                    LGShareImage *model = [LGShareImage mj_objectWithKeyValues:dict];
                    LGShare *share = [[LGShare alloc] initWithModel:model];
                    [shareM addObject:share];
                }
                
            }else{
                for (NSDictionary *dict in responseObject[@"posts"]) {
                    LGShareImage *model = [LGShareImage mj_objectWithKeyValues:dict];
                    LGShare *share = [[LGShare alloc] initWithModel:model];
                    [shareM addObject:share];
                }

                for (LGShare *model in self.shareArray) {
                    
                    if (![weakSelf.shareArray containsObject:model]) {
                        [shareM addObject:model];
                    }
                    
                }

            }
        if (index_ > [responseObject[@"pages"] integerValue]) {
            completion(isSuccess,nil);
            return ;
        }
            index_ += 1;
        [weakSelf loadImages:shareM isNew:NO Completion:completion];
       
    }];
}
@end

