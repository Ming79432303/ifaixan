//
//  LGVideoCommentController.m
//  ifaxian
//
//  Created by ming on 16/12/25.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGVideoCommentController.h"
#import "LGVideoCell.h"
@interface LGVideoCommentController ()

@end

@implementation LGVideoCommentController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *headerView = [[UIView alloc] init];
    
    headerView.frame = CGRectMake(0, 0, LGScreenW, self.share.VideoCellHeght);
    LGVideoCell *cellView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LGVideoCell class]) owner:nil options:nil] firstObject];
    
    cellView.backgroundColor = [UIColor whiteColor];
    cellView.model = self.share;
    cellView.frame = headerView.bounds;
    [headerView addSubview:cellView];
    
    self.tableView.tableHeaderView = headerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
