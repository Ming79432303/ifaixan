//
//  LGTagsCell.h
//  ifaxian
//
//  Created by ming on 16/11/28.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGTag.h"
@interface LGTagsCell : UITableViewCell
@property(nonatomic, strong) LGTag *model;
@property(nonatomic, strong) NSArray<LGTag *> *tags;
@end
