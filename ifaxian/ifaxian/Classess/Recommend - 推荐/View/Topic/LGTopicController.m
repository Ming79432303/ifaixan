//
//  LGTopicViewController.m
//  ifaxian
//
//  Created by ming on 16/12/7.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGTopicController.h"

@interface LGTopicController ()

@end

@implementation LGTopicController


- (LGRecommendViewModel *)recommend{
    if (_recommend == nil) {
        _recommend = [[LGRecommendViewModel alloc] init];
        _recommend.postName = self.postName;
    }
    
    return _recommend;
}
- (NSArray *)dateArray{
    if (_dateArray == nil) {
        _dateArray = [NSArray array];
    }
    
    return _dateArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setupRefreshView];
    [self setupTableView];
    self.tableView.backgroundColor = LGCommonColor;
    [self.tableView.mj_header beginRefreshing];
    
    
}






- (void)setupRefreshView{
    
    self.tableView.mj_header = [LGRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    self.tableView.mj_footer = [LGRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadOldData)];
    
}

- (void)loadNewData{
#warning contentInset在这里设置才有效有问题
    UIEdgeInsets tabInset = self.tableView.contentInset;
    
    self.tableView.contentInset = UIEdgeInsetsMake(tabInset.top, tabInset.left, 84, tabInset.right);
    LGWeakSelf;
    [self.recommend loadNewDataCompletion:^(BOOL isSuccess, NSArray *array) {
        weakSelf.dateArray = array;
        [weakSelf.tableView reloadData];
        if (isSuccess) {
            [weakSelf.tableView.mj_footer resetNoMoreData];
            [weakSelf.tableView.mj_header endRefreshing];
        }
        
    }];
    
    
}

- (void)loadOldData{
    
    LGWeakSelf;

    [self.recommend loadOldDataCompletion:^(BOOL isSuccess, NSArray *array) {
       
        
        if (isSuccess) {
             if (array==nil) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                return ;
            }
            
            weakSelf.dateArray = array;
           
            [weakSelf.tableView reloadData];
            
        }
        [weakSelf.tableView.mj_footer endRefreshing];
        
    }];
    
}





- (void)setupTableView{
    

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dateArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    
    return [[UITableViewCell alloc] init];
    
    
    
}




@end
