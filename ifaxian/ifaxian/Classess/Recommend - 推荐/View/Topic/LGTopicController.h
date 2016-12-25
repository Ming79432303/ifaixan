//
//  LGTopicViewController.h
//  ifaxian
//
//  Created by ming on 16/12/7.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGRecommendViewModel.h"
#import "LGRecommend.h"
@interface LGTopicController : UITableViewController
@property(nonatomic, strong) LGRecommendViewModel *recommend;
@property(nonatomic, strong) NSArray *dateArray;
@property(nonatomic, copy) NSString *postName;
@end
