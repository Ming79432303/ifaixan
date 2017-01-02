//
//  LGArticleModel.h
//  ifaxian
//
//  Created by ming on 16/11/22.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGPostModel.h"
/**
 *  继承LGPostModel
 */
@interface LGArticleModel : LGPostModel
/**
 *  如果是文章类型的行高
 */
@property(nonatomic, assign) CGFloat articleCellHeight;

@end
