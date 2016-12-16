//
//  LGUserInfoController.m
//  ifaxian
//
//  Created by ming on 16/12/15.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGUserInfoController.h"
#import "LGUserItem.h"
#import "LGUserList.h"
#import "LGUserInfoCell.h"
#import "LGUserHeaderFooterView.h"
@interface LGUserInfoController ()
@property(nonatomic, strong) NSArray *userList;
@property(nonatomic, strong) LGUserList *userItem;
@end

@implementation LGUserInfoController
static NSString *userCellID = @"userCellID";
static NSString *userHFViewID = @"userHFViewID";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navItem.title = @"用户详情";
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LGUserInfoCell class])  bundle:nil] forCellReuseIdentifier:userCellID];
    [self.tableView registerClass:[LGUserHeaderFooterView class] forHeaderFooterViewReuseIdentifier:userHFViewID];
    [self loadData];

    
}
- (void)setupRefreshView{
    
    
}
- (void)loadData{
    
    
    [[LGHTTPSessionManager manager] requestUsercompletion:^(BOOL isSuccess, NSDictionary * responseObject) {
        if (isSuccess) {
            
            NSString *userInfo = @"userinfo.plist";
            NSString *filePath = [userInfo lg_appendDocumentDir];
            [responseObject writeToFile:filePath atomically:YES];
            
            [self configeList:responseObject];
            
            [self.tableView reloadData];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:LGUserupdataImageNotification object:self userInfo:@{@"filePath":filePath}];
#warning //写入到磁盘
            
        }else{
            [SVProgressHUD showErrorWithStatus:@"获取信息失败"];
            
        }
        
    }];
}
- (void)configeList:(NSDictionary *)responseObject{
    //个人信息
    
    //**** 第一组 ***//
    
    NSArray *user_info = @[@"basic_user_avatar",@"bac",@"nickname",@"wp_capabilities",@"city",@"website",@"signature"];
    NSArray *user_infoTitle = @[@"头像",@"背景图",@"昵称",@"用户身份",@"居住地",@"站点",@"个人说明"];
    NSArray *groupUserInfo = [self userinfo:responseObject userinfoKeys:user_info userTitle:user_infoTitle];
    LGUserItem *item1 = [LGUserItem userGruopTitle:@"个人基本信息" userInfo:groupUserInfo];
    //**** 第二组 ***//
    NSArray *user_contact = @[@"user_email",@"user_phone_number"];
    //对应标题
    NSArray *user_contactTitle = @[@"邮箱",@"电话号码"];
    NSArray *groupUserContact = [self userinfo:responseObject userinfoKeys:user_contact userTitle:user_contactTitle];
    LGUserItem *item2 = [LGUserItem userGruopTitle:@"联系方式" userInfo:groupUserContact];
    //组合标题
    NSArray *userList = @[item1,item2];
    self.userList = userList;
}


- (NSArray *)userinfo:(NSDictionary *)userinfo userinfoKeys:(NSArray *)userKeys userTitle:(NSArray *)userTitle{
    
    NSMutableArray *arrayM = [NSMutableArray array];
    int index = 0;
    for (NSString *key in userKeys) {
        NSString *content = userinfo[key];
        NSString *title = userTitle[index];
        LGUserList *list = [LGUserList userTitle:title content:content parameter:key];
        [arrayM addObject:list];
        index += 1;
        
    }
    return arrayM;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.userList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    LGUserItem *item = self.userList[section];
    
    return item.userInfos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    LGUserItem *item = self.userList[indexPath.section];
    LGUserList *model = item.userInfos[indexPath.row];
    
    LGUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:userCellID];
    
    [cell setModle:model section:indexPath.section];
    
    return cell;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return  0.1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 4 *  LGCommonMargin;
}
//更改组标题
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    LGUserItem *item = self.userList[section];
    LGUserHeaderFooterView *hfView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:userHFViewID];

    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(LGCommonSmallMargin,  LGCommonMargin, self.tableView.lg_width - 2 * LGCommonSmallMargin, 40 -1);
    view.backgroundColor = [UIColor whiteColor];
    UILabel *titleLable = [[UILabel alloc] init];
    titleLable.backgroundColor = [UIColor whiteColor];
    titleLable.font = [UIFont systemFontOfSize:13];
    titleLable.textColor = [UIColor lightGrayColor];
    titleLable.frame = CGRectMake(2 * LGCommonMargin,  0, view.lg_width/2, view.lg_height);
    titleLable.text = item.title;
    [view addSubview:titleLable];
    [hfView addSubview:view];
    return hfView;
    
}


@end
