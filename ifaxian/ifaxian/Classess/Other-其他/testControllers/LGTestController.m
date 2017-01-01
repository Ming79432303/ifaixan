//
//  LGTestController.m
//  ifaxian
//
//  Created by ming on 16/11/17.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGTestController.h"
#import <WordPress-iOS-Shared/WordPressShared/WPTextFieldTableViewCell.h>
#import <WordPressShared/NSString+XMLExtensions.h>
@interface LGTestController ()

@end

@implementation LGTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navItem.title = @"测试控制器";
    self.navItem.rightBarButtonItem = [UIBarButtonItem lg_barButtonCustButton:@"下一个" fontSize:14 addTarget:self action:@selector(next) isBack:NO];

    

    
}
- (void)next{
    [self.navigationController pushViewController:[[LGTestController alloc] init] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setupTableView{
    
    [super setupTableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"123";
    
    WPTextFieldTableViewCell *cell = [[WPTextFieldTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    
    cell.textLabel.text = @"世界你好";
    
    
    return cell;
    
    
}




@end
