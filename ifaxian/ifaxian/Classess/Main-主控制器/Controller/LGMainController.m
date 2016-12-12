//
//  LGMainController.m
//  ifaxian
//
//  Created by ming on 16/11/17.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGMainController.h"
#import "LGNavigationController.h"
#import "LGBasiController.h"
#import "LGLoginController.h"
#import "LGWriteView.h"
#import "LGMecontroller.h"
@interface LGMainController ()<LGWriteViewDelegate>
@property(nonatomic, strong) UIButton *writeButton;
@end

@implementation LGMainController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setControllersDict];
    [self addwriteButton];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogin) name:LGUserLoginNotification object:nil];
    
}
- (void)addwriteButton{
    
    UIButton *writButn = [UIButton buttonWithType:UIButtonTypeCustom];
    [writButn setImage:[UIImage imageNamed:@"发表"] forState:UIControlStateNormal];
    [self.view addSubview:writButn];
    [self.tabBar addSubview:writButn];
    CGFloat btnW = LGScreenW / self.viewControllers.count;
    
    //insetBy
    writButn.frame = CGRectInset(self.tabBar.bounds, btnW*2, 0);
    //添加单击事件
    [writButn addTarget:self action:@selector(writeView) forControlEvents:UIControlEventTouchUpInside];
    self.writeButton = writButn;

    
}

- (void)writeView{
    LGWriteView *writeView = [LGWriteView viewFromeNib];
    writeView.delegate = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeView:)];
    
    writeView.frame = self.view.frame;
    
    
    [writeView addGestureRecognizer:tap];
    
    [self.view addSubview:writeView];
       POPBasicAnimation *animati = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
    animati.toValue = @(0.3);
    animati.duration = 0.25;
    [UIView animateWithDuration:0.25 animations:^{
       
        self.writeButton.transform = CGAffineTransformMakeRotation(-M_2_PI);
        
    }];
    
//    [self.writeButton pop_addAnimation:animati forKey:nil];
    
    
}
- (void)removerConverViewWriteView:(LGWriteView *)writeView{
    
    [self removeView:nil];
}
- (void)removeView:(UIGestureRecognizer *)tap{
    
    [tap.view removeFromSuperview];
    [UIView animateWithDuration:0.25 animations:^{
        
        self.writeButton.transform = CGAffineTransformMakeRotation(0);
    }];
    
    
}

- (void)userLogin{
    
    LGLoginController *login = [[LGLoginController alloc] init];
    
    UITabBarController *tab = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav  =  tab.selectedViewController;
    
    [nav presentViewController:login animated:YES completion:nil];
    
}

- (void)setControllersDict{
   //创建一个字典visitordiscover_image_message   visitordiscover_image_profile
    NSArray *array = @[
                       @{
                           @"className":@"LGSquareController",@"title":@"视频",@"imageName":@"discover"
                           },

  
                        @{
                           @"className":@"LGDiscoverController",@"title":@"发现",@"imageName":@"message_center"
                         
                           },
                       
                       @{
                           @"className":@"",@"title":@"UIviewController"
                           },

                       @{
                           @"className":@"LGHomeController",@"title":@"首页",@"imageName":@"home"
                        },
                       @{
                           @"className":@"LGMecontroller",@"title":@"我",@"imageName":@"profile",
                         }];
    
    NSMutableArray<__kindof UIViewController *> *controllers = [NSMutableArray array];
    
    for (NSDictionary *dict in array) {
        
        LGNavigationController *nav = [self setChildViewControllers:dict];
        [controllers addObject:nav];
    
    }
    
    self.viewControllers = controllers;
    
    
    
    
}



- (LGNavigationController *)setChildViewControllers:(NSDictionary *)dict{
    
    NSString *clsName = dict[@"className"];
    NSString *title = dict[@"title"];
    NSString *imageName = dict[@"imageName"];
//    tabbar_home_selected
    NSString *normalImageName = [NSString stringWithFormat:@"tabbar_%@",imageName];
    NSString *selectImageName = [NSString stringWithFormat:@"%@_selected",normalImageName];
    
   
    UIViewController *vc;
    Class className = NSClassFromString(clsName);
    if (className == [LGMecontroller class]) {
        UIStoryboard *stroy = [UIStoryboard storyboardWithName:@"LGMeController" bundle:nil];
      vc = [stroy instantiateInitialViewController];
    
    }else{
        
        vc = [[className alloc] init];
    }
    LGNavigationController *nav = [[LGNavigationController alloc] initWithRootViewController:vc];
    vc.tabBarItem.title = title;
   
   
    vc.tabBarItem.image = [[UIImage imageNamed:normalImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //设置选中背景颜色，选中的字体无法改变大小，只能设置normal状态下的字体大小
    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
    [vc.tabBarItem setTitleTextAttributes:attributes forState:UIControlStateSelected];
     
    return nav;
}




@end
