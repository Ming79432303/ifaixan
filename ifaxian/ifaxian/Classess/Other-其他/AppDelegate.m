//
//  AppDelegate.m
//  ifaxian
//
//  Created by ming on 16/11/16.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "AppDelegate.h"
#import "LGMainController.h"
#import "LGDisplayController.h"
#import "UMessage.h"
#import <UserNotifications/UserNotifications.h>
#import "LGNotiViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    LGMainController *main = [[LGMainController alloc] init];
    [self addNotification:launchOptions];
    self.window.rootViewController = main;
    if ([LGNetWorkingManager manager].isLogin) {
        
        [[LGNetWorkingManager manager] updateUserCookie];
    }
    [self additions];
    [self.window makeKeyAndVisible];
    
    return YES;
}
- (void)addNotification:(NSDictionary *)launchOptions{
    
    [UMessage startWithAppkey:@"589ac594734be478c4000a84" launchOptions:launchOptions httpsenable:YES ];
    //注册通知，如果要使用category的自定义策略，可以参考demo中的代码。
    [UMessage registerForRemoteNotifications];
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|  UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10     completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            //这里可以添加一些自己的逻辑
        } else {
            //点击不允许
            //这里可以添加一些自己的逻辑
        }
    }];
    
    //打开日志，方便调试
    [UMessage setLogEnabled:YES];
    // iOS8之后和之前应区别对待
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIUserNotificationTypeSound];
    }
    


}
- (void)additions{
    
    //请求授权
    UIUserNotificationSettings *seting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:seting];
    [SVProgressHUD setMinimumDismissTimeInterval:1.0];
    //[[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
}

/// 这个函数存在的意义在于：当用户在设置中关闭了通知时，程序启动时会调用此函数，我们可以获取用户的设置
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}
/// 注册失败调用
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"远程通知注册失败：%@",error);
}
/**
 *  获取苹果服务器返回的deviceToken
 *
 *  @param application <#application description#>
 *  @param deviceToken <#deviceToken description#>
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    
    
    
}

//iOS10以下使用这个方法接收通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //关闭友盟自带的弹出框
    [UMessage setAutoAlert:NO];
    [UMessage didReceiveRemoteNotification:userInfo];
    // App 收到推送的通知
    LGLog(@"********** ios7.0之前 **********");
    // 应用在前台 或者后台开启状态下，不跳转页面，让用户选择。
    if (application.applicationState == UIApplicationStateActive || application.applicationState == UIApplicationStateBackground) {
        NSLog(@"acitve or background");
        UIAlertController *alertView = [UIAlertController  alertControllerWithTitle:@"推送消息" message:userInfo[@"aps"][@"alert"] preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction: [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alertView addAction: [UIAlertAction actionWithTitle:@"立即查看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        LGNotiViewController *VC = [[LGNotiViewController alloc] init];
        
        VC.postUrl =  userInfo[@"url"];
        NSLog(@"%@",userInfo[@"url"]);
        
        UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:VC];
        [self.window.rootViewController presentViewController:na animated:YES completion:nil];
 
        }]];
        
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertView animated:YES completion:nil];
//        UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"提示" message:userInfo[@"aps"][@"alert"][@"body"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即查看", nil];
//        [alertView show];
    }
    else//杀死状态下，直接跳转到跳转页面。
    {
        
        LGNotiViewController *VC = [[LGNotiViewController alloc] init];
        
        VC.postUrl =  userInfo[@"url"];
        NSLog(@"%@",userInfo[@"url"]);
        
        UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:VC];
        [self.window.rootViewController presentViewController:na animated:YES completion:nil];
    }
    //        self.userInfo = userInfo;
    //定制自定的的弹出框
    NSLog(@"收到通知");
    NSLog(@"%@收到通知",userInfo);
}
//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭友盟自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于前台时的本地推送接受
        
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    NSLog(@"打开应用");
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于后台时的本地推送接受
    }
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
