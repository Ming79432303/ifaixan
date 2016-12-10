//
//  LGRefrshView.h
//  下拉刷新oc
//
//  Created by ming on 16/10/31.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGRefrshControl.h"
@interface LGRefrshView : UIView
@property(nonatomic, assign)  LGRefrshType refState;
@property (nonatomic ,assign) CGFloat parentViewHeight;


+ (LGRefrshView *)refrshView;
@end
