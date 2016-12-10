//
//  LGVisitorView.m
//  ifaxian
//
//  Created by ming on 16/11/19.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGVisitorView.h"
#import "LGLoginController.h"
@interface LGVisitorView()

@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end;
@implementation LGVisitorView




- (IBAction)login:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LGUserLoginNotification object:nil];
    
}

@end
