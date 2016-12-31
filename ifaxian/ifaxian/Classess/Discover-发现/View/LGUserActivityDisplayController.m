//
//  LGUserActivityDisplayController.m
//  ifaxian
//
//  Created by ming on 16/12/18.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGUserActivityDisplayController.h"
#import "LGPostModel.h"
#import "LGShare.h"
#import "LGShareController.h"
#import "LGDisplayController.h"
#import "LWActiveIncator.h"
@interface LGUserActivityDisplayController ()
@property(nonatomic, strong) LGPostModel *model;
@property(nonatomic, strong) LGHTTPSessionManager *manager;
@end

@implementation LGUserActivityDisplayController

- (LGHTTPSessionManager *)manager{
    
    if (_manager == nil) {
        _manager = [[LGHTTPSessionManager alloc] init];
    }
    
    return _manager;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
   
    
  
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    // initialize CWNotification
    [LWActiveIncator showInView:self.tableView];
    
   self.navItem.title = @"动态详情";
    self.navItem.rightBarButtonItem = [UIBarButtonItem lg_itemWithImage:@"more_icon" highImage:@"" target:self action:@selector(more)];
   
    NSString *postId= [_postUrl substringFromIndex:@"https://ifaxian.cc/?p=".length];
  NSString * requestUrl = [NSString requestBasiPathAppend:[NSString stringWithFormat:@"/api/get_post/?post_id=%@",postId]];
    
    LGWeakSelf;
    [self.manager requestPostUrl:requestUrl completion:^(BOOL isSuccess, id responseObject) {
        [LWActiveIncator hideInViwe:weakSelf.view];
     
        
   LGPostModel *model = [LGPostModel mj_objectWithKeyValues:responseObject[@"post"]];
         _model = model;
        if ([model.categories.firstObject.title isEqualToString:@"分享"]) {
            
         LGShare *share = [[LGShare alloc] initWithModel:model];
            LGShareController *shareVc = [[LGShareController alloc] init];
            shareVc.share = share;
            //[self.navigationController pushViewController:shareVc animated:YES];
            [weakSelf addChildViewController:shareVc];
            [weakSelf.view insertSubview:shareVc.view atIndex:1];
        }else{
            LGDisplayController *disVc = [[LGDisplayController alloc] init];
            
            disVc.model = model;

            [weakSelf addChildViewController:disVc];
            [weakSelf.view insertSubview:disVc.view atIndex:1];
            
        }
        
    }];
}
- (void)more{
    
    UIAlertController *alerVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"您要要？" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alerVc addAction:[UIAlertAction actionWithTitle:@"复制链接地址" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:[NSString stringWithFormat:@"%@ %@",self.model.title,self.model.url]];
        [SVProgressHUD showSuccessWithStatus:@"复制成功"];
        
    }]];
    LGWeakSelf;
    if ([self.model.author.slug isEqualToString:[LGNetWorkingManager manager].account.user.username] || [[LGNetWorkingManager manager].account.user.ID isEqualToString:@"2"]) {
        [alerVc addAction:[UIAlertAction actionWithTitle:@"删除该文章" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIAlertController *alerVc2 = [UIAlertController alertControllerWithTitle:@"提示" message:@"删除之后不可恢复您确定要删除吗？" preferredStyle:UIAlertControllerStyleAlert];
            [alerVc2 addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [alerVc2 addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [[LGNetWorkingManager manager] requestDeleteArticlePost_slug:weakSelf.model.slug post_id:[NSString stringWithFormat:@"%zd",weakSelf.model.ID] completion:^(BOOL isSuccess) {
                    if (isSuccess) {
                        [SVProgressHUD showSuccessWithStatus:@"删除成功"];
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    }else{
                        [SVProgressHUD showErrorWithStatus:@"删除失败"];
                    }
                    
                }];
            }]];
            [weakSelf presentViewController:alerVc2 animated:YES completion:nil];
        }]];
        
    }
    
    
    [self presentViewController:alerVc animated:YES completion:nil];
    
}




@end
