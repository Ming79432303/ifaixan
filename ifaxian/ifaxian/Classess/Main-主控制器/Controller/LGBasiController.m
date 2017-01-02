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

#pragma mark - 自定导航栏懒加载
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
    //设置背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    [super viewDidLoad];
    self.tableView.mj_footer.hidden = YES;
    //自定义导航栏设置
    [self setupNavBar];
    //tableVie设置
    [self setupTableView];

}
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
    }
    
    return _tableView;
}

#pragma mark - 自定义导航栏config
- (void)setupNavBar{
    //隐藏系统的导航栏
    self.navigationController.navigationBar.hidden = YES;
    //设置导航栏的frame
    self.navBar.frame = self.navigationController.navigationBar.bounds;
    //加上电池栏的高度
    self.navBar.lg_height += 20;
    //添加navItem这样才能显示我们的控制器标题
    self.navBar.items = @[self.navItem];
    self.navBar.barTintColor = [UIColor lg_colorWithHex:0xF6F6F6];
    //navBar背景颜色
    self.navBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor lg_colorWithRed:37 green:37 blue:37]};
    [self.view addSubview:self.navBar];
}
#pragma mark - TableView config
- (void)setupTableView{
    //设置frame
    self.tableView.frame = self.view.frame;
    //设置代理
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //取消系统自动添加的内边距
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(self.navBar.lg_height, 0, LGtabBarH + LGstatusBarH, 0);
    //包tableview插入到self.navBar的视图下面
    self.tableView.backgroundColor = LGCommonColor;
    //取出线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //添加到navBar的下面
    [self.view insertSubview:self.tableView belowSubview:self.navBar];
    //添加上下拉刷新
    [self setupRefreshView];
}

#pragma mark - 添加上下拉刷新
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
