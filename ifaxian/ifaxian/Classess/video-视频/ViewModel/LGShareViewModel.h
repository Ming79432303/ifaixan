//
//  LGShareViewModel.h
//  ifaxian
//
//  Created by ming on 16/11/30.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LGShare.h"

@interface LGShareViewModel : NSObject
@property (nonatomic, strong) LGHTTPSessionManager *manager;

@property (nonatomic, strong) NSMutableArray<LGShare *> *shareArray;


-(void)loadNewDatacompletion:(void(^)(BOOL isSuccess ,NSArray<LGShare *> *shareArray))completion;
-(void)loadOldDatacompletion:(void(^)(BOOL isSuccess ,NSArray<LGShare *> *shareArray))completion;
- (void)loadImages:(NSArray *)array isNew:(BOOL)isNew Completion:(void(^)(BOOL isSuccess ,NSArray<LGShare *> *shareArray))completion;
- (void)downVideoImage:(NSArray *)array Completion:(void(^)(BOOL isSuccess ,NSArray<LGShare *> *shareArray))completion;
@end
