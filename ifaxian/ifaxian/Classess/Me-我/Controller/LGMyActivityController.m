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
     self.tableView.scrollEnabled = LGuserInteractionEnabled;
      CGFloat bootmInset = LGnavBarH + LGtabBarH + LGTitleViewHeight;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0,bootmInset , 0);
    // Do any additional setup after loading the view.
}
- (void)setupNavBar{
    
    
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
    
    cell.textLabel.text = @"123";
    
    return cell;
    
    
}

@end
