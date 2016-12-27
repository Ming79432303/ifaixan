//
//  LGHomeController.m
//  ifaxian
//
//  Created by ming on 16/11/17.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGHomeController.h"
#import "LGTestController.h"
#import "LGHomeModel.h"
#import "LGRefrshControl.h"
#import <MJRefresh.h>
#import "LGRefreshFooter.h"
#import "LGHomeController.h"
#import "LGHomeCell.h"
#import "LGDisplayController.h"
#import "LGNavigationController.h"
#import "LGHomeHeaderView.h"
#import "LGHTTPSessionManager.h"

@interface LGHomeController ()

@property (nonatomic, strong)  LGRefrshControl *refresh;
@property (nonatomic, strong) NSMutableArray<LGHomeModel *> *postsArrayM;
@property (nonatomic, strong) NSArray<LGHomeModel *>  *headerArray;
@property(nonatomic, strong)  LGHomeHeaderView *headerView;
@end

@implementation LGHomeController
 NSInteger index_ = 2;
static NSString *ID = @"cellID";

- (LGRefrshControl *)refresh{
    if (_refresh == nil) {
        _refresh = [[LGRefrshControl alloc] init];
        [self.tableView addSubview:_refresh];
    }
    
    return _refresh;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
   
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LGHomeCell class]) bundle:nil] forCellReuseIdentifier:ID];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addHeaderView];
 
   
}
- (void)addHeaderView{
    
    LGHomeHeaderView *headerView = [LGHomeHeaderView viewFromeNib];
    
    headerView.frame = CGRectMake(LGCommonMargin, 0, 200, 200);
    self.headerView = headerView;
    self.tableView.tableHeaderView = headerView;
    
    
    
}
- (void)setupNav{
    self.navItem.title = @"首页";
   // self.navItem.rightBarButtonItem = [UIBarButtonItem lg_itemWithImage:@"MainTagSubIcon" highImage:@"MainTagSubIconClick" target:self action:@selector(test)];
}

-(void)setupRefreshView{
    [self.refresh addTarget:self action:@selector(loadNewData) forControlEvents:UIControlEventValueChanged];
    [self.refresh beginRefreshing];
    [self loadNewData];
    self.tableView.mj_footer = [LGRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadOldDate)];
    [self loadHaderData];
}

- (void)loadHaderData{
NSString *url = [NSString requestBasiPathAppend:@"/?json=1&count=1"];
    [[LGHTTPSessionManager manager] requestPostUrl:url completion:^(BOOL isSuccess, id responseObject) {
         NSArray *headerList = [LGHomeModel mj_objectArrayWithKeyValuesArray:responseObject[@"posts"] context:nil];
        if (headerList.count > 3) {
            
            headerList = [headerList subarrayWithRange:NSMakeRange(0, 3)];
            
        }
        self.headerView.headerArray = headerList;

    }];
    
}

#warning 取消上一次的请求
- (void)loadNewData{
//    http://ifaxian.cc/page/1?json=1
    // Do any additional setup after loading the view.
    [[LGHTTPSessionManager manager] requsetHomelist:^(BOOL isSuccess, NSArray *json) {
        if (isSuccess) {
            [self.tableView.mj_footer resetNoMoreData];
            index_ = 2;
            self.postsArrayM =  [LGHomeModel mj_objectArrayWithKeyValuesArray:json context:nil];
            
            
            [self.postsArrayM removeObjectsInArray:self.headerArray];
            
            [self.tableView reloadData];
            [self.refresh endRefreshing];
        }else{
            
             [self.refresh endRefreshing];
        }
        
    }];

}

- (void)loadOldDate{
//http://112.74.45.39/page/1?json=5&count=20
    NSString *url = [NSString stringWithFormat:@"https://ifaxian.cc/category/home/page/%zd?json=1",index_];
    
    
    [[LGHTTPSessionManager manager] requsetUrl:url completion:^(BOOL isSuccess, NSArray *json) {
       
        if (json == nil) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            return ;
        }
        if (isSuccess) {
            NSArray<LGHomeModel *> *posts =  [LGHomeModel mj_objectArrayWithKeyValuesArray:json context:nil];
            
            if (self.postsArrayM.lastObject.ID > posts.firstObject.ID) {
                 [self.postsArrayM addObjectsFromArray:posts];
                 [self.tableView.mj_footer endRefreshing];
                 [self.tableView reloadData];
            }else{
                
                [self.postsArrayM addObjectsFromArray:posts];
                NSMutableArray *arrayM = [NSMutableArray array];
                for (LGPostModel *model in self.postsArrayM) {
                    
                    if (![arrayM containsObject:model]) {
                        [arrayM addObject:model];
                    }
                    
                }
             
                
                self.postsArrayM = arrayM;
#warning 最后一页处理
                
            }
      
            index_ += 1;
            [self.tableView.mj_footer endRefreshing];
        }else{
            
            [self.tableView.mj_footer endRefreshing];
            
            
        }
        
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.postsArrayM.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LGHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    cell.model = self.postsArrayM[indexPath.row];
    
    
    return cell;
    
}



- (void)test{
    
    [self.navigationController pushViewController:[[LGTestController alloc] init] animated:YES];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return self.postsArrayM[indexPath.row].rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LGDisplayController *displayVc = [[LGDisplayController alloc] init];
    displayVc.model = self.postsArrayM[indexPath.row];

    [self.navigationController pushViewController:displayVc animated:YES];
    
    
}



@end
