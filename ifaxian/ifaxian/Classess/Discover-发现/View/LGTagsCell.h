//
//  LGTagsCell.h
//  ifaxian
//
//  Created by ming on 16/11/28.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGTag.h"
/**
 *  发现界面的标签展示cell
 */
@interface LGTagsCell : UITableViewCell
/**
 *  标签模型
 */
@property(nonatomic, strong) LGTag *model;
/**
 *  所有标签数据
 */
@property(nonatomic, strong) NSArray<LGTag *> *tags;
@end
