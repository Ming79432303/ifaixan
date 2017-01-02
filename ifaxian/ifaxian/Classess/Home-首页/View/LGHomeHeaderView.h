//
//  LGHomeHeaderView.h
//  ifaxian
//
//  Created by ming on 16/11/25.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGHomeModel.h"
@interface LGHomeHeaderView : UIView
/**
 *  首页轮播器的数据
 */
@property (nonatomic, strong) NSArray<LGHomeModel *>  *headerArray;

@end
