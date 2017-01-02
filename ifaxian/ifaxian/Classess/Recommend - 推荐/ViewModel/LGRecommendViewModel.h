//
//  LGRecommendViewModel.h
//  ifaxian
//
//  Created by ming on 16/12/7.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGRecommendViewModel : NSObject
/**
 *  请求数据的路径(后台规定)
 */
@property(nonatomic, copy) NSString *postName;
/**
 *  加载新数据
 *
 *  @param completion 完成回调
 */
- (void)loadNewDataCompletion:(void(^)(BOOL isSuccess ,NSArray *array))completion;
/**
 *  加载下一页的数据
 *
 *  @param completion 完成回调
 */
- (void)loadOldDataCompletion:(void(^)(BOOL isSuccess ,NSArray *array))completion;
@end
