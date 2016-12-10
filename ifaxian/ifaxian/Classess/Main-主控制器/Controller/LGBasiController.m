//
//  LGBasiController.m
//  ifaxian
//
//  Created by ming on 16/11/17.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGBasiController.h"

@interface LGBasiController ()

@end

@implementation LGBasiController


- (UINavigationBar *)navBar{
    if (_navBar == nil) {
        _navBar = [[UINavigationBar alloc] init];
        
    }
    
    return _navBar;
}
- (UINavigationItem *)navItem{
    
    if (_navItem == nil) {
        _navItem = [[UINavigationItem alloc] init];
    }
    
    return _navItem;
}

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];
    [super viewDidLoad];
    self.tableView.mj_footer.hidden = YES;
    
    [self setupNavBar];
    
    [self setupTableView];
    
 
    
}
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
    }
    
    return _tableView;
}


- (void)setupNavBar{
 
        self.navigationController.navigationBar.hidden = YES;

    self.navBar.frame = self.navigationController.navigationBar.bounds;
    self.navBar.lg_height += 20;
    self.navBar.items = @[self.navItem];
    self.navBar.barTintColor = [UIColor lg_colorWithHex:0xF6F6F6];
    self.navBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor lg_colorWithRed:37 green:37 blue:37]};
    
    [self.view addSubview:self.navBar];
    
   
}
- (void)setupTableView{
    
    
    
    self.tableView.frame = self.view.frame;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(self.navBar.lg_height, 0, self.tabBarController.tabBar.lg_height, 0);
  
    //包tableview插入到self.navBar的视图下面
    self.tableView.backgroundColor = LGCommonColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view insertSubview:self.tableView belowSubview:self.navBar];
    
    [self setupRefreshView];
}
- (void)setupRefreshView{
    
    self.tableView.mj_footer = [LGRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadOldData)];
    self.tableView.mj_header = [LGRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    
}
- (void)loadNewData{
    
    [self.tableView.mj_header endRefreshing];
}
- (void)loadOldData{
    
    [self.tableView.mj_footer endRefreshing];
    
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    
//    return 0;
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
   
    return cell;
    
}

@end
