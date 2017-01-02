//
//  LGXiaoHuaCommentController.m
//  ifaxian
//
//  Created by ming on 16/12/7.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGXiaoHuaCommentController.h"
#import "LGXiaoHuaCell.h"

@interface LGXiaoHuaCommentController ()

@end

@implementation LGXiaoHuaCommentController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.navItem.rightBarButtonItem = [UIBarButtonItem lg_itemWithImage:@"more_icon" highImage:@"" target:self action:@selector(more)];
    self.navItem.title = @"笑话详情";
}


- (void)more{
    
    UIAlertController *alerVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"您要要？" preferredStyle:UIAlertControllerStyleActionSheet];
    [alerVc addAction:[UIAlertAction actionWithTitle:@"复制链接地址" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:[NSString stringWithFormat:@"%@ %@",self.share.title,self.model.url]];
        [SVProgressHUD showSuccessWithStatus:@"复制成功"];
    }]];
    LGWeakSelf;
    if ([self.model.author.slug isEqualToString:[LGNetWorkingManager manager].account.user.username] || [[LGNetWorkingManager manager].account.user.ID isEqualToString:@"1"]) {
        [alerVc addAction:[UIAlertAction actionWithTitle:@"删除该文章" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIAlertController *alerVc2 = [UIAlertController alertControllerWithTitle:@"提示" message:@"删除之后不可恢复您确定要删除吗？" preferredStyle:UIAlertControllerStyleAlert];
            [alerVc2 addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [alerVc2 addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [[LGNetWorkingManager manager] requestDeleteArticlePost_slug:weakSelf.share.slug post_id:[NSString stringWithFormat:@"%zd",weakSelf.share.ID] completion:^(BOOL isSuccess) {
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
    [alerVc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];

    
    [self presentViewController:alerVc animated:YES completion:nil];
    
}


- (void)setupTableView{
    
    [super setupTableView];
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, LGScreenW, self.share.xhCellHeght);
    LGXiaoHuaCell *cellView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LGXiaoHuaCell class]) owner:nil options:nil] firstObject];
    cellView.backgroundColor = [UIColor whiteColor];
    cellView.model = self.share;
    cellView.frame = headerView.bounds;
    [headerView addSubview:cellView];
    self.tableView.tableHeaderView = headerView;
}




@end
