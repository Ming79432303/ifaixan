//
//  LGSendArticleContrloler.m
//  ifaxian
//
//  Created by ming on 16/12/5.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGSendArticleContrloler.h"

@implementation LGSendArticleContrloler

- (void)viewDidLoad{
    
    [super viewDidLoad];
     [self setEditing:NO animated:YES];
    [self startEditing];
    [UIView animateWithDuration:0.25 animations:^{
        self.editorView.lg_y = self.navBar.lg_height;
    }];
    [self becomeFirstResponder];

}
- (void)setupNav{
    self.navigationController.navigationBar.hidden = YES;
    self.navBar.frame = self.navigationController.navigationBar.bounds;
    self.navBar.lg_height += 20;
    self.navBar.items = @[self.navItem];
    self.navBar.barTintColor = [UIColor lg_colorWithHex:0xF6F6F6];
    self.navBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor lg_colorWithRed:37 green:37 blue:37]};
    
    [self.view addSubview:self.navBar];
    
    
    
    
    
    self.navItem.rightBarButtonItem = [UIBarButtonItem lg_barButtonCustButton:@"发送" fontSize:14 addTarget:self action:@selector(sendArticle)isBack:NO];
    self.navItem.leftBarButtonItem = [UIBarButtonItem lg_barButtonCustButton:@"关闭" fontSize:14 addTarget:self action:@selector(dismissView) isBack:NO];
    self.mediaAdded = [NSMutableDictionary dictionary];
    self.videoPressCache = [[NSCache alloc] init];
    [self stopEditing];
    self.titlePlaceholderText = NSLocalizedString(@"Post title",  @"Placeholder for the post title.");
    self.bodyPlaceholderText = NSLocalizedString(@"Share your story here...", @"Placeholder for the post body.");

}

- (void)dismissView{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)sendArticle{
    
    [[LGNetWorkingManager manager] requestPostThearticleTitle:self.titleText content:self.bodyText :^(BOOL isSuccess) {
        
        if (isSuccess) {
            [SVProgressHUD showSuccessWithStatus:@"发送成功"];
        }else{
            [SVProgressHUD showSuccessWithStatus:@"发送失败"];
        }
        
        
    }];
    
}
@end
