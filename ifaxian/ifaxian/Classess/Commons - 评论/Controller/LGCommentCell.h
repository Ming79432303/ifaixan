//
//  LGCommentCell.h
//  ifaxian
//
//  Created by ming on 16/11/18.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGComment.h"
@interface LGCommentCell : UITableViewCell
/**
 *  评论模型
 */
@property (nonatomic, strong) LGComment *comment;
/**
 *  评论和父论
 *
 *  @param comment 评论
 *  @param parent  父评论
 */
- (void)comment:(LGComment *)comment parentComment:(LGComment *)parent;
@end
