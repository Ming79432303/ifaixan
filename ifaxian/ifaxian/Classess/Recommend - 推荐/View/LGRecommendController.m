//
//  LGRecommendController.m
//  ifaxian
//
//  Created by ming on 16/12/10.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGRecommendController.h"
#import "HYPageView.h"
@interface LGRecommendController ()

@end

@implementation LGRecommendController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navItem.title = @"精选推荐";
    HYPageView *pageView = [[HYPageView alloc] initWithFrame:CGRectMake(0, self.navBar.lg_height, LGScreenW, LGScreenH) withTitles:@[@"发现笑话",@"发现动漫",@"发现视频",@"发现好货"] withViewControllers:@[@"LGTopicXiaoHuaController",@"LGTopicDongManController",@"LGTopicVideoController",@"LGJueWuController"] withParameters:nil];
    pageView.isTranslucent = NO;
    pageView.selectedColor = [UIColor blackColor];
    pageView.unselectedColor = [UIColor darkGrayColor];
    [self.view addSubview:pageView];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
