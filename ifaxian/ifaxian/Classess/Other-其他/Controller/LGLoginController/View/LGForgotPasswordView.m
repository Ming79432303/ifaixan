//
//  LGForgotPasswordView.m
//  ifaxian
//
//  Created by ming on 16/11/24.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGForgotPasswordView.h"
#import <POP.h>

@interface LGForgotPasswordView()

@property (weak, nonatomic) IBOutlet UITextField *userLoginField;

@property (weak, nonatomic) IBOutlet UIView *sendSuccessView;

@end;

@implementation LGForgotPasswordView

- (IBAction)forGotPasswordClick:(id)sender {
    
    
    [SVProgressHUD showWithStatus:@"正在发送消息到你邮箱.."];

    //忘记密码
    if (!self.userLoginField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"选项不能为空"];
        return;
    }
    
    [[LGHTTPSessionManager manager] requestRetrievePasswordUserLogin:self.userLoginField.text completion:^(BOOL isSuccess) {
        if (isSuccess) {
            [SVProgressHUD dismiss];
            [self showSendSuccess];
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:@"发送失败"];
        }
        
        
    }];
    
    
}
- (IBAction)closeForgotpawView:(id)sender {
    
    POPSpringAnimation *animati = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    animati.springSpeed = 20;
    animati.springBounciness = 10;
    animati.toValue = @(self.lg_width * 1.5);
    
    [self pop_addAnimation:animati forKey:nil];
    
    animati.completionBlock = ^(POPAnimation *anim, BOOL finished){
        
        [self removeFromSuperview];
    };
    

    
}

- (void)showSendSuccess{
    [SVProgressHUD dismiss];
    self.sendSuccessView.hidden = NO;
    POPBasicAnimation *animati = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    
    animati.fromValue = @0.2;
    animati.toValue = @1;
    animati.duration = 0.25;
    [self.superview pop_addAnimation:animati forKey:nil];
    
    
}
- (IBAction)closeSendSuccessView:(id)sender {
    POPSpringAnimation *animati = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    animati.springSpeed = 20;
    animati.springBounciness = 10;
    animati.toValue = @(self.lg_width * 1.5);
    
    [self pop_addAnimation:animati forKey:nil];
    
    animati.completionBlock = ^(POPAnimation *anim, BOOL finished){
        
        [self removeFromSuperview];
    };
    

    
}


@end
