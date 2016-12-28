//
//  LGLoginController.m
//  ifaxian
//
//  Created by ming on 16/11/19.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGLoginController.h"
#import "LGRegisterView.h"
#import <POP.h>
#import "LGForgotPasswordView.h"
#import "LGSinaLoginController.h"
@interface LGLoginController ()
@property (weak, nonatomic) IBOutlet UIImageView *avatar;

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
@property (weak, nonatomic) IBOutlet UIButton *remenberButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation LGLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissVc) name:LGSinaUserLoginSuccessNotification object:nil];
    self.navigationItem.title = @"登录/注册";
    _userNameTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    _passWordTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"userPassword"];
     _remenberButton.selected = [[NSUserDefaults standardUserDefaults] boolForKey:@"isRemenber"];
    [self textChange];
    
    
    // 注册通知监听器，监听键盘弹起事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    // 注册通知监听器，监听键盘收起事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    [self setupUI];

}


- (void)dismissVc{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [SVProgressHUD dismiss];
}


- (void)setupUI{
    //登录
    UIImage *userImage = [UIImage imageNamed:@"user"];
    UIImageView *leftUserImageV = [[UIImageView alloc] init];
    leftUserImageV.image = userImage;
    leftUserImageV.frame = CGRectMake(0, 0, 25, 25);
    self.userNameTextField.leftView = leftUserImageV;
    self.userNameTextField.leftViewMode = UITextFieldViewModeAlways;
    self.avatar.layer.cornerRadius = self.avatar.lg_width/2;
    self.avatar.layer.masksToBounds = YES;
    
    UIImage *paswImage = [UIImage imageNamed:@"passwd"];
    UIImageView *leftPaswImageV = [[UIImageView alloc] init];
    leftPaswImageV.image = paswImage;
    leftPaswImageV.frame = CGRectMake(0, 0, 25, 25);
    self.passWordTextField.leftView = leftPaswImageV;
    self.passWordTextField.leftViewMode = UITextFieldViewModeAlways;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.userNameTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.passWordTextField];
    
    
}
- (void)textChange{
    
    if (self.userNameTextField.text.length && self.passWordTextField.text.length) {
        
    self.loginButton.enabled = YES;
        
    }else{
        
    self.loginButton.enabled = NO;
    }
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
    // Dispose of any resources that can be recreated.
}


- (IBAction)forGotPassWord:(id)sender {
    //忘记密码
    
      [self.view endEditing:YES];
    LGForgotPasswordView *forgotPasswordView = [LGForgotPasswordView viewFromeNib];
    forgotPasswordView.frame = CGRectMake(self.view.lg_width, 0, self.view.lg_width, self.view.lg_height);
    [self.view addSubview:forgotPasswordView];
    
    POPSpringAnimation *animati = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    animati.springSpeed = 20;
    animati.springBounciness = 10;
    animati.toValue = @(self.view.lg_width * 0.5);
    
    [forgotPasswordView pop_addAnimation:animati forKey:nil];
 
}
- (IBAction)login:(id)sender {
   
        self.loginButton.enabled = YES;
    
    [SVProgressHUD showWithStatus:@"正在登陆..."];
    NSString *userName = [self.userNameTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *password = [self.passWordTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];

    [[LGNetWorkingManager manager] requestAuthcookie:userName passWord:password completion:^(BOOL isSuccess, BOOL isSuccessLogin){
        if (isSuccess) {
            if (isSuccessLogin) {
                 self.loginButton.enabled = NO;
                
                [[LGNetWorkingManager manager].account readAccount];
                
                 [SVProgressHUD showSuccessWithStatus:@"登陆成功"];
                if (_remenberButton.selected == YES) {
                    //保存账号密码
                    [[NSUserDefaults standardUserDefaults] setBool:_remenberButton.selected forKey:@"isRemenber"];
                    [[NSUserDefaults standardUserDefaults] setObject:_userNameTextField.text forKey:@"userName"];
                    [[NSUserDefaults standardUserDefaults] setObject:_passWordTextField.text forKey:@"userPassword"];
                }
                
                //通知登录
                [self dismissViewControllerAnimated:YES completion:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:LGUserLoginSuccessNotification object:nil];
                
                
                
            }else{
                [SVProgressHUD showErrorWithStatus:@"账号或密密码错误"];
                
            }
           
        }else{
             self.loginButton.enabled = NO;
            [SVProgressHUD showErrorWithStatus:@"登陆失败"];
        }
        
        
    }];
    
    
    
    
}
- (IBAction)sina:(id)sender {
    LGLog(@"新浪登录");
    LGSinaLoginController *sina = [[LGSinaLoginController alloc] init];
    [self.navigationController pushViewController:sina animated:YES];
}

- (IBAction)qq:(id)sender {
    [SVProgressHUD showInfoWithStatus:@"暂时不支持QQ登录"];
    
    
}

- (IBAction)github:(id)sender {
 
     [SVProgressHUD showInfoWithStatus:@"暂时不支持github登录"];
}

- (IBAction)registered:(id)sender {
 
    
    LGRegisterView *registerView = [LGRegisterView viewFromeNib];
    registerView.frame = CGRectMake(self.view.lg_width, 0, self.view.lg_width, self.view.lg_height);
    [self.view addSubview:registerView];
    
    POPSpringAnimation *animati = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    animati.springSpeed = 20;
    animati.springBounciness = 10;
    animati.toValue = @(self.view.lg_width * 0.5);
    
    [registerView pop_addAnimation:animati forKey:nil];
    
    
    
   
}
-(void)keyboardWillShow:(NSNotification *)notification
{
    //开始动画升起动画效果
    [UIView beginAnimations:@"keyboardWillShow" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    //获取主视图View的位置
    CGRect rect = self.view.frame;
    //向上移动
    rect.origin.y=-90;
    //更改主视图View的位置
    self.view.frame=rect;
    //结束动画
    [UIView commitAnimations];
    
}
//键盘关闭时激发该方法
-(void)keyboardWillHide:(NSNotification *)notification
{
    
    [UIView beginAnimations:@"keyboardWilHide" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    //获取主视图view的位置
    CGRect rect = self.view.frame;
    //复位
    rect.origin.y=0;
    //更改主视图View的位置
    self.view.frame=rect;
    //结束动画
    [UIView commitAnimations];
    
    
}
//移除通知监听器
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter ] removeObserver:self];
    
}

- (IBAction)remenberpasWord:(id)sender {
    _remenberButton.selected = !_remenberButton.selected;
    
    
}


- (IBAction)close:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];

}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    
}

@end
