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
@interface LGMyArticleController ()
@property (nonatomic, strong) NSMutableArray<LGArticleModel *> *postsArrayM;
@end
static NSString *articleCellID = @"articleCellID";
@implementation LGMyArticleController{
     NSInteger index_;
};


- (void)viewDidLoad {
    [super viewDidLoad];
    index_ = 1;
       self.tableView.scrollEnabled = LGuserInteractionEnabled;
    CGFloat bootmInset = LGnavBarH + LGtabBarH + LGTitleViewHeight;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0,bootmInset , 0);
    [self.tableView.mj_header beginRefreshing];
    // Do any additional setup after loading the view.
}



-(void)setupNavBar{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupTableView{
    
    [super setupTableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LGArticleCell class]) bundle:nil] forCellReuseIdentifier:articleCellID];
    self.tableView.rowHeight = 150;
    
    
}

- (void)loadNewData{
    //    http://ifaxian.cc/page/1?json=1
    // Do any additional setup after loading the view.
    [[LGNetWorkingManager manager] requsetUrl:@"http://112.74.45.39/author/ming/page/1?json=1" completion:^(BOOL isSuccess, NSArray *json) {
        
        self.postsArrayM =  [LGArticleModel mj_objectArrayWithKeyValuesArray:json context:nil];
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];
    
}


- (void)loadOldData{
   
   
    NSString *url = [NSString stringWithFormat:@"http://112.74.45.39/author/ming/page/%zd?json=1",index_];
    
    
    [[LGNetWorkingManager manager] requsetUrl:url completion:^(BOOL isSuccess, NSArray *json) {
        
        
        if (isSuccess) {
            NSArray<LGArticleModel *> *posts =  [LGArticleModel mj_objectArrayWithKeyValuesArray:json context:nil];
            
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
            }
            
            index_ += 1;
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
        }
        
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return self.postsArrayM.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LGArticleModel *model = self.postsArrayM[indexPath.row];
      // 在这个方法中，已经将cell的高度 和 中间内容的frame 计算完毕
    return model.articleCellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    LGArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:articleCellID];
    cell.postModel = self.postsArrayM[indexPath.row];
    return cell;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LGEditorController *editor = [[LGEditorController alloc] init];
    editor.model = self.postsArrayM[indexPath.row];
    
    [self.navigationController pushViewController:editor animated:YES];
    
    
}

@end
