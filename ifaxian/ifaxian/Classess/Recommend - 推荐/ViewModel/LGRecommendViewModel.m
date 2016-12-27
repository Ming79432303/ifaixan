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


- (void)loadNewDataCompletion:(void(^)(BOOL isSuccess ,NSArray *array))completion{
    
    [[LGHTTPSessionManager manager] requestPostUrl:[NSString stringWithFormat:@"http://112.74.45.39/category/%@/?json=1",self.postName] completion:^(BOOL isSuccess, id responseObject) {
        
        if (isSuccess) {
            index_ = 2;
        }
      self.lists = [LGRecommend mj_objectArrayWithKeyValuesArray:responseObject[@"posts"]];
        [self downloadImage:self.lists Completion:completion];
        
        
    }];
    
}


- (void)loadOldDataCompletion:(void(^)(BOOL isSuccess ,NSArray *array))completion{
#warning 滑到最后一页出现问题数据有些无图做处理
    [[LGHTTPSessionManager manager] requestPostUrl:[NSString stringWithFormat:@"http://112.74.45.39/category/%@/?json=1&page=%zd",self.postName,index_] completion:^(BOOL isSuccess, id responseObject) {
       
        //        self.images = [LGShareImage mj_objectArrayWithKeyValuesArray:responseObject[@"posts"]];
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
        [self downloadImage:shareM Completion:completion];
        index_ += 1;
     
          
    }];
    



}



- (void)downloadImage:(NSArray<LGRecommend *> *)array Completion:(void(^)(BOOL isSuccess ,NSArray <LGRecommend *>*hotArray))completion{
    //下载图片
    __block   CGFloat lenght = 0;
    dispatch_group_t group = dispatch_group_create();
    for (LGRecommend *hotModel in array) {
    
        if (hotModel.content.length) {
            dispatch_group_enter(group);
            NSURL *imageUrl = [NSURL URLWithString:hotModel.imageUrl];
            [[SDWebImageManager sharedManager] downloadImageWithURL:imageUrl options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                //拿到图片的尺寸
                CGSize imageSize = image.size;
                //计算行高
                //
                lenght += UIImageJPEGRepresentation(image, 1).length;
                
                
                hotModel.originalImageSize = imageSize;
                
                dispatch_group_leave(group);
            }];
        }
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
       
        completion(YES,self.lists);
        
    });
    
    
    
    
}

@end
