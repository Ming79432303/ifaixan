//
//  LGMyActivityController.m
//  ifaxian
//
//  Created by ming on 16/11/21.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGMyActivityController.h"

@interface LGMyActivityController ()

@end

@implementation LGMyActivityController

- (void)viewDidLoad {
    [super viewDidLoad];
      self.tableView.contentInset = UIEdgeInsetsMake(200 + 35 - 74, 0,47, 0);
}
- (void)setupNavBar{
    
    
}



- (void)setupTableView{
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
    }
    
    cell.textLabel.text = @"act123";
    
    return cell;
    
    
}

@end
