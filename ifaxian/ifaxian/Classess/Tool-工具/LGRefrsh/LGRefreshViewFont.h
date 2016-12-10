//
//  LGRefrshView.h
//  下拉刷新oc
//
//  Created by ming on 16/10/31.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGRefrshControl.h"
@interface LGRefreshViewFont : UIView
@property(nonatomic, assign)  LGRefrshType refState;
@property (nonatomic ,assign) CGFloat parentViewHeight;


+ (LGRefreshViewFont *)refrshView;
@end
