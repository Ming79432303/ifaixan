//
//  LGRefrshControl.h
//  下拉刷新oc
//
//  Created by ming on 16/10/31.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    ///正常状态
    Normal,
    ///刷新状态
    PullIng,
    ///正在刷新状态
  willRefresh
}LGRefrshType;

@interface LGRefrshControl : UIControl
- (void)beginRefreshing;

- (void)endRefreshing;


@end
