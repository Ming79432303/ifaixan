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
    self.postName = @"video";
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
     videoCell.starVideoButton.hidden = NO;
    [videoCell.playerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [videoCell.playerView removeFromSuperview];

}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LGRecommend *recomm = self.dateArray[indexPath.row];
    
    return recomm.VideoCellHeght;
}


@end
