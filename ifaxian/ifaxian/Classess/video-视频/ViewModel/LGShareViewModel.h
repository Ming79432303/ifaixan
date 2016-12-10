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
-(void)loadNewDatacompletion:(void(^)(BOOL isSuccess ,NSArray<LGShare *> *shareArray))completion;
-(void)loadOldDatacompletion:(void(^)(BOOL isSuccess ,NSArray<LGShare *> *shareArray))completion;
@end
