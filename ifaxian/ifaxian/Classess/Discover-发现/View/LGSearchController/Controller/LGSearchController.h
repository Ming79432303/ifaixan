//
//  LGSearchController.h
//  ifaxian
//
//  Created by ming on 16/11/26.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LGSearchController : UIViewController

@property(nonatomic, copy) void(^search)(NSString *);

@end
