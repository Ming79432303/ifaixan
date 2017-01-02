//
//  LGArticleCell.h
//  ifaxian
//
//  Created by ming on 16/11/22.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGArticleModel.h"
#import "LGShareImage.h"
/**
 *  文章的cell
 */
@interface LGArticleCell : UITableViewCell
/**
 *  文章的模型
 */
@property(nonatomic, strong) LGShareImage *postModel;
@end
