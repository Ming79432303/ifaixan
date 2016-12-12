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

-(void)loadNewDatacompletion:(void (^)(BOOL, NSArray<LGShare *> *))completion{
    
    [[LGNetWorkingManager manager] requsetUrl:@"http://112.74.45.39/author/ming/page/13?json=1" completion:^(BOOL isSuccess, NSArray *json) {
        
        if (isSuccess) {
            index_ = 2;
            NSMutableArray *shareM = [NSMutableArray array];
            for (NSDictionary *dict in json) {
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

- (void)loadOldDatacompletion:(void (^)(BOOL, NSArray<LGShare *> *))completion{
    
    NSString *url = [NSString stringWithFormat:@"http://112.74.45.39/author/ming/page/%zd?json=1",index_];
    
    
    [[LGNetWorkingManager manager] requsetUrl:url completion:^(BOOL isSuccess, NSArray *json) {

        NSMutableArray<LGShare *> *shareM = [NSMutableArray array];
        
        if (self.shareArray.lastObject.share.ID > self.shareArray.firstObject.share.ID) {
            
            for (NSDictionary *dict in json) {
                LGShareImage *model = [LGShareImage mj_objectWithKeyValues:dict];
                LGShare *share = [[LGShare alloc] initWithModel:model];
                [shareM addObject:share];
            }
            
        }else{
            for (NSDictionary *dict in json) {
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
//        if (index_ > [responseObject[@"pages"] integerValue]) {
//            completion(isSuccess,nil);
//            return ;
//        }
        index_ += 1;
        [self loadImages:shareM isNew:NO Completion:completion];
        

    }];
    

 

    
    
}

@end
