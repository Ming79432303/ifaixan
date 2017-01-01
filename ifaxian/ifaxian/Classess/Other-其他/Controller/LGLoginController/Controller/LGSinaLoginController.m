//
//  LGSinaLoginController.m
//  ifaxian
//
//  Created by ming on 16/12/28.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGSinaLoginController.h"
#import "LGAccount.h"
#import "LGAccountUser.h"
@interface LGSinaLoginController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property(nonatomic, strong) LGHTTPSessionManager *manger;
@end

@implementation LGSinaLoginController


- (LGHTTPSessionManager *)manger{
    
    if (_manger == nil) {
        _manger = [[LGNetWorkingManager alloc] init];
    }
    
    return _manger;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem lg_barButtonCustButton:@"返回" fontSize:14 addTarget:self action:@selector(back) isBack:YES];
    self.navigationItem.title = @"新浪微博登录";
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [cookieStorage cookies]) {
        [cookieStorage deleteCookie:cookie];
    }

    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://api.weibo.com/oauth2/authorize?response_type=code&client_id=101798142&forcelogin=true&redirect_uri=https%3A%2F%2Fifaxian.cc%2F%3Fconnect%3Dsina%26action%3Dcallback"]]];
    self.webView.delegate = self;

}


- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if ([request.URL.absoluteString hasPrefix:@"https://ifaxian.cc/"]) {
        
        [SVProgressHUD showWithStatus:@"正在登录.."];
        NSArray *allCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
        for (NSHTTPCookie *cookies in allCookies) {
            
            if ([cookies.name containsString:@"wordpress_logged_in"]){
            
                LGAccount *accout = [[LGAccount alloc] init];
                accout.cookie_name = cookies.name;
                accout.cookie = cookies.value;
                accout.isOtherLogin = YES;
                
                [LGNetWorkingManager manager].account = accout;
                
                [self.manger requestSinaUsercompletion:^(BOOL isSuccess, NSDictionary * responseObject) {
                    if (isSuccess) {
                         [SVProgressHUD showSuccessWithStatus:@"登录成功"];
                        LGAccountUser *user = [[LGAccountUser alloc] init];
                        user.username = [NSString stringWithFormat:@"SINA%@",responseObject[@"open_type_sina"]];
                        user.nickname = responseObject[@"nickname"];
                        user.userAvatar = responseObject[@"open_img"];
                        
                        accout.user = user;
                        [LGNetWorkingManager manager].account = accout;
                        [[LGNetWorkingManager manager].account accountSave];
                        [[NSNotificationCenter defaultCenter] postNotificationName:LGUserLoginSuccessNotification object:nil];
                        [[NSNotificationCenter defaultCenter] postNotificationName:LGSinaUserLoginSuccessNotification object:nil];
                        
                    }else{
                        [SVProgressHUD showErrorWithStatus:@"获取信息失败"];
                        
                    }
                    
                }];

                
                
                
               
            }
        }
        
    }    
    return YES;
}

@end
