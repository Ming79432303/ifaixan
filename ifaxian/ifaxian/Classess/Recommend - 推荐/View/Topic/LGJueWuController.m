//
//  LGJueWuController.m
//  ifaxian
//
//  Created by ming on 16/12/30.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGJueWuController.h"
#import "LGJueWuCell.h"
#import "LGDisplayController.h"
@interface LGJueWuController ()

@end

@implementation LGJueWuController
static NSString *juewuCellID = @"juewuCellID";
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LGJueWuCell class]) bundle:nil] forCellReuseIdentifier:juewuCellID];
    self.postName = @"juewu";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LGJueWuCell *cell = [tableView dequeueReusableCellWithIdentifier:juewuCellID];
    cell.model = self.dateArray[indexPath.row];
    
    return cell;
    
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LGRecommend *recomm = self.dateArray[indexPath.row];
    
    return recomm.jueWuHeight;
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
