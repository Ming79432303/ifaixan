//
//  LGCategoryCell.h
//  图片浏览相册
//
//  Created by ming on 16/11/27.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGPostModel.h"
#import "LGCategory.h"
#import "LGShow.h"
@interface LGCategoryCell : UICollectionViewCell
@property(nonatomic, strong) LGShow *model;
@end
