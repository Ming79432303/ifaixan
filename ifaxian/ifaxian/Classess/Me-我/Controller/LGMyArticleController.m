//
//  LGMyarticleController.m
//  ifaxian
//
//  Created by ming on 16/11/21.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGMyArticleController.h"
#import "LGArticleModel.h"
#import "LGArticleCell.h"
#import "LGEditorController.h"
#import "LGSquareCell.h"
#import "LGShare.h"
#import "LGActivityViewModel.h"
#import "LGShareController.h"

@interface LGMyArticleController ()
@property (nonatomic, strong) NSArray<LGShare *> *postsArrayM;
@property (nonatomic, strong) LGActivityViewModel *postList;
@end
static NSString *articleCellID = @"articleCellID";
static NSString *squareCellID = @"squareCellID";
@implementation LGMyArticleController{
     NSInteger index_;
};

- (LGActivityViewModel *)postList{
    
    if (_postList == nil) {
        _postList = [[LGActivityViewModel alloc] init];
    }
    
    return _postList;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self setupRefreshView];
    index_ = 1;
    
    CGFloat bootmInset = LGnavBarH + LGtabBarH + LGTitleViewHeight;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0,bootmInset , 0);
    [self loadNewData];
    
    self.tableView.bounces = YES;
    self.tableView.contentInset = UIEdgeInsetsMake(200 + 35 - 74, 0, 64 + 35, 0);
   
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

    
}

- (void)loadNewData{
    
    
    [self.postList loadNewDatacompletion:^(BOOL isSuccess, NSArray<LGShare *> *shareArray) {
        
        if (isSuccess) {
            self.tableView.mj_footer.hidden = NO;
            self.postsArrayM = shareArray;
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        }else{
            
            [self.tableView.mj_header endRefreshing];
        }
        
        
        
    }];
    
    
}

- (void)loadOldData{
    
    [self.postList loadOldDatacompletion:^(BOOL isSuccess, NSArray<LGShare *> *shareArray) {
        if (isSuccess) {
            if (shareArray == nil) {
                self.tableView.mj_footer.hidden = YES;
                return ;
            }
            
            self.postsArrayM = shareArray;
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
        }else{
            
            [self.tableView.mj_footer endRefreshing];
        }
        
        
        
    }];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return self.postsArrayM.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LGShare *model = self.postsArrayM[indexPath.row];
      // 在这个方法中，已经将cell的高度 和 中间内容的frame 计算完毕
    if ([model.share.categories.firstObject.title isEqualToString:@"图片"]) {
         return model.rowHeight;
    }else{
        
                       
       
        return 110;

    }

    
    
    
   
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    LGShare *model = self.postsArrayM[indexPath.row];
    if ([model.share.categories.firstObject.title isEqualToString:@"图片"]) {
        
        LGSquareCell *cell = [tableView dequeueReusableCellWithIdentifier:squareCellID];
        cell.model = model;
        
        return cell;

        
    }else{
        
        LGArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:articleCellID];
        cell.postModel = model.share;
        
        return cell;
        
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
#warning 待改
           LGShare *share = self.postsArrayM[indexPath.row];
    if ([share.share.categories.firstObject.title isEqualToString:@"图片"]) {
        
        LGShareController *shareVc = [[LGShareController alloc] init];
        
        shareVc.share = share;
        shareVc.model = share.share;
        [self.navigationController pushViewController:shareVc animated:YES];

    }else{
            LGEditorController *editor = [[LGEditorController alloc] init];
               LGShare *model = self.postsArrayM[indexPath.row];
            editor.model = (LGArticleModel *)model.share;
        
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
