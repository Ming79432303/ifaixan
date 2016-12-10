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
- (NSMutableArray *)dateArray{
    if (_dateArray == nil) {
        _dateArray = [NSMutableArray array];
    }
    
    return _dateArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setupRefreshView];
    [self setupTableView];
    [self.tableView.mj_header beginRefreshing];
}

- (void)setupRefreshView{
    
    self.tableView.mj_header = [LGRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    self.tableView.mj_footer = [LGRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadOldData)];
}

- (void)loadOldData{
    
    LGWeakSelf;
    self.tableView.backgroundColor = LGCommonColor;
    [self.recommend loadOldDataCompletion:^(BOOL isSuccess, NSArray *array) {
        weakSelf.dateArray = array;
        [self.tableView reloadData];
        if (isSuccess) {
            [self.tableView.mj_footer endRefreshing];
        }
        
        
    }];
    
}

- (void)loadNewData{
    LGWeakSelf;
    self.tableView.backgroundColor = LGCommonColor;
    [self.recommend loadNewDataCompletion:^(BOOL isSuccess, NSArray *array) {
        weakSelf.dateArray = array;
        [self.tableView reloadData];
        if (isSuccess) {
            [self.tableView.mj_header endRefreshing];
        }
        
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
