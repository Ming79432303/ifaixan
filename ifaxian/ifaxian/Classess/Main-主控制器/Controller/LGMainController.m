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
#import "LGNewFeatureView.h"
@interface LGMainController ()<LGWriteViewDelegate>
@property(nonatomic, strong) UIButton *writeButton;
@property(nonatomic, strong) UINavigationController *loginNav;
@end

@implementation LGMainController



#pragma mark - viewDidLoad
- (void)viewDidLoad {
    
    [super viewDidLoad];
    //判断是否进去新特性
    [self isGoinNewFeature];
    //设置子控制的数据
    [self setControllersDict];
    //添加发布按钮
    [self addwriteButton];
    //监听用户登录事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogin) name:LGUserLoginNotification object:nil];
    //监听用户退出事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogout) name:LGUserLogoutNotification object:nil];
    
}


////设置支持方向
//override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
//    //竖直方向
//    return .portrait
//}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskPortrait;
}


#pragma mark - 添加发布按钮
- (void)addwriteButton{
    
    UIButton *writButn = [UIButton buttonWithType:UIButtonTypeCustom];
    [writButn setImage:[UIImage imageNamed:@"tabbar_compose_button"] forState:UIControlStateNormal];
    [self.view addSubview:writButn];
    [self.tabBar addSubview:writButn];
    CGFloat btnW = LGScreenW / self.viewControllers.count;
    //insetBy
    writButn.frame = CGRectInset(self.tabBar.bounds, btnW*2, 0);
    //添加单击事件
    [writButn addTarget:self action:@selector(writeView) forControlEvents:UIControlEventTouchUpInside];
    self.writeButton = writButn;

    
}

#pragma mark - 发布按钮点击事件
- (void)writeView{
    //判断用户是否登录
    if (![LGNetWorkingManager manager].isLogin) {
        [SVProgressHUD showInfoWithStatus:@"请先登录"];
          [[NSNotificationCenter defaultCenter] postNotificationName:LGUserLoginNotification object:nil];
        return;
    }
    //创建发布界面
    LGWriteView *writeView = [LGWriteView viewFromeNib];
    //设置代理
    writeView.delegate = self;
    //添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeView:)];
    writeView.frame = self.view.frame;
    [writeView addGestureRecognizer:tap];
    [self.view addSubview:writeView];
    //添加旋转动画
    POPBasicAnimation *animati = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
    animati.toValue = @(0.3);
    animati.duration = 0.25;
    [UIView animateWithDuration:0.25 animations:^{
       
        self.writeButton.transform = CGAffineTransformMakeRotation(-M_2_PI);
        
    }];
    
//    [self.writeButton pop_addAnimation:animati forKey:nil];
    
    
}
//代理方法移除发布View恢复中间按钮的位置
- (void)removerConverViewWriteView:(LGWriteView *)writeView{
    
    [self removeView:nil];
}
//view点击移除方法
- (void)removeView:(UIGestureRecognizer *)tap{
    
    [tap.view removeFromSuperview];
    //让中间按钮复原
    [UIView animateWithDuration:0.25 animations:^{
        
        self.writeButton.transform = CGAffineTransformMakeRotation(0);
    }];
    
    
}
//用户登录
- (void)userLogin{
 
    
    LGLoginController *login = [[LGLoginController alloc] init];
    UINavigationController * loginNav = [[UINavigationController alloc] initWithRootViewController:login];
    if (self == nil) {
        return;
    }
    [self presentViewController:loginNav animated:YES completion:nil];
    
}
//用户退出登录
- (void)userLogout{
    UIAlertController *alerView = [UIAlertController alertControllerWithTitle:@"爱发现" message:@"确定退出当前账号吗?" preferredStyle:UIAlertControllerStyleAlert];
    
    [alerView addAction: [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alerView addAction: [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //处理退出登录
        [self logOut];
        //通知用户从新登录通知
        [[NSNotificationCenter defaultCenter] postNotificationName:LGUserLoginNotification object:nil];
        //发送用户退出成功通知
        [[NSNotificationCenter defaultCenter] postNotificationName:LGUserLogoutSuccessNotification object:nil];
    }]];
    [self presentViewController:alerView animated:YES completion:nil];
    
    
}

#pragma mark - 用户退出登录
- (void)logOut{
    NSString *fileName = @"account.json";
    NSString *filePatch = [fileName lg_appendDocumentDir];
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager removeItemAtPath:filePatch error:nil];
    [LGNetWorkingManager manager].account = nil;
    
}
#pragma mark - 创建子控制器字典反射机制
- (void)setControllersDict{
   //创建一个字典visitordiscover_image_message   visitordiscover_image_profile
    NSArray *array = @[
                       @{
                           @"className":@"LGHomeController",@"title":@"首页",@"imageName":@"home"
                           },
                       @{
                           @"className":@"LGDiscoverController",@"title":@"发现",@"imageName":@"discover"
                           
                           }, @{
                           @"className":@"UIViewController",@"title":@"UIviewController"
                           },
                        @{
                           @"className":@"LGSquareController",@"title":@"分享",@"imageName":@"message_center"
                           },

                       
                       @{
                           @"className":@"LGMecontroller",@"title":@"我",@"imageName":@"profile",
                           }

                            ];
    
    NSMutableArray<__kindof UIViewController *> *controllers = [NSMutableArray array];
    //循环天剑
    for (NSDictionary *dict in array) {
        
        LGNavigationController *nav = [self setChildViewControllers:dict];
        [controllers addObject:nav];
    
    }
    //复制给当前子tabar子控制器组
    self.viewControllers = controllers;
}


//处理字典数据返回一个控制器
- (LGNavigationController *)setChildViewControllers:(NSDictionary *)dict{
    //控制器的类名
    NSString *clsName = dict[@"className"];
    //控制器的标题
    NSString *title = dict[@"title"];
    //tabbar的图片
    NSString *imageName = dict[@"imageName"];
    //图片拼接
    //tabbar_home_selected
    NSString *normalImageName = [NSString stringWithFormat:@"tabbar_%@",imageName];
    NSString *selectImageName = [NSString stringWithFormat:@"%@_selected",normalImageName];
    UIViewController *vc;
    //根据控制器名称生成类名
    Class className = NSClassFromString(clsName);
    //如果是我控制器那么就用storyboard
    if (className == [LGMecontroller class]) {
        UIStoryboard *stroy = [UIStoryboard storyboardWithName:@"LGMeController" bundle:nil];
      vc = [stroy instantiateInitialViewController];
    
    }else{//其他类型控制器
        vc = [[className alloc] init];
    }
    //创建导航控制器
    LGNavigationController *nav = [[LGNavigationController alloc] initWithRootViewController:vc];
    //标题
    vc.tabBarItem.title = title;
    //设置tabbar的图片
    vc.tabBarItem.image = [[UIImage imageNamed:normalImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //设置选中背景颜色，选中的字体无法改变大小，只能设置normal状态下的字体大小
    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
    //设置字体样式
    [vc.tabBarItem setTitleTextAttributes:attributes forState:UIControlStateSelected];
    return nav;
}
#pragma mark - 判断是否进去新特性界面
- (void)isGoinNewFeature{
    NSDictionary *info = [NSBundle mainBundle].infoDictionary;
    // NSString *bundl =  [info @{CFBundleShortVersionString}];
    //获取当前出版本信息
    NSString *version =  [info objectForKey:@"CFBundleShortVersionString"];
    //从偏好设置中读取版本号
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"version"];
    //当前版本号与上次版本号判断
    if (![version isEqualToString:lastVersion]) {
        //保存到偏好设置
        [[NSUserDefaults standardUserDefaults] setObject:version forKey:@"version"];
        LGNewFeatureView *newFeatureView = [LGNewFeatureView viewFromeNib];
        //设置frame
        newFeatureView.frame = [UIScreen mainScreen].bounds;
         // 进入到新特性
        [self.view addSubview:newFeatureView];
        
    }else{

    }
}


@end
