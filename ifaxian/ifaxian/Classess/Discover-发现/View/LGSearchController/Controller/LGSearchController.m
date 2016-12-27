//
//  LGSearchController.m
//  ifaxian
//
//  Created by ming on 16/11/26.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGSearchController.h"
#import "LGPostModel.h"
#import "LGSearchCell.h"
#import "LGSearch.h"
#import "LGShareController.h"
#import "LGDisplayController.h"
@interface LGSearchController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property (weak, nonatomic) IBOutlet UIView *searchHeaderView;
@property (strong, nonatomic) NSMutableArray<LGSearch *> *results;
@property(nonatomic, copy) NSString *searchStr;
@end

 static NSString *cellID = @"serchCellID";
@implementation LGSearchController{
    
    NSInteger index_;
}

- (NSMutableArray *)results{
    
    if (_results == nil) {
        _results = [NSMutableArray array];
    }
    
    return _results;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    index_ = 1;
    [self setupTableVIew];
    
    LGWeakSelf;
    self.search = ^(NSString *search){
       
        weakSelf.searchStr = search;
        index_ = 1;
        [weakSelf loadData];
        
    };
    
}


- (void)setupTableVIew{
   
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    LGRefreshFooter *foot = [LGRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNextData)];
    self.tableView.mj_footer = foot;
    self.tableView.mj_footer.hidden = YES;
    self.searchHeaderView.hidden = YES;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LGSearchCell class]) bundle:nil] forCellReuseIdentifier:cellID];
    self.tableView.hidden = YES;
    self.tableView.rowHeight = 100;
}

#pragma mark - 搜索BUG:-猜想原因之前的网络请求取消了任然回调
- (void)loadData{
    if (self.searchStr.length <= 0) {
        [self.results removeAllObjects];
        [self.tableView reloadData];
        self.tableView.hidden = YES;
        self.searchHeaderView.hidden = YES;
        return;
    }
    
    self.searchHeaderView.hidden = NO;
    self.activityView.hidden = NO;
    self.titleLable.text = [NSString stringWithFormat:@"正在查找%@",self.searchStr];
    self.tableView.hidden = YES; 
    self.tableView.mj_footer.hidden = NO;
    LGWeakSelf;
    //取消前一次的请求
    [[LGNetWorkingManager manager].tasks makeObjectsPerformSelector:@selector(cancel)];
   

    
  [[LGNetWorkingManager manager] requestSearch:self.searchStr page:index_ completion:^(BOOL isSccess, NSDictionary *responseObject) {
      if (isSccess) {
          
          NSMutableArray *searchsM = [NSMutableArray array];
          NSMutableArray *postArray = [LGPostModel mj_objectArrayWithKeyValuesArray:responseObject[@"posts"]];
          
         // NSArray *postArray = responseObject[@"posts"];
          
          for (LGPostModel *parems in postArray) {
              
              LGSearch *sears = [[LGSearch alloc] initWithModel:parems];
              [searchsM addObject:sears];
          }
          
          
          
          NSString * count_total = responseObject[@"count_total"];
          if ([count_total integerValue] == 0) {
              weakSelf.titleLable.text = @"没有找到数据";
              weakSelf.activityView.hidden = YES;
               self.tableView.mj_footer.hidden = YES;
              return ;
          }
          
          if (weakSelf.results.count == [count_total integerValue]) {
              weakSelf.tableView.mj_footer.hidden = YES;
          }
          
          //[self.results addObjectsFromArray:postArray];
          weakSelf.results = searchsM;
          weakSelf.searchHeaderView.hidden = YES;
          weakSelf.tableView.hidden = NO;
          [weakSelf.tableView.mj_footer endRefreshing];
          [weakSelf.tableView reloadData];
          index_ +=1;
          
          
      }else{
          weakSelf.tableView.mj_footer.hidden = YES;
          [weakSelf.tableView.mj_footer endRefreshing];
          weakSelf.searchHeaderView.hidden = YES;
          weakSelf.tableView.hidden = YES;

      }
    }];
    
    
}

- (void)loadNextData{
    LGWeakSelf;
    [[LGNetWorkingManager manager] requestSearch:self.searchStr page:index_ completion:^(BOOL isSccess, NSDictionary *responseObject) {
        if (isSccess) {
            
            
            NSMutableArray *searchsM = [NSMutableArray array];
            NSMutableArray *postArray = [LGPostModel mj_objectArrayWithKeyValuesArray:responseObject[@"posts"]];
            
            // NSArray *postArray = responseObject[@"posts"];
            
            for (LGPostModel *parems in postArray) {
                
                LGSearch *sears = [[LGSearch alloc] initWithModel:parems];
                [searchsM addObject:sears];
            }
            
            NSString * count_total = responseObject[@"count_total"];
            if ([count_total integerValue] == 0) {
                weakSelf.titleLable.text = @"没有找到数据";
                weakSelf.activityView.hidden = YES;
                weakSelf.tableView.mj_footer.hidden = YES;
                return ;
            }
            
            if (weakSelf.results.count == [count_total integerValue]) {
                weakSelf.tableView.mj_footer.hidden = YES;
            }
            
            //[self.results addObjectsFromArray:postArray];
            [weakSelf.results addObjectsFromArray:searchsM];
         
           
            [weakSelf.tableView.mj_footer endRefreshing];
            [weakSelf.tableView reloadData];
            index_ += 1;
        }else{
           
            [weakSelf.tableView.mj_footer endRefreshing];
            
        }
    }];

    
    
}





- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return self.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    
    LGSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.model = self.results[indexPath.row].share;
    
    return cell;
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.view endEditing:YES];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LGSearch *search = self.results[indexPath.row];
 
    if ([search.share.categories.firstObject.title isEqualToString:@"分享"]) {
    LGShareController * pushVc = [[LGShareController alloc] init];
       pushVc.share = search;
       [self.navigationController pushViewController:pushVc animated:YES];
    }else{
        
     LGDisplayController * pushVc = [[LGDisplayController alloc] init];
        pushVc.model = search.share;
        [self.navigationController pushViewController:pushVc animated:YES];
    }
     
     
    
}

- (void)dealloc{
    

    
}

@end
