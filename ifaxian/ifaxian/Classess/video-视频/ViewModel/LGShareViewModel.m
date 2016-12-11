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

-(void)loadNewDatacompletion:(void(^)(BOOL isSuccess ,NSArray<LGShare *> *shareArray))completion{
    
    [self.manager requestPOstCategory:@"images" page:nil completion:^(BOOL isSuccess, id responseObject) {
        if (isSuccess) {
            index_ = 2;
        NSMutableArray *shareM = [NSMutableArray array];
        for (NSDictionary *dict in responseObject[@"posts"]) {
         LGShareImage *model = [LGShareImage mj_objectWithKeyValues:dict];
            LGShare *share = [[LGShare alloc] initWithModel:model];
            [shareM addObject:share];
        }
      
            [self loadImages:shareM isNew:YES Completion:completion];
            
        }else{
            
            completion(NO,nil);
        }
    }];
}


- (void)loadImages:(NSArray *)array isNew:(BOOL)isNew Completion:(void(^)(BOOL isSuccess ,NSArray<LGShare *> *shareArray))completion{
    
    
        //下载图片
        dispatch_group_t group = dispatch_group_create();
        for (LGShare *share in array) {
            
            if (share.images.count==1) {
                dispatch_group_enter(group);
                NSURL *imageUrl = [NSURL URLWithString:share.images.firstObject];
                [[SDWebImageManager sharedManager] downloadImageWithURL:imageUrl options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    //拿到图片的尺寸
                    CGSize imageSize = image.size;
                    //计算行高
                    
                    [share calculateOneHeight:imageSize];
                    
                    dispatch_group_leave(group);
                }];
            }
        }
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            if (isNew) {
                self.shareArray = [NSMutableArray arrayWithArray:array];
                
            }else{
                
                [self.shareArray addObjectsFromArray:array];
            }
            
            completion(YES,self.shareArray);
            
            [self downVideoImage:self.shareArray Completion:completion];
            
            
        });

        

    
    
   
    
}

- (void)downVideoImage:(NSArray *)array Completion:(void(^)(BOOL isSuccess ,NSArray<LGShare *> *shareArray))completion{
    
    
        //下载视频图片
        dispatch_group_t groupVideo = dispatch_group_create();
    
        for (LGShare *share in array) {
    
            if(share.VideoUrl.length){
                //获取图片
                dispatch_group_enter(groupVideo);
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
    
                    [NSURL thumbnailImageForVideo:[NSURL URLWithString:share.VideoUrl] atTime:2 completion:^(UIImage *thumbnailImage) {
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
        
        
        completion(YES,self.shareArray);
        
        });

}

-(void)loadOldDatacompletion:(void(^)(BOOL isSuccess ,NSArray<LGShare *> *shareArray))completion{
   
    
    [self.manager requestPOstCategory:@"images" page:[NSString stringWithFormat:@"%zd",index_] completion:^(BOOL isSuccess, id responseObject) {
        
        //        self.images = [LGShareImage mj_objectArrayWithKeyValuesArray:responseObject[@"posts"]];
        NSMutableArray<LGShare *> *shareM = [NSMutableArray array];
        
            if (self.shareArray.lastObject.share.ID > self.shareArray.firstObject.share.ID) {
                
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
                    
                    if (![self.shareArray containsObject:model]) {
                        [shareM addObject:model];
                    }
                    
                }

            }
        if (index_ > [responseObject[@"pages"] integerValue]) {
            completion(isSuccess,nil);
            return ;
        }
            index_ += 1;
        [self loadImages:shareM isNew:NO Completion:completion];
       
    }];
}
@end

