//
//  LGActivityViewModel.m
//  ifaxian
//
//  Created by ming on 16/12/11.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGActivityViewModel.h"

@implementation LGActivityViewModel{
    NSInteger index_;
}
/**
 *  获取最新的数据
 *
 *  @param completion 最新的数据结果
 */
-(void)loadNewDatacompletion:(void (^)(BOOL, NSArray<LGShare *> *))completion{
    
    
    NSString *url = [NSString stringWithFormat:@"https://ifaxian.cc/author/%@/page/1?json=1",_userName];
    LGWeakSelf;
    [self.manager requsetUrl:url completion:^(BOOL isSuccess, id responseObject) {
        
        if (isSuccess) {
            index_ = 2;
            NSMutableArray *shareM = [NSMutableArray array];
           
            for (NSDictionary *dict in responseObject[@"posts"]) {
                //字典转模型
                LGShareImage *model = [LGShareImage mj_objectWithKeyValues:dict];
                //再次字典转模型
                LGShare *share = [[LGShare alloc] initWithModel:model];
                [shareM addObject:share];
            }
            //下载图片
            [weakSelf loadImages:shareM isNew:YES Completion:completion];
            
        }else{
            
            completion(NO,nil);
        }

        
        
    }];
}
/**
 *  获取下一页
 *
 *  @param completion 下一页的数据结果
 */
- (void)loadOldDatacompletion:(void (^)(BOOL, NSArray<LGShare *> *))completion{
    if (index_ < 2) {
        index_ = 2;
    }

    NSString *url = [NSString stringWithFormat:@"https://ifaxian.cc/author/%@/page/%zd?json=1",_userName,index_];
    
    LGWeakSelf;
    [self.manager requsetUrl:url completion:^(BOOL isSuccess, id responseObject) {

        NSMutableArray<LGShare *> *shareM = [NSMutableArray array];
        
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
            
            for (LGShare *model in weakSelf.shareArray) {
                
                if (![weakSelf.shareArray containsObject:model]) {
                    [shareM addObject:model];
                }
                
            }
            
        }
        if (index_ > [responseObject[@"pages"] integerValue]) {
            completion(YES,nil);
            return ;
        }
        index_ += 1;
        [weakSelf loadImages:shareM isNew:NO Completion:completion];
        

    }];
    

 

    
    
}

@end
