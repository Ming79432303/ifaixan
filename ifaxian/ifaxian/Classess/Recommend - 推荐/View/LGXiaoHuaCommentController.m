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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
