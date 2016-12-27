//
//  LGTopicVideoController.m
//  ifaxian
//
//  Created by ming on 16/12/8.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGTopicVideoController.h"
#import "LGVideoCell.h"
#import "LGRecommend.h"
#import "LGVideoCommentController.h"

@interface LGTopicVideoController ()
@property(nonatomic, strong) NSMutableSet *set;
@end

@implementation LGTopicVideoController
static NSString *videoCellID = @"videoCellID";


- (NSMutableSet *)set{
    
    if (_set == nil) {
        _set = [NSMutableSet set];
    }
 
    return _set;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LGVideoCell class]) bundle:nil] forCellReuseIdentifier:videoCellID];
    self.postName = @"sp";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LGVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:videoCellID];
    cell.model = self.dateArray[indexPath.row];

    return cell;
    
    
    
}
//cell离开
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    LGVideoCell *videoCell = [tableView cellForRowAtIndexPath:indexPath];
    if (videoCell.playerView) {
        
        [videoCell.playerView.subviews.firstObject removeFromSuperview];
        [videoCell.playerView removeFromSuperview];
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    LGRecommend *recomm = self.dateArray[indexPath.row];
    LGVideoCommentController *videoComment = [[LGVideoCommentController alloc] init];
    videoComment.share = recomm;
    videoComment.model = recomm;
    UITabBarController *tab = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = tab.selectedViewController;
    [nav pushViewController:videoComment animated:YES];
    
    
    [self.navigationController pushViewController:videoComment animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LGRecommend *recomm = self.dateArray[indexPath.row];
    
    return recomm.VideoCellHeght;
}


@end
