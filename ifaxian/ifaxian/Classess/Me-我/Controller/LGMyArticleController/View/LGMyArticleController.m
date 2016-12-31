//
//  LGMyarticleController.m
//  ifaxian
//
//  Created by ming on 16/11/21.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGMyArticleController.h"
#import "LGDisplayController.h"
#import "LGUserListController.h"

@interface LGMyArticleController ()
@property(nonatomic, assign) NSInteger lastCount;
@end
static NSString *articleCellID = @"articleCellID";
static NSString *squareCellID = @"squareCellID";

@implementation LGMyArticleController{
     NSInteger index_;
};
- (LGActivityViewModel *)postList{
    
    if (_postList == nil) {
        _postList = [[LGActivityViewModel alloc] init];
        _postList.userName = _userName;
    }
    
    return _postList;
}


- (void)viewDidLoad {
  
    [super viewDidLoad];
    [self setupTableView];
    [self setupRefreshView];
    [self.tableView.mj_header beginRefreshing];
    index_ = 1;
   
}

- (void)setupRefreshView{
    
    self.tableView.mj_footer = [LGRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadOldData)];
    self.tableView.mj_header = [LGRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    
}



- (void)setupTableView{
    

 
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LGArticleCell class]) bundle:nil] forCellReuseIdentifier:articleCellID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LGSquareCell class]) bundle:nil] forCellReuseIdentifier:squareCellID];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
   
    [self loadNewData];
    self.tableView.bounces = YES;
    
    self.tableView.contentInset = UIEdgeInsetsMake(LGBacImageViewHeight - LGstatusBarH, 0, LGtabBarH, 0);
    self.tableView.backgroundColor = LGCommonColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)loadNewData{
    
    LGWeakSelf;
    [self.postList loadNewDatacompletion:^(BOOL isSuccess, NSArray<LGShare *> *shareArray) {
        
        if (isSuccess) {
            [weakSelf.tableView.mj_footer resetNoMoreData];
            weakSelf.tableView.mj_footer.hidden = NO;
            weakSelf.postsArrayM = shareArray;
            [weakSelf.tableView reloadData];
        }
            
            [weakSelf.tableView.mj_header endRefreshing];
    
        
        
        
    }];
    
    
}

- (void)loadOldData{
    LGWeakSelf;
    [self.postList loadOldDatacompletion:^(BOOL isSuccess, NSArray<LGShare *> *shareArray) {
        if (isSuccess) {
          
            if (_lastCount == shareArray.count) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                return ;
            }
            weakSelf.postsArrayM = shareArray;
            [weakSelf.tableView reloadData];
            weakSelf.lastCount = shareArray.count;
        }
        [weakSelf.tableView.mj_footer endRefreshing];
        
    }];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return self.postsArrayM.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LGShare *model = self.postsArrayM[indexPath.row];
      // 在这个方法中，已经将cell的高度 和 中间内容的frame 计算完毕
    if ([model.share.categories.firstObject.title isEqualToString:@"分享"]) {
         return model.rowHeight;
    }else{
        
                       
       
        return 110;

    }

    
    
    
   
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    LGShare *model = self.postsArrayM[indexPath.row];
    if ([model.share.categories.firstObject.title isEqualToString:@"分享"]) {
        
        LGSquareCell *cell = [tableView dequeueReusableCellWithIdentifier:squareCellID];
        cell.model = model;
        
        return cell;

        
    }else{
        
        LGArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:articleCellID];
        cell.postModel = (LGShareImage *) model.share;
        
        return cell;
        
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
#warning 待改
           LGShare *model = self.postsArrayM[indexPath.row];
    if ([model.share.categories.firstObject.title isEqualToString:@"分享"]) {
        
        LGShareController *shareVc = [[LGShareController alloc] init];
        
        shareVc.share = model;
        shareVc.model = model.share;
        [self.navigationController pushViewController:shareVc animated:YES];

    }else{
        
        if ([self isKindOfClass:[LGUserListController class]]) {
            LGDisplayController *disVc = [[LGDisplayController alloc] init];
            disVc.model = model.share;
             [self.navigationController pushViewController:disVc animated:YES];
            return;
        }
        
            LGEditorController *editor = [[LGEditorController alloc] init];
        
            editor.model =  model.share;
        
            [self.navigationController pushViewController:editor animated:YES];

        
    }
    
}

//cell离开
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
//       UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[LGSquareCell class]]) {
         LGSquareCell *videoCell = (LGSquareCell *)cell;
        if (videoCell.playerView) {
            
            [videoCell.playerView.subviews.firstObject removeFromSuperview];
            [videoCell.playerView removeFromSuperview];
            
        }
    }
   
    
}



@end
