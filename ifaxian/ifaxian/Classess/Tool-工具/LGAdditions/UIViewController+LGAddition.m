//
//  UIViewController+CZAddition.m
//
//  Created by ming on 16/5/18.
//  Copyright © 2016年 ming All rights reserved.
//

#import "UIViewController+LGAddition.h"

@implementation UIViewController (LGAddition)

- (void)lg_addChildController:(UIViewController *)childController intoView:(UIView *)view  {
    
    [self addChildViewController:childController];
    
    [view addSubview:childController.view];
    
    [childController didMoveToParentViewController:self];
}

@end
