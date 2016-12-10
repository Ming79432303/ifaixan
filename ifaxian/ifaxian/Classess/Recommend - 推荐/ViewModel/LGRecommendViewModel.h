//
//  LGRecommendViewModel.h
//  ifaxian
//
//  Created by ming on 16/12/7.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGRecommendViewModel : NSObject
@property(nonatomic, copy) NSString *postName;;
- (void)loadNewDataCompletion:(void(^)(BOOL isSuccess ,NSArray *array))completion;
- (void)loadOldDataCompletion:(void(^)(BOOL isSuccess ,NSArray *array))completion;
@end
