//
//  LGVideoController.m
//  ifaxian
//
//  Created by ming on 16/11/17.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGSquareController.h"
#import "LGHTTPSessionManager.h"
#import "LGShareImage.h"
#import "LGShareViewModel.h"
#import "LGSquareCell.h"
#import "LGShareController.h"
#import "LGTestController.h"
#import "LGVideoCell.h"
@interface LGSquareController ()

@property (nonatomic, strong) NSArray<LGShare *> *shares;
@property (nonatomic, strong) LGShareViewModel *shareViewModel;

@end

@implementation LGSquareController
static NSString *squareCellID = @"squareCellID";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    self.navItem.title = @"用户分享";
    [self.tableView.mj_header beginRefreshing];
    self.tableView.rowHeight = 600;
    
}
- (LGShareViewModel *)shareViewModel{
    
    if (_shareViewModel == nil) {
        _shareViewModel = [[LGShareViewModel alloc] init];
    }
    
    return _shareViewModel;
}
//- (NSMutableArray<LGShare *> *)shares{
//    if (_shares == nil) {
//        _shares = [NSMutableArray array];
//    }
//    
//    return _shares;
//}

- (void)setupUI{
    
    
}

- (void)setupTableView{
  
    [super setupTableView];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LGSquareCell class]) bundle:nil] forCellReuseIdentifier:squareCellID];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = LGCommonColor;
    
    
    
}

- (void)loadNewData{
    
    
    [self.shareViewModel loadNewDatacompletion:^(BOOL isSuccess, NSArray<LGShare *> *shareArray) {
        
        if (isSuccess) {
             self.tableView.mj_footer.hidden = NO;
            self.shares = shareArray;
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        }else{
            
            [self.tableView.mj_header endRefreshing];
        }
        
        
        
    }];

    
}

- (void)loadOldData{
    
    [self.shareViewModel loadOldDatacompletion:^(BOOL isSuccess, NSArray<LGShare *> *shareArray) {
        if (isSuccess) {
            if (shareArray == nil) {
                self.tableView.mj_footer.hidden = YES;
                return ;
            }
            
            self.shares = shareArray;
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
        }else{
            
            [self.tableView.mj_footer endRefreshing];
        }
       
        
        
    }];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.shares.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
   LGShare *share = self.shares[indexPath.row];
    
        LGSquareCell *cell = [tableView dequeueReusableCellWithIdentifier:squareCellID];
        cell.model = share;
        return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return self.shares[indexPath.row].rowHeight;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LGShareController *shareVc = [[LGShareController alloc] init];

    LGShare *share = self.shares[indexPath.row];
    
    shareVc.share = share;
    

    [self.navigationController pushViewController:shareVc animated:YES];
    
}


//cell离开
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    LGSquareCell *videoCell = [tableView cellForRowAtIndexPath:indexPath];
    if (videoCell.playerView) {
        
        [videoCell.playerView.subviews.firstObject removeFromSuperview];
        [videoCell.playerView removeFromSuperview];
    }
    
}



@end
