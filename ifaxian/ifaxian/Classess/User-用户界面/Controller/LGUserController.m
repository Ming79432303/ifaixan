//
//  ViewController.m
//  06-微博个人详情页
//
//  Created by xiaomage on 15/9/7.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "LGUserController.h"
#import "UIImage+AlphaImage.h"
#import "UIImage+ImageEffects.h"
#import "UIImageView+LBBlurredImage.h"
#import "LGUserListController.h"
#import "LGUserInfoController.h"

#define LGHeadViewH 244

#define LGHeadViewMinH 64

#define LGTabBarH 44

@interface LGUserController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *tabView;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property (nonatomic, assign) CGFloat oriOffsetY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headTopCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headHeightCons;
@property (weak, nonatomic) IBOutlet UIImageView *userIconImageView;

@property (nonatomic, weak) UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *userBacImageView;
@property(nonatomic, strong) UINavigationBar *navBar;
@property(nonatomic, strong)  UINavigationItem *navItem;
@property(nonatomic, weak)  UITableView  *userTableView;
@property (weak, nonatomic) IBOutlet UILabel *nickname;
@property(nonatomic, copy) NSString *titleText;
@end

@implementation LGUserController

- (UINavigationBar *)navBar{
    if (_navBar == nil) {
        _navBar = [[UINavigationBar alloc] init];
        
    }
    
    return _navBar;
}
- (UINavigationItem *)navItem{
    
    if (_navItem == nil) {
        _navItem = [[UINavigationItem alloc] init];
    }
    
    return _navItem;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    [self setHeaderView];
    [self setupTableView];
    [self loadUserInfo];

}
- (void)loadUserInfo{
    
    [[LGHTTPSessionManager manager] requestUserIfo:self.author.slug completion:^(BOOL isSuccess, id responseObject) {
        NSInteger count = [responseObject[@"pages"] integerValue];
        NSString *titleText;
        if (count <= 0) {
            titleText = @"暂无发表的动态";
        }else{
            
           titleText = [NSString stringWithFormat:@"共发表了%@条动态", responseObject[@"pages"]];
        }
        self.titleLable.text = titleText;
        self.titleText = titleText;
    }];
    
    
}
-(void)setHeaderView{
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfo)];
    
    [_userIconImageView addGestureRecognizer:tap];
    
    self.userBacImageView.image = [[UIImage imageNamed:@"screen"] applyTintEffectWithColor:[UIColor lightGrayColor]];
    _userIconImageView.layer.cornerRadius = _userIconImageView.lg_height / 2;
    _userIconImageView.layer.masksToBounds = YES;
//    _tabView.image = [[UIImage imageNamed:@"1111111"] applyDarkEffect];
    
    _nickname.text = [NSString stringWithFormat:@"昵称:%@",_author.nickname];
    
}

- (void)setupTableView{
    // 设置tableView数据源和代理
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // 设置导航条
    [self setUpNavigationBar];
    [self setupNavBar];
    // 不需要添加额外的滚动区域
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 先记录最开始偏移量
    _oriOffsetY = -(LGHeadViewH + LGTabBarH);

    LGUserListController *userList = [[LGUserListController alloc] init];
    userList.userName = _author.slug;
    userList.view.frame = self.view.frame;
    userList.tableView.contentInset = UIEdgeInsetsMake(LGHeadViewH + LGTabBarH, 0, 0, 0);
    userList.tableView.lg_y = -LGnavBarH + LGstatusBarH;
    userList.tableView.lg_height -= -LGnavBarH + LGstatusBarH;
    
    //UIImage *bacImage = [[UIImage imageNamed:@"screen"] applyDarkEffect];
    
    //userList.tableView.backgroundView = [[UIImageView alloc] initWithImage:bacImage];
    
    [userList.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [self addChildViewController:userList];
    [self.view insertSubview:userList.tableView atIndex:0];
    _userTableView = userList.tableView;
    NSString * userAvatar = [_author.slug lg_getuserAvatar];

    [_userIconImageView lg_setCircularImageWithurl:userAvatar placeholderImage:[UIImage imageNamed:@"default_Avatar"]];
    
}


- (void)userInfo{
    return;
//    LGUserInfoController *userVc = [[LGUserInfoController alloc] init];
//    
//    
//    [self.navigationController pushViewController:userVc animated:YES];
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(UIScrollView *)scrollView change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    // 计算下tableView滚动了多少
    
    // 偏移量:tableView内容与可视范围的差值
    
    // 获取当前偏移量y值
    CGFloat curOffsetY = scrollView.contentOffset.y;
    
    // 计算偏移量的差值 == tableView滚动了多少
    // 获取当前滚动偏移量 - 最开始的偏移量(-244)
    CGFloat delta = curOffsetY - _oriOffsetY;
    
    // 计算下头部视图的高度
    CGFloat h = LGHeadViewH - delta;
    if (h < LGHeadViewMinH ) {
        h = LGHeadViewMinH;
        _titleLable.text = _author.nickname;
    }else{
        
        _titleLable.text = _titleText;
    }
    if (h > LGHeadViewH) {
        h = LGHeadViewH;
    }
    
    // 修改头部视图高度,有视觉差效果
    _headHeightCons.constant = h;
    
    // 处理导航条业务逻辑
    
    // 计算透明度
    CGFloat alpha = delta / (LGHeadViewH - LGHeadViewMinH);
    
    if (alpha > 1) {
        alpha = 0.99;
        return;
    }
    if (alpha < 0) {
        alpha = 0;
    }
    // 设置导航条背景图片
    // 根据当前alpha值生成图片
    UIImage *image = [UIImage imageWithAlpha:alpha];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    // 设置导航条标题颜色
    _label.textColor = [UIColor colorWithWhite:0 alpha:alpha];
    
    
}


- (void)setupNavBar{
    
    self.navigationController.navigationBar.hidden = YES;
    
    self.navBar.frame = self.navigationController.navigationBar.bounds;
    self.navBar.lg_height += 20;
    self.navBar.items = @[self.navItem];
    self.navBar.barTintColor = [UIColor lg_colorWithHex:0xF6F6F6];
    self.navBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor lg_colorWithRed:37 green:37 blue:37]};
    
    [self.view addSubview:self.navBar];
    [self.navBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    // 清空导航条的阴影的线
    [self.navBar setShadowImage:[[UIImage alloc] init]];
    self.navItem.leftBarButtonItem = [UIBarButtonItem lg_barButtonCustButton:@"" fontSize:14 addTarget:self action:@selector(back) isBack:YES];
    
}

- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
// 滚动tableView的时候就会调用
// 设置导航条
- (void)setUpNavigationBar
{
    // 设置导航条背景为透明
    // UIBarMetricsDefault只有设置这种模式,才能设置导航条背景图片
    // 传递一个空的UIImage
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    // 清空导航条的阴影的线
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    // 设置导航条标题为透明
    UILabel *label = [[UILabel alloc] init];

    
    _label = label;
    
    // 设置文字的颜色
    label.textColor = [UIColor colorWithWhite:1 alpha:0];
    
    // 尺寸自适应:会自动计算文字大小
    [label sizeToFit];
    
    [self.navigationItem setTitleView:label];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = [UIColor redColor];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    
    
    return cell;
}

- (void)dealloc{
    
    [_userTableView removeObserver:self forKeyPath:@"contentOffset"];
}
@end
