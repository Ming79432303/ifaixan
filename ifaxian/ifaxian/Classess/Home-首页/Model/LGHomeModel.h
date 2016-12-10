//
//  LGHomeModel.h
//  ifaxian
//
//  Created by ming on 16/12/6.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGPostModel.h"
#import "NSString+LGRegularExpressions.h"
@interface LGHomeModel : LGPostModel
@property(nonatomic, assign) CGFloat rowHeight;
@property(nonatomic, copy) NSString *describe;
@property(nonatomic, strong) NSArray *tags;
@property(nonatomic, strong) NSArray *images;
@end
