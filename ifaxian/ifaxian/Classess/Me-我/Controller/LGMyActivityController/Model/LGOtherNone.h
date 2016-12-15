//
//  LGOtherNone.h
//  ifaxian
//
//  Created by ming on 16/12/14.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LGOther.h"

@interface LGOtherNone : LGOther
@property(nonatomic, copy) NSString *detailText;
@property(nonatomic, copy)  void(^block)(NSIndexPath *indexPath);
@end
