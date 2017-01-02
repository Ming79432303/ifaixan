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
#import "LGActivitie.h"
#import "LGActivityUser.h"

@interface LGDiscoverList()
//分类
@property(nonatomic, strong) NSMutableArray *categories;
//标签
@property(nonatomic, strong) NSMutableArray *tags;
//分类前4条数据
@property(nonatomic, strong) NSMutableArray *categoryposts;
//活动数据
@property(nonatomic, strong) NSMutableArray *activities;
@property(nonatomic, strong) LGHTTPSessionManager *manager;
@end;


@implementation LGDiscoverList

#pragma mark - 懒加载
- (LGHTTPSessionManager *)manager{
    if (_manager == nil) {
        _manager = [LGHTTPSessionManager manager];
    }
    
    return _manager;
}


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
    [self.manager requestPostUrl:url completion:^(BOOL isSuccess, id responseObject) {
        if (isSuccess) {
           NSMutableArray *tags = [LGTag mj_objectArrayWithKeyValuesArray:responseObject[@"tags"]];
            if (completion) {
                completion(tags);
            }
        }
        
    }];
}
/**
 *  获取单个分类数据的前4条数据
 *
 *  @param categoryID 分类的id
 *  @param completion 完成回调
 */
- (void)requestGetcategoryID:(NSString *)categoryID posts:(void(^)(NSArray *categoryposts))completion{
//    get_category_posts?id=1
    
        NSString *url = [NSString requestBasiPathAppend:[NSString stringWithFormat:@"/api/get_category_posts?id=%@&count=4",categoryID]];
    [self.manager  requestPostUrl:url completion:^(BOOL isSuccess, id responseObject) {
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
/**
 *  获取所有分类的前4条数据
 *
 *  @param completion 完成回调
 */
- (void)getAllCategoriesPosts:(void(^)(NSArray *categoryposts))completion{
    
    //@weakify(self);
    [self requestCategroie:^(NSArray *categories) {
        
        //@strongify(self);
         dispatch_group_t requestGroup = dispatch_group_create();                      
        NSMutableArray *arrM = [NSMutableArray array];
        for (LGCategory *category in categories) {
            
            dispatch_group_enter(requestGroup);
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                if ([category.title isEqualToString:@"首页"]||[category.title isEqualToString:@"文章"] || [category.title isEqualToString:@"早报"] || [category.title isEqualToString:@"分享"]) {
                     dispatch_group_leave(requestGroup);
                    return ;
                }
                [self requestGetcategoryID:category.ID posts:^(NSArray *categoryposts) {
                    
                    LGShow *showList = [LGShow showTitle:category.title posts:categoryposts];
                    [arrM addObject:showList];
                    
                    dispatch_group_leave(requestGroup);
                   
                }];
                
            });
        }
         dispatch_group_notify(requestGroup, dispatch_get_main_queue(), ^{
             NSString *fileName = @"show.plist";
             NSString *path = [fileName lg_appendDocumentDir];
             [NSKeyedArchiver archiveRootObject:arrM toFile:path];
             completion(arrM);
            });

    }];
    
    
    
}
/**
 *  或去全站动态
 *
 *  @param completion 回调数据
 */
- (void)getActivity_get_activities:(void(^)(BOOL isSuccess , NSArray *activities))completion{
    NSString *url = [NSString requestBasiPathAppend:@"/api/buddypressread/activity_get_activities"];
    LGWeakSelf;
    [self.manager  request:LGRequeTypePOST urlString:url parameters:nil completion:^(BOOL isSuccess, id responseObject) {
        NSArray *activities;
    self.activities = [LGActivitie mj_objectArrayWithKeyValuesArray:responseObject[@"activities"]];
        if (weakSelf.activities.count > 20) {
       activities = [weakSelf.activities subarrayWithRange:NSMakeRange(0, 20)];
        completion(isSuccess,activities);
        return ;
        }
        completion(isSuccess,weakSelf.activities);
    }];
//    
    
    
}




@end
