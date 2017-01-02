//
//  LGActivityCell.h
//  ifaxian
//
//  Created by ming on 16/12/17.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGActivitie.h"
@interface LGActivityCell : UITableViewCell
/**
 *  全站动态模型
 */
@property(nonatomic, strong) LGActivitie *model;
@end
