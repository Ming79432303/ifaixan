//
//  LGXiaoHuaViewController.m
//  ifaxian
//
//  Created by ming on 16/12/7.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGTopicXiaoHuaController.h"
#import "LGXiaoHuaCell.h"
#import "LGXiaoHuaCommentController.h"


@interface LGTopicXiaoHuaController ()

@end
@implementation LGTopicXiaoHuaController
static NSString *xiaoHuaCellID = @"xiaoHuaCellID";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.postName = @"xiaohua";
   
  
[self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LGXiaoHuaCell class]) bundle:nil] forCellReuseIdentifier:xiaoHuaCellID];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LGXiaoHuaCell *cell = [tableView dequeueReusableCellWithIdentifier:xiaoHuaCellID];
    cell.model = self.dateArray[indexPath.row];
    
    return cell;
    
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
     LGRecommend *recomm = self.dateArray[indexPath.row];
    LGXiaoHuaCommentController *xhComment = [[LGXiaoHuaCommentController alloc] init];
    xhComment.share = recomm;
    xhComment.model = recomm;
    UITabBarController *tab = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = tab.selectedViewController;
    [nav pushViewController:xhComment animated:YES];

    
    [self.navigationController pushViewController:xhComment animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LGRecommend *recomm = self.dateArray[indexPath.row];
    
    return recomm.xhCellHeght;
}
@end
