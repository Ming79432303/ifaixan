//
//  UILGNavigationController.m
//  ifaxian
//
//  Created by ming on 16/11/17.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGNavigationController.h"
#import "LGBasiController.h"
@interface LGNavigationController ()

@end

@implementation LGNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
 
  
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 *  重写push方法的目的 : 拦截所有push进来的子控制器
 *
 *  @param viewController 刚刚push进来的子控制器
 */

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    
    
    //设置全站返回按钮
    if(self.childViewControllers.count > 0){// 如果viewController不是最早push进来的子控制器
        viewController.hidesBottomBarWhenPushed = YES;
        
        if ([viewController isKindOfClass:[LGBasiController class]]) {
            
            LGBasiController *vc = (LGBasiController *)viewController;
            
            if (self.childViewControllers.count == 1) {
               
                vc.navItem.leftBarButtonItem = [UIBarButtonItem lg_barButtonCustButton:self.tabBarItem.title fontSize:14 addTarget:self action:@selector(back) isBack:YES];
            }else{
                
                
                vc.navItem.leftBarButtonItem = [UIBarButtonItem lg_barButtonCustButton:@"返回" fontSize:14 addTarget:self action:@selector(back) isBack:YES];
                
                
            }
        }
    }
    [super pushViewController:viewController animated:animated];

}
- (void)back{
    
    [self popViewControllerAnimated:YES];
    
}
@end
