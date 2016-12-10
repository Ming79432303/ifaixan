//
//  LGregisterView.m
//  ifaxian
//
//  Created by ming on 16/11/23.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGRegisterView.h"
#import "NSString+LGRegularExpressions.h"
#import <POP.h>
@interface LGRegisterView()
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIView *scuuessView;
@property (weak, nonatomic) IBOutlet UIButton *logoing;


@end;
@implementation LGRegisterView

- (IBAction)removeView:(id)sender{
  
    POPSpringAnimation *animati = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    animati.springSpeed = 20;
    animati.springBounciness = 10;
    animati.toValue = @(self.lg_width * 1.5);
    
    [self pop_addAnimation:animati forKey:nil];
    
    animati.completionBlock = ^(POPAnimation *anim, BOOL finished){
        
        [self removeFromSuperview];
    };
    

    
    
}


- (IBAction)registerClick:(id)sender {
    
    
    if (self.userNameTextField.text.length&&self.passWordTextField.text.length&&self.self.emailTextField.text.length) {
        
        
    if (![NSString lg_dateEmail:self.emailTextField.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入一个有效的邮箱"];
        return;
    }
    

        
        [SVProgressHUD showWithStatus:@"正在注册..."];
        [[LGNetWorkingManager manager] requestRegiterUserName:self.userNameTextField.text passWord:self.passWordTextField.text email:self.emailTextField.text completion:^(BOOL isSuccess) {
            if (isSuccess) {
                
                
                
                [self addSuccessView];
                
            }else{
                
                 [SVProgressHUD showErrorWithStatus:@"注册失败"];
            }
            
        }];
        
    }else{
        
        [SVProgressHUD showErrorWithStatus:@"所选项不能为空"];
        
    }
    
    
    
}
- (void)addSuccessView{
    [SVProgressHUD dismiss];
    self.scuuessView.hidden = NO;
    POPBasicAnimation *animati = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    
    animati.fromValue = @0.2;
    animati.toValue = @1;
    animati.duration = 0.25;
    [self.superview pop_addAnimation:animati forKey:nil]; 
}
- (IBAction)logoing:(id)sender {
    POPSpringAnimation *animati = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    animati.springSpeed = 20;
    animati.springBounciness = 10;
    animati.toValue = @(self.lg_width * 1.5);
    
    [self pop_addAnimation:animati forKey:nil];
    
    animati.completionBlock = ^(POPAnimation *anim, BOOL finished){
        
        [self removeFromSuperview];
    };
    

    
}
- (IBAction)close:(id)sender {
    
    
}




@end
