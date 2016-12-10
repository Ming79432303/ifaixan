//
//  LGUseragreement.m
//  ifaxian
//
//  Created by ming on 16/12/10.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGUseragreement.h"

@interface LGUseragreement ()

@end

@implementation LGUseragreement

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navItem.title = @"用户使用协议";
    UIWebView *weBview = [[UIWebView alloc] init];
    
    [weBview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString requestBasiPathAppend:@"/user.html"]]]];
    
    weBview.frame = self.tableView.frame;
    weBview.lg_height -= 64;
    [self.tableView addSubview:weBview];
    
}
- (void)setupRefreshView{
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc{

    NSLog(@"12");
}

@end
