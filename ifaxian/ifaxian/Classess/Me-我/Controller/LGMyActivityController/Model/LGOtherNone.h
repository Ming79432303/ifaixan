//
//  LGOtherNone.h
//  ifaxian
//
//  Created by ming on 16/12/14.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LGOther.h"
/**
 *  不带箭头模型
 */
@interface LGOtherNone : LGOther
//组标题
@property(nonatomic, copy) NSString *detailText;
/**
 *  需要执行的block
 */
@property(nonatomic, copy)  void(^block)(NSIndexPath *indexPath);
@end
