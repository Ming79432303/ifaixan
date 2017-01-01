//
//  LGSetingController.m
//  ifaxian
//
//  Created by ming on 16/12/10.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGSetingController.h"
#import "LGClearCell.h"
#import "LGSetingCell.h"
#import "LGSetingItem.h"
#import "LGSetingArrow.h"
#import "LGUseragreement.h"
#import "LGAboutController.h"

@interface LGSetingController ()
@property(nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation LGSetingController

static NSString *clearCellID = @"clearCellID";
static NSString *setingCellID = @"setingCellID";

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navItem.title = @"设置";
   
}
- (void)setupRefreshView{
    
    
    
}

- (void)setupTableView{
    
    [super setupTableView];
    
    [self.tableView registerClass:[LGClearCell class] forCellReuseIdentifier:clearCellID];
    [self.tableView registerClass:[LGSetingCell class] forCellReuseIdentifier:setingCellID];
    [self setGroup1];
     [self setGroup2];
    
}

- (void)setGroup1{
    
    LGSetingItem *item = [LGSetingItem setingTitle:nil detail:nil];
    NSArray *array = @[item];
    
    [self.dataArray addObject:array];
    
}


- (void)setGroup2{
    
    LGSetingArrow *item1 = [LGSetingArrow setingTitle:@"用户使用协议" detail:nil];
    item1.className = [LGUseragreement class];
     LGSetingArrow *item2 = [LGSetingArrow setingTitle:@"关于我们" detail:nil];
    item2.className = [LGAboutController class];
    NSArray *array = @[item1,item2];
    
    
    [self.dataArray addObject:array];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *array = self.dataArray[section];
    
    return array.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *array = self.dataArray[indexPath.section];
    LGSetingArrow *item = array[indexPath.row];
    if ([item isKindOfClass:[LGSetingArrow class]]) {
        
        LGSetingCell *cell = [tableView dequeueReusableCellWithIdentifier:setingCellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
          cell.textLabel.text = item.title;
        return cell;
      
      
    }else{
        LGClearCell *cell = [tableView dequeueReusableCellWithIdentifier:clearCellID];
        
        return cell;
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *array = self.dataArray[indexPath.section];
    LGSetingArrow *item = array[indexPath.row];
    if ([item isKindOfClass:[LGSetingArrow class]]) {
      //控制器跳转
        if (item.class) {
            
            UIViewController *user = [[item.className alloc] init];
            [self.navigationController pushViewController:user animated:YES];
        }
        
        
    }else{
        //其他
        
        
    }

    
    
    
}



@end
