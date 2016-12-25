//
//  LGTagController.m
//  ifaxian
//
//  Created by ming on 16/12/18.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGTagController.h"
#import "LGPostModel.h"
#import "LGSearchCell.h"
#import "LGDisplayController.h"
#import "LGShareController.h"
#import "LGShare.h"
@interface LGTagController ()
@property(nonatomic, strong) NSMutableArray *tagsList;
@end
static NSString *serchCellID = @"serchCellID";
@implementation LGTagController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navItem.title = _tagTitle;
    
    [self.tableView.mj_header beginRefreshing];
}
- (void)loadNewData{
    NSString *url = [NSString requestBasiPathAppend:[NSString stringWithFormat:@"/api/get_tag_posts/?tag_slug=%@",_tagTitle]];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LGSearchCell class]) bundle:nil] forCellReuseIdentifier:serchCellID];
    self.tableView.rowHeight = 100;
    self.tableView.mj_footer.hidden = YES;
    NSString *tagUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    [[LGHTTPSessionManager manager] requestPostUrl:tagUrl completion:^(BOOL isSuccess, id responseObject) {
        if (isSuccess) {
            self.tagsList =[LGPostModel mj_objectArrayWithKeyValuesArray:responseObject[@"posts"]];
            [self.tableView reloadData];
        }
        [self.tableView.mj_header endRefreshing];
    }];

    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
  return self.tagsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LGPostModel *model = self.tagsList[indexPath.row];
    LGSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:serchCellID];
    cell.model = model;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LGPostModel *tageModel = self.tagsList[indexPath.row];
    
    if ([tageModel.categories.firstObject.title isEqualToString:@"分享"]) {
        
        
        LGShareController * pushVc = [[LGShareController alloc] init];
        pushVc.share = [[LGShare alloc] initWithModel:tageModel];
        [self.navigationController pushViewController:pushVc animated:YES];
    }else{
        
        LGDisplayController * pushVc = [[LGDisplayController alloc] init];
        pushVc.model = tageModel;
        [self.navigationController pushViewController:pushVc animated:YES];
    }
    
    
    
}


@end
