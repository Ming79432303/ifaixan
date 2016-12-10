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

typedef NS_ENUM(NSInteger , LGTypeCell) {
    LGCategoryCell,//展示分类的cell
    LGTagCell,//展示标签的cell
    LGOtherCell,//其他的cell
};

@interface LGDiscoverController ()<UITextFieldDelegate>
@property (weak, nonatomic) UITextField *searchTextField;
@property (weak, nonatomic) UIView *searchView;
@property (weak, nonatomic) LGSearchController *searchVc;
@property(nonatomic, strong) NSArray *tags;

@end

@implementation LGDiscoverController

static NSString  *showCellID = @"showCellID";
static NSString  *tagCellID = @"tagCellID";



- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange:) name:UITextFieldTextDidChangeNotification object:self.searchTextField];
    [self addHeaderView];
    [self addShowView];
    
    
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
    searchView.placeholder = @"搜索,用户名,标题";
    UIImageView *search = [[UIImageView alloc] init];
    search.image = [UIImage imageNamed:@"search"];
    search.frame = CGRectMake(0, 0, 20, 20);
    searchView.leftView = search;
    searchView.leftViewMode = UITextFieldViewModeAlways;
    
    self.navItem.titleView = searchView;
    LGWeakSelf;
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.navBar).offset(LGCommonMargin);
        make.right.mas_equalTo(weakSelf.navBar).offset(-5 * LGCommonMargin);
        make.top.mas_equalTo(weakSelf.navBar).offset(LGCommonSmallMargin + LGstatusBarH);
        make.bottom.mas_equalTo(weakSelf.navBar).offset(-LGCommonSmallMargin);
    }];
    
    //self.navItem.rightBarButtonItem = [UIBarButtonItem lg_barButtonCustButton:@"云标签" fontSize:14 addTarget:self action:@selector(tag) isBack:NO];
    self.navItem.rightBarButtonItem = [UIBarButtonItem lg_itemWithImage:@"更多" highImage:@"更多 (1)" target:search action:@selector(tag)];

    self.searchTextField = searchView;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
     [self addSearchView];
    self.navItem.rightBarButtonItem = [UIBarButtonItem lg_barButtonCustButton:@"取消" fontSize:14 addTarget:self action:@selector(canle) isBack:NO];
    
}
- (void)canle{
    
    [self.searchTextField resignFirstResponder];
     self.tabBarController.tabBar.hidden = NO;
    
    POPBasicAnimation *animati = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    
    animati.fromValue = @(1);
    animati.toValue = @(0);
    animati.duration = 0.25;
    animati.completionBlock = ^(POPAnimation *anim ,BOOL finish){
        
        [self.searchView removeFromSuperview];
    };
    
    [self.searchView pop_addAnimation:animati forKey:nil];
    self.navItem.rightBarButtonItem = [UIBarButtonItem lg_itemWithImage:@"更多" highImage:@"更多 (1)" target:self action:@selector(tag)];
    
    
    
    
}
- (void)addSearchView{
    
    self.tabBarController.tabBar.hidden = YES;
    LGSearchController *searchVc = [[LGSearchController alloc] init];
    _searchVc = searchVc;
    [self addChildViewController:searchVc];
   
    searchVc.view.backgroundColor = [UIColor whiteColor];
    searchVc.view.frame = self.tableView.frame;
    searchVc.view.lg_y = self.navBar.lg_bottom;
    searchVc.view.lg_height = self.view.lg_height - self.navBar.lg_height;
    
    [self.view addSubview:searchVc.view];
    self.searchView = searchVc.view;
    
    POPBasicAnimation *animati = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    
    animati.fromValue = @(0);
    animati.toValue = @(1);
    animati.duration = 0.25;
    
    [searchVc.view pop_addAnimation:animati forKey:nil];
    
    
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == LGCategoryCell) {
        return 1;
    }else if (section == LGTagCell){
        
        return 1;
    }else{
        
        return 20;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%zd",indexPath.section);
    if (indexPath.section == LGCategoryCell) {
    LGShowCell * cell = [tableView dequeueReusableCellWithIdentifier:showCellID];
         return cell;
    }else if (indexPath.section == LGTagCell){
      LGTagsCell  * cell = [tableView dequeueReusableCellWithIdentifier:tagCellID];
       
        cell.tags = self.tags;
         return cell;
    }else {
        static NSString *ID = @"otherCell";
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.textLabel.text = @"其他样式";
        return cell;
    }
   
   
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == LGCategoryCell) {
        return [UIScreen lg_screenWidth] * 0.7;
    }else if (indexPath.section == LGTagCell){
        return 275;
    }else{
        
        return 50;
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if (section == 1) {
        return @"云标签";
    }else{
        
        return @"";
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
         return 4 * LGCommonMargin;
    }else{
        
        return 0;
    }
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
