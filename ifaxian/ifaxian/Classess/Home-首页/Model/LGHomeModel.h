//
//  LGHomeModel.h
//  ifaxian
//
//  Created by ming on 16/12/6.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGPostModel.h"
#import "NSString+LGRegularExpressions.h"
#import "LGHomeTage.h"
@interface LGHomeModel : LGPostModel
/**
 *  首页cell的行高
 */
@property(nonatomic, assign) CGFloat rowHeight;
/**
 *  文章的描述
 */
@property(nonatomic, copy) NSString *describe;
/**
 *  文章的标签
 */
@property(nonatomic, strong) NSArray<LGHomeTage *> *tags;
/**
 *  文章中的前图片
 */
@property(nonatomic, strong) NSArray *images;
@end
