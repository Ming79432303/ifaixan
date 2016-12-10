//
//  LGBasiController.h
//  ifaxian
//
//  Created by ming on 16/11/17.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LGBasiController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) UINavigationBar *navBar;
@property(nonatomic, strong)  UINavigationItem *navItem;
@property(nonatomic, strong) UITableView *tableView;
- (void)setupTableView;
- (void)setupRefreshView;
- (void)setupNavBar;
- (void)loadNewData;
- (void)loadOldData;
@end
