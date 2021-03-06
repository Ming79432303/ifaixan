//
//  LGRecommendViewModel.m
//  ifaxian
//
//  Created by ming on 16/12/7.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGRecommendViewModel.h"
#import "LGRecommend.h"
@interface LGRecommendViewModel()
@property(nonatomic, strong) NSMutableArray<LGRecommend *> *lists;
@end

@implementation LGRecommendViewModel{
    NSInteger index_;
}


- (NSMutableArray<LGRecommend *> *)lists{
    if (_lists == nil) {
        _lists = [NSMutableArray array];
    }
    return _lists;
    
}

/**
 *  加载新数据
 *
 *  @param completion 完成回调
 */
- (void)loadNewDataCompletion:(void(^)(BOOL isSuccess ,NSArray *array))completion{

    [[LGHTTPSessionManager manager] requestPostUrl:[NSString stringWithFormat:@"https://ifaxian.cc/category/%@/?json=1",self.postName] completion:^(BOOL isSuccess, id responseObject) {
        
        if (isSuccess) {
           
            index_ = 2;
        }
      self.lists = [LGRecommend mj_objectArrayWithKeyValuesArray:responseObject[@"posts"]];
        [self downloadImage:self.lists Completion:completion];
    }];
    
}

/**
 *  加载下一页的数据
 *
 *  @param completion 完成回调
 */
- (void)loadOldDataCompletion:(void(^)(BOOL isSuccess ,NSArray *array))completion{

    [[LGHTTPSessionManager manager] requestPostUrl:[NSString stringWithFormat:@"https://ifaxian.cc/category/%@/?json=1&page=%zd",self.postName,index_] completion:^(BOOL isSuccess, id responseObject) {
        
        NSMutableArray<LGRecommend *> *shareM = [NSMutableArray array];
        shareM = [LGRecommend mj_objectArrayWithKeyValuesArray: responseObject[@"posts"]];
        if (self.lists.lastObject.ID > shareM.firstObject.ID) {
            [self.lists addObjectsFromArray:shareM];
        }else{
             shareM = [LGRecommend mj_objectArrayWithKeyValuesArray: responseObject[@"posts"]];
            [self.lists addObjectsFromArray:shareM];
            for (LGRecommend *model in self.lists) {
                if (![self.lists containsObject:model]) {
                    [self.lists addObject:model];
                }
            }
        }
        if (index_ > [responseObject[@"pages"] integerValue]) {
            completion(isSuccess,nil);
            return ;
        }
        //下载图片
        [self downloadImage:shareM Completion:completion];
        index_ += 1;
    }];
}


/**
 *  下载图片
 *
 *  @param array      转模型后的数据
 *  @param completion 完成回调
 */
- (void)downloadImage:(NSArray<LGRecommend *> *)array Completion:(void(^)(BOOL isSuccess ,NSArray <LGRecommend *>*hotArray))completion{
    //下载图片
    //创建组
    dispatch_group_t group = dispatch_group_create();
    for (LGRecommend *hotModel in array) {
        if (hotModel.content.length) {
            //进去组
            dispatch_group_enter(group);
            NSURL *imageUrl = [NSURL URLWithString:hotModel.imageUrl];
            [[SDWebImageManager sharedManager] downloadImageWithURL:imageUrl options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                //拿到图片的尺寸
                CGSize imageSize = image.size;
                //计算行高
                hotModel.originalImageSize = imageSize;
                //出组
                dispatch_group_leave(group);
            }];
        }
    }
    //全部下载完成回到=调
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        completion(YES,self.lists);
        
    });
}

@end
