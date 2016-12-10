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
@property (nonatomic, strong) LGComment *comment;
- (void)comment:(LGComment *)comment parentComment:(LGComment *)parent;
@end
