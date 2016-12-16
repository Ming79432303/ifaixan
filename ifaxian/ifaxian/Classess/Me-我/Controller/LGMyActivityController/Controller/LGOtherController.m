//
//  LGMyActivityController.m
//  ifaxian
//
//  Created by ming on 16/11/21.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGOtherController.h"
#import "LGOtherArrow.h"
#import "LGOther.h"
#import "LGOtherNone.h"
#import "LGFeedbackController.h"
#import "LGContributeController.h"
#import "LGOtherCell.h"
#import "LGContributeViewContorller.h"
#import "LGAboutMeController.h"
@interface LGOtherController ()
@property(nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation LGOtherController
static NSString * otherCellID = @"otherCellID";
- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
}

- (void)setupTableView{
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LGOtherCell class]) bundle:nil] forCellReuseIdentifier:otherCellID];
    self.tableView.rowHeight = 52;
    self.tableView.backgroundColor = LGCommonColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setGroup1];
    [self setGroup2];
    [self setupFootView];
    
   
    
    
}

- (void)setupFootView{

   // Log_out_icon
    UIButton *logoutButton = [[UIButton alloc] init];
    //[logoutButton setBackgroundImage:[UIImage imageNamed:@"Log_out_icon"] forState:UIControlStateNormal];
    [logoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [logoutButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [logoutButton setBackgroundColor:[UIColor whiteColor]];
    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor = LGCommonColor;
    
    logoutButton.frame = CGRectMake(0, LGCommonMargin, self.view.lg_width - 2 * LGCommonSmallMargin, 50);
    [footView addSubview:logoutButton];
    footView.frame = CGRectMake(LGCommonSmallMargin, 0, 200, 50);
  
    self.tableView.tableFooterView = footView;
    [logoutButton addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    
}

//发送通知退出登录
- (void)logout{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LGUserLogoutNotification object:self];
    
}

- (void)setGroup1{
   
    NSArray *group = [[NSArray alloc] init];
    LGOtherArrow *item1 = [LGOtherArrow otherImageName:@"反馈" title:@"意见反馈"];
    item1.className = [LGFeedbackController class];
    LGOtherArrow *item2 = [LGOtherArrow otherImageName:@"投稿" title:@"向我们投稿"]
    ;
     item2.className = [LGContributeController class];
    
    group = @[item1,item2];
    
    [self.dataArray addObject:group];
}
- (void)setGroup2{
     NSArray *group = [[NSArray alloc] init];
    LGOtherNone *item1 = [LGOtherNone otherImageName:@"版本" title:@"当前版本"];
   
    LGOtherArrow *item2 = [LGOtherArrow otherImageName:@"关于" title:@"关于"];
    item2.className = [LGAboutMeController class];
    NSDictionary *infoDict = [NSBundle mainBundle].infoDictionary;
    item1.detailText = [NSString stringWithFormat:@"%.1f",[infoDict[@"CFBundleVersion"] doubleValue]];
    item1.block = ^(NSIndexPath *indexPatch){
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"当前版本为%@",[NSString stringWithFormat:@"%.1f",[infoDict[@"CFBundleVersion"] doubleValue]]]];
    };

    group = @[item1,item2];
    [self.dataArray addObject:group];
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
    LGOther *model = array[indexPath.row];
    LGOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:otherCellID];
    cell.model = model;
    return cell;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *array = self.dataArray[indexPath.section];
    LGOther *model = array[indexPath.row];
    
    if ([model isKindOfClass:[LGOtherArrow class]]) {
        LGOtherArrow *arrowModel = (LGOtherArrow *) model;
        Class clasName = arrowModel.className;
        
          UIViewController *vc;
        if (clasName == [LGContributeController class]) {
       
            LGContributeViewContorller *conVc = [[LGContributeViewContorller alloc] init];
             [self.navigationController pushViewController:conVc animated:YES];
            
        }else{
            vc = [[clasName alloc] init];
             [self.navigationController pushViewController:vc animated:YES];
        }
       
    }else{
          LGOtherNone *nowModel = (LGOtherNone *) model;
        if (nowModel.block) {
            nowModel.block(indexPath);
        }
        
        
    }
    
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return LGCommonMargin;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

@end
