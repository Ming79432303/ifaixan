//
//  LGModelConfig.m
//  ifaxian
//
//  Created by Apple_Lzzy27 on 16/11/17.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGModelConfig.h"
#import "LGPostModel.h"
#import "LGComment.h"
#import "LGCategories.h"
#import "LGcategories.h"
#import "LGAttachment.h"
#import "LGAccountUser.h"
#import "LGBasiModel.h"
@implementation LGModelConfig


+ (void)load{
    
    [LGPostModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
      
        return @{@"ID":@"id",
                 @"ding":@"custom_fields.bigfa_ding[0]",
                 @"views":@"custom_fields.post_views_count[0]",
                 @"attachment":@"attachments[0]"};
    }];
    [LGComment mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"ID":@"id"};
    }];
    [LGCategories mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"ID":@"id",
                 @"describe":@"description"};
    }];
    [LGPostModel mj_setupObjectClassInArray:^NSDictionary *{
        return @{@"comments":[LGComment class],
                 @"categories":[LGCategories class]};
    }];
    [LGAccountUser mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"ID":@"id"
                 };
    }];
    
    [LGBasiModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
       
        return @{@"ID":@"id",
                 @"describe":@"description"};
    }];
    

//    [LGCustomFields mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
//        return @{@"bigfa_ding":@"bigfa_ding[0]",
//                 @"post_views_count":@"post_views_count[0]"};
//    }];
}

@end
