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
/**
 *  推荐界面的基类控制器
 */
@interface LGTopicController : UITableViewController
//推荐的ViewModel
@property(nonatomic, strong) LGRecommendViewModel *recommend;
//用来保存请求的数据
@property(nonatomic, strong) NSArray *dateArray;
//请求分类的名字，后台规定
@property(nonatomic, copy) NSString *postName;
@end
