//
//  LGDiscoverController.m
//  ifaxian
//
//  Created by ming on 16/11/17.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGDiscoverController.h"
#import "LGTextField.h"
#import "LGSearchController.h"
#import "LGShowController.h"
#import "LGShowCell.h"
#import "LGTagsCell.h"
#import "LGDiscoverList.h"
#import "LGTag.h"
#import "LGDiscoverHeaderView.h"
#import "LGActivityCell.h"
#import "LGDIscoverHeaderFooterView.h"

typedef NS_ENUM(NSInteger , LGTypeCell) {
    LGCategoryCell,//展示分类的cell
    LGTagCell,//展示标签的cell
    LGActivitieCell,//其他的cell
};

@interface LGDiscoverController ()<UITextFieldDelegate>
@property (weak, nonatomic) UITextField *searchTextField;
@property (weak, nonatomic) UIView *searchView;
@property (strong, nonatomic) LGSearchController *searchVc;
@property(nonatomic, strong) NSArray *tags;
@property(nonatomic, strong) LGDiscoverList *list;
@property(nonatomic, strong) NSArray *activities;
@end

@implementation LGDiscoverController

static NSString  *showCellID = @"showCellID";
static NSString  *tagCellID = @"tagCellID";
static NSString  *activitieCellID = @"activitieCellID";
static NSString  *discoverHFID = @"discoverHFID";

- (LGDiscoverList *)list{
    
    if (_list == nil) {
        _list = [[LGDiscoverList alloc] init];
    }
    
    return _list;
}

- (LGSearchController *)searchVc{
    
    if (_searchVc == nil) {
        _searchVc = [[LGSearchController alloc] init];
    }
    
    return _searchVc;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange:) name:UITextFieldTextDidChangeNotification object:self.searchTextField];
    [self addHeaderView];
    [self addShowView];
    [self loadNewData];
    
    
}


- (void)addHeaderView{
    LGDiscoverHeaderView *headerView = [LGDiscoverHeaderView viewFromeNib];
    headerView.frame = CGRectMake(0, 0, 200, 200);
    
    self.tableView.tableHeaderView = headerView;
    
    
    
}
- (void)addShowView{
    LGDiscoverList *list = [[LGDiscoverList alloc] init];
    [list requestTags:^(NSArray *tags) {
        
        self.tags = tags;
        [self.tableView reloadData];
    }];
    [self.tableView registerClass:[LGShowCell class] forCellReuseIdentifier:showCellID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LGTagsCell class]) bundle:nil] forCellReuseIdentifier:tagCellID];
   
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LGActivityCell class]) bundle:nil] forCellReuseIdentifier:activitieCellID];
    [self.tableView registerClass:[LGDIscoverHeaderFooterView class] forHeaderFooterViewReuseIdentifier:discoverHFID];
    self.tableView.sectionFooterHeight = 50;
    self.tableView.sectionHeaderHeight = 40;
    self.tableView.backgroundColor = LGCommonColor;
    self.tableView.mj_footer.hidden = YES;
}

- (void)textChange:(NSNotification *)noti{
    NSString *serch = [self.searchTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
         _searchVc.search(serch);
}



- (void)setNav{
    
    [self.navBar setTintColor:[UIColor redColor]];
    [self.navBar setBarTintColor:[UIColor whiteColor]];
    
    LGTextField *searchView = [[LGTextField alloc] init];
    searchView.delegate = self;
    searchView.borderStyle = UITextBorderStyleRoundedRect;
    searchView.backgroundColor = [UIColor whiteColor];
    searchView.frame = CGRectMake(0, 0, 200, self.navBar.lg_height -  LGCommonMargin - LGstatusBarH);
    searchView.placeholder = @"请输入关键字搜索";
    UIImageView *search = [[UIImageView alloc] init];
    search.image = [UIImage imageNamed:@"search_icon"];
    search.frame = CGRectMake(0, 0, 20, 20);
    searchView.leftView = search;
    searchView.leftViewMode = UITextFieldViewModeAlways;
    
    self.navItem.titleView = searchView;
    LGWeakSelf;
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.navBar).offset(LGCommonMargin);
        make.right.mas_equalTo(weakSelf.navBar).offset(-LGCommonMargin);
        make.top.mas_equalTo(weakSelf.navBar).offset(LGCommonSmallMargin + LGstatusBarH);
        make.bottom.mas_equalTo(weakSelf.navBar).offset(-LGCommonSmallMargin);
    }];
    
    //self.navItem.rightBarButtonItem = [UIBarButtonItem lg_barButtonCustButton:@"云标签" fontSize:14 addTarget:self action:@selector(tag) isBack:NO];
    self.navItem.rightBarButtonItem = [UIBarButtonItem lg_barButtonCustButton:@"搜索" fontSize:14 addTarget:self action:@selector(textFieldDidBeginEditing:) isBack:NO];

    self.searchTextField = searchView;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
     [self addSearchView];
    self.navItem.rightBarButtonItem = [UIBarButtonItem lg_barButtonCustButton:@"取消" fontSize:14 addTarget:self action:@selector(canle) isBack:NO];
    
}
- (void)canle{
    
    [self.searchTextField resignFirstResponder];
    self.searchTextField.text = nil;
     self.tabBarController.tabBar.hidden = NO;
    
    POPBasicAnimation *animati = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    
    animati.fromValue = @(1);
    animati.toValue = @(0);
    animati.duration = 0.25;
    animati.completionBlock = ^(POPAnimation *anim ,BOOL finish){
        
        [self.searchView removeFromSuperview];
        [self.searchVc removeFromParentViewController];
    };
    
    [self.searchView pop_addAnimation:animati forKey:nil];
     self.navItem.rightBarButtonItem = [UIBarButtonItem lg_barButtonCustButton:@"搜索" fontSize:14 addTarget:self action:@selector(textFieldDidBeginEditing:) isBack:NO];
    
    
    
    
}
- (void)addSearchView{
    
    self.tabBarController.tabBar.hidden = YES;
 
 
    [self addChildViewController: self.searchVc];
   
     self.searchVc.view.backgroundColor = [UIColor whiteColor];
     self.searchVc.view.frame = self.tableView.frame;
     self.searchVc.view.lg_y = self.navBar.lg_bottom;
     self.searchVc.view.lg_height = self.view.lg_height - self.navBar.lg_height;
    
    [self.view addSubview: self.searchVc.view];
    self.searchView =  self.searchVc.view;
    
    POPBasicAnimation *animati = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    
    animati.fromValue = @(1);
    animati.toValue = @(1);
    animati.duration = 0.15;
    
    [ self.searchVc.view pop_addAnimation:animati forKey:nil];
    
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    
   
    return YES;
    
}
- (void)tag{
    
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.view endEditing:YES];
   
    
}

- (void)loadNewData{
    
    LGWeakSelf;
    [self.list getActivity_get_activities:^(BOOL isSuccess, NSArray *activities) {
    [self.tableView.mj_header endRefreshing];
        if (isSuccess) {
            
            weakSelf.activities = activities;
            [weakSelf.tableView reloadData];
        }
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == LGCategoryCell) {
        return 1;
    }else if (section == LGTagCell){
        return 1;
    }else{
        
        return self.activities.count;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == LGCategoryCell) {
    LGShowCell * cell = [tableView dequeueReusableCellWithIdentifier:showCellID];
         return cell;
    }else if (indexPath.section == LGTagCell){
      LGTagsCell  * cell = [tableView dequeueReusableCellWithIdentifier:tagCellID];
       
        cell.tags = self.tags;
         return cell;
    }else {
        LGActivitie *activiti = self.activities[indexPath.row];
        LGActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:activitieCellID];
        cell.model = activiti;
        return cell;
    }
   
   
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LGActivitie *activiti = self.activities[indexPath.row];
    if (indexPath.section == LGCategoryCell) {
        return [UIScreen lg_screenWidth] * 0.7 + LGCommonMargin;
    }else if (indexPath.section == LGTagCell){
        return 125;
    }else{
        
        return activiti.rowHeight;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UITableViewHeaderFooterView *hfView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:discoverHFID];
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0,  1, self.tableView.lg_width, 40 -2);
    view.backgroundColor = [UIColor whiteColor];
    UILabel *titleLable = [[UILabel alloc] init];
    titleLable.backgroundColor = [UIColor whiteColor];
    titleLable.font = [UIFont systemFontOfSize:13];
    titleLable.textColor = [UIColor lightGrayColor];
    titleLable.frame = CGRectMake(2 * LGCommonMargin,  0, view.lg_width/2, view.lg_height);
    if (section == LGCategoryCell) {
        titleLable.text = @"精选推荐";
    }else if(section == LGTagCell){
        titleLable.text = @"云标签";
    }else{
        
        titleLable.text = @"最新活动";
    }
    [view addSubview:titleLable];
    [hfView addSubview:view];
    return hfView;
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
