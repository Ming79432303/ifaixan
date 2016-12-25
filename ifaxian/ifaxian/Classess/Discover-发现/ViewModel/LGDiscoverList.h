//
//  LGDiscoverList.h
//  ifaxian
//
//  Created by ming on 16/11/28.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGDiscoverList : NSObject

- (void)requestCategroie:(void(^)(NSArray *categories))completion;
- (void)getAllCategoriesPosts:(void(^)(NSArray *categoryposts))completion;
- (void)requestTags:(void(^)(NSArray *tags))completion;
- (void)getActivity_get_activities:(void(^)(BOOL isSuccess , NSArray *activities))completion;
@end
