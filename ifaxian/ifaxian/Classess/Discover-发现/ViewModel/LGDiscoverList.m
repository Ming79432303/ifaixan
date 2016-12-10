//
//  LGDiscoverList.m
//  ifaxian
//
//  Created by ming on 16/11/28.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGDiscoverList.h"
#import "LGCategory.h"
#import "LGTag.h"
#import "LGPostModel.h"
#import "LGShow.h"

@interface LGDiscoverList()
//分类
@property(nonatomic, strong) NSMutableArray *categories;
//标签
@property(nonatomic, strong) NSMutableArray *tags;
//分类前4条数据
@property(nonatomic, strong) NSMutableArray *categoryposts;
@end;


@implementation LGDiscoverList

- (NSMutableArray *)categoryposts{
    
    if (_categoryposts) {
        _categoryposts = [NSMutableArray array];
    }
    
    return _categoryposts;
}

/**
 *  获取所有分类
 *
 *  @param completion 完成回调
 */
- (void)requestCategroie:(void(^)(NSArray *categories))completion{
 
    NSString *url = [NSString requestBasiPathAppend:@"/api/get_category_index"];
 
   
    [[LGHTTPSessionManager manager] requestPostUrl:url completion:^(BOOL isSuccess, id responseObject) {
  
        if (isSuccess) {
            if (completion) {
                completion( [LGCategory mj_objectArrayWithKeyValuesArray:responseObject[@"categories"]]);
            }
        }
        
    }];
}
/**
 *  获取所有的云标签
 *
 *  @param completion 完成回调
 */
-(void)requestTags:(void(^)(NSArray *tags))completion{
    
    NSString *url = [NSString requestBasiPathAppend:@"/api/get_tag_index"];
    [[LGHTTPSessionManager manager] requestPostUrl:url completion:^(BOOL isSuccess, id responseObject) {
        if (isSuccess) {
           NSMutableArray *tags = [LGTag mj_objectArrayWithKeyValuesArray:responseObject[@"tags"]];
            if (completion) {
                completion(tags);
            }
        }
        
    }];
}

- (void)requestGetcategoryID:(NSString *)categoryID posts:(void(^)(NSArray *categoryposts))completion{
//    get_category_posts?id=1
    
        NSString *url = [NSString requestBasiPathAppend:[NSString stringWithFormat:@"/api/get_category_posts?id=%@&count=4",categoryID]];
    [[LGHTTPSessionManager manager] requestPostUrl:url completion:^(BOOL isSuccess, id responseObject) {
        if (isSuccess) {
           NSMutableArray *posts = [LGPostModel mj_objectArrayWithKeyValuesArray:responseObject[@"posts"]];
            if (posts.count > 4) {
                [posts subarrayWithRange:NSMakeRange(0, 4)];
            }
            if (completion) {
                completion(posts);
            }
        }
        
    }];

}
- (void)getAllCategoriesPosts:(void(^)(NSArray *categoryposts))completion{
    

#warning 循环引用
    //@weakify(self);
    [self requestCategroie:^(NSArray *categories) {
        
        //@strongify(self);
         dispatch_group_t requestGroup = dispatch_group_create();                      
        NSMutableArray *arrM = [NSMutableArray array];
        for (LGCategory *category in categories) {
            
            dispatch_group_enter(requestGroup);
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSLog(@"当前线程%@",[NSThread currentThread]);
                [self requestGetcategoryID:category.ID posts:^(NSArray *categoryposts) {
                    
                    LGShow *showList = [LGShow showTitle:category.title posts:categoryposts];
                    [arrM addObject:showList];
                    
                    dispatch_group_leave(requestGroup);
                   
                }];
                
            });
        }
         dispatch_group_notify(requestGroup, dispatch_get_main_queue(), ^{
        #warning 缓存到磁盘
                completion(arrM);
             
            });

    }];
    
    
    
}


@end
