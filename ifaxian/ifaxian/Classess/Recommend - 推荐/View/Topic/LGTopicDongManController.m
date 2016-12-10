//
//  LGDongManController.m
//  ifaxian
//
//  Created by ming on 16/12/7.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGTopicDongManController.h"
#import "LGRecommendViewModel.h"
#import "LGDongmanCell.h"
#import "LGDisplayController.h"
@interface LGTopicDongManController ()

@end
static NSString *dongmanCellID = @"dongmanCellID";
@implementation LGTopicDongManController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LGDongmanCell class]) bundle:nil] forCellReuseIdentifier:dongmanCellID];
    self.postName = @"dm";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LGDongmanCell *cell = [tableView dequeueReusableCellWithIdentifier:dongmanCellID];
    cell.model = self.dateArray[indexPath.row];
    
    return cell;
    
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LGRecommend *recomm = self.dateArray[indexPath.row];
    
    return recomm.dmCellHeght;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LGRecommend *recomm = self.dateArray[indexPath.row];
    LGDisplayController *vc = [[LGDisplayController alloc] init];
    vc.model = recomm;
    UITabBarController *tab = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = tab.selectedViewController;
    [nav pushViewController:vc animated:YES];
    
}


@end
