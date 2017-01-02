//
//  LGCommentController.h
//  ifaxian
//
//  Created by ming on 16/11/18.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGBasiController.h"
#import "LGPostModel.h"
@interface LGCommentController : LGBasiController
/**
 *  文章数据
 */
@property (nonatomic, strong) LGPostModel *model;
@end
