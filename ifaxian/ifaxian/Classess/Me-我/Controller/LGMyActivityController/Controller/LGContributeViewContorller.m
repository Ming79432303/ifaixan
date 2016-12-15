//
//  LGcontributeViewContorller.m
//  ifaxian
//
//  Created by ming on 16/12/14.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGcontributeViewContorller.h"
#import "LGContributeController.h"

@interface LGContributeViewContorller ()
@property(nonatomic, strong) UINavigationBar *navBar;
@property(nonatomic, strong)  UINavigationItem *navItem;
@end

@implementation LGContributeViewContorller
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
    [super viewDidLoad];
    self.navItem.title = @"投稿";
    UIStoryboard *story = [UIStoryboard storyboardWithName:NSStringFromClass([LGContributeController class]) bundle:nil];
    
   UITableViewController *tabView = [story instantiateInitialViewController];
      tabView.tableView.contentInset = UIEdgeInsetsMake(LGnavBarH, 0, LGtabBarH, 0);
    [self addChildViewController:tabView];
    [self.view addSubview:tabView.tableView];
    [self setupNavBar];
}

- (void)setupNavBar{
    
    self.navigationController.navigationBar.hidden = YES;
    
    self.navBar.frame = self.navigationController.navigationBar.bounds;
    self.navBar.lg_height += 20;
    self.navBar.items = @[self.navItem];
    self.navBar.barTintColor = [UIColor lg_colorWithHex:0xF6F6F6];
    self.navBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor lg_colorWithRed:37 green:37 blue:37]};
    
    [self.view addSubview:self.navBar];
    self.navItem.leftBarButtonItem = [UIBarButtonItem lg_barButtonCustButton:@"返回" fontSize:14 addTarget:self action:@selector(popVc) isBack:YES];
    
}
- (void)popVc{
    [self.navBar removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}



@end
