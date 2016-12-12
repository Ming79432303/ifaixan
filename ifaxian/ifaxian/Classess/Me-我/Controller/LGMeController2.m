//
//  LGMeController.m
//  ifaxian
//
//  Created by ming on 16/11/17.
//  Copyright © 2016年 ming. All rights reserved.
//

#define alphHeight 150
#define topImageH 200
#define navBarBottom (LGstatusBarH + LGnavBarH)

#import "LGMeController2.h"
#import "LGVisitorView.h"
#import "UIImage+AlphaImage.h"
#import "LGMyProfileViewController.h"
#import "LGSetingController.h"
@interface LGMeController2 ()
@property(nonatomic,assign) BOOL isLogin;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, weak) UIImageView *bacView;
@property (nonatomic, weak) UIImageView *iconView;
@property (nonatomic, weak) UIImageView *picView;
@property (nonatomic, weak) UIButton *popView;
@property (assign ,nonatomic) CGFloat initOffSetY;
@property(nonatomic, weak) UILabel *titleLabel;
@property(nonatomic, weak) UIScrollView *contenView;
@property(nonatomic, strong) UIBarButtonItem *leftButton;
@property(nonatomic, weak) UIImageView *iconImageView;
@property(nonatomic, weak) UILabel *nameLable;
@property(nonatomic, weak) UIView *titleView;
@property(nonatomic,assign) BOOL isCalculate;


@end
@implementation LGMeController2



- (UIBarButtonItem *)leftButton{
    if (_leftButton == nil) {
        _leftButton = [UIBarButtonItem lg_barButtonCustButton:@"" fontSize:14 addTarget:self action:@selector(contentInset) isBack:YES];
    }
    
    return _leftButton;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.isCalculate = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginSuccess) name:LGUserLoginSuccessNotification object:nil];
#warning 切换登录界面和访客视图
    [LGNetWorkingManager manager].isLogin ?[self setupTableViews] :[self setupVisitorView];
    
}

- (void)userLoginSuccess{
    
    self.view = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



- (void)setupTableViews{
    
    [super setupTableView];
    
    [self setupNav];
    
    //设置背景图片
    self.tableView.contentInset = UIEdgeInsetsMake(0.35 * [UIScreen lg_screenHeight], 0, 0, 0);
    [self setupBacImageView];
    self.tableView.contentOffset = CGPointMake(0, -0.35 * [UIScreen lg_screenHeight]);
    self.tableView.scrollEnabled = YES;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.initOffSetY =  -0.35 * [UIScreen lg_screenHeight];
    
    
    UIStoryboard *storb = [UIStoryboard storyboardWithName:@"LGMyProfileViewController" bundle:nil];
    
    LGMyProfileViewController * profileView = [storb instantiateInitialViewController];
    [self addChildViewController:profileView];
    profileView.view.frame = self.view.frame;
    
    
    
    self.contenView = profileView.contentView;
    self.titleView = profileView.titleView;
    [self.tableView addSubview:profileView.view];
    
}



- (void)setupNav{
    
    //去除线
    [self.navBar setShadowImage:[[UIImage alloc] init]];
    //添加文字
    UILabel *titleLable = [[UILabel alloc] init];
    titleLable.text = [LGNetWorkingManager manager].account.user.nickname;
    [titleLable sizeToFit];
    self.navItem.titleView = titleLable;
    self.titleLabel = titleLable;
    self.navItem.rightBarButtonItem = [UIBarButtonItem lg_barButtonCustButton:@"设置" fontSize:14 addTarget:self action:@selector(seting) isBack:NO];
    
    
}
- (void)seting{
    LGSetingController *setVc = [[LGSetingController alloc] init];
    
    
    [self.navigationController pushViewController:setVc animated:YES];
    
    
    
}
- (void)contentInset{
    
    self.navItem.leftBarButtonItem = nil;
    self.tableView.contentInset = UIEdgeInsetsMake(0.35 * [UIScreen lg_screenHeight], 0, LGTitleViewHeight + navBarBottom, 0);
    [self.tableView setContentOffset:CGPointMake(0, -0.35 * [UIScreen lg_screenHeight]) animated:YES];
    
    //关闭交互功能
    self.tableView.scrollEnabled = YES;
    LGuserInteractionEnabled = NO;
    for (UIView *view in self.contenView.subviews) {
        
        for (UIView *subView in view.subviews) {
            if ([subView isKindOfClass:[UIScrollView class]]) {
                UITableView *tableView = (UITableView *)subView;
                tableView.scrollEnabled = NO;
                [tableView  setContentOffset:CGPointMake(0, 0)];
                
                
            }
            
        }
       
        
        
    }
    
    
    
}

- (void)setupRefreshView{
    return;
}
- (void)setupBacImageView{
    //headerView
    UIView *headView = [[UIView alloc] init];
    CGSize screen = [UIScreen mainScreen].bounds.size;
    headView.backgroundColor = [UIColor whiteColor];
    headView.frame = CGRectMake(0, 0, screen.width, 0.35*screen.height);
    //背景
    UIImageView *imageView = [[UIImageView alloc] init];
    
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    imageView.image = [UIImage imageNamed:@"screen"];
    imageView.frame = headView.frame;
    [headView addSubview:imageView];
    self.bacView = imageView;
    self.tableView.backgroundView = headView;
    //添加头像
    
    UIImageView *iconImageV = [[UIImageView alloc] init];
    iconImageV.backgroundColor = [UIColor redColor];
    iconImageV.image = [UIImage imageNamed:@"Screenshot_2016-11-22-13-35-51-390_微信"];
    iconImageV.layer.cornerRadius = 64/2;
    iconImageV.layer.masksToBounds = YES;
    [imageView addSubview:iconImageV];
    [iconImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(64, 64));
        make.centerX.mas_equalTo(imageView.mas_centerX);
        make.bottom.mas_equalTo(imageView.mas_bottom).offset(-80);
        
        
    }];
    //添加lable
    
    UILabel *nameLable = [[UILabel alloc] init];
    nameLable.textAlignment = NSTextAlignmentCenter;
    nameLable.text = @"夕阳无限好只是欠黄昏";
    nameLable.font = [UIFont boldSystemFontOfSize:14];
    nameLable.textColor = [UIColor whiteColor];
    [imageView addSubview:nameLable];
    [nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(headView.lg_width, 20));
        make.centerX.mas_equalTo(iconImageV.mas_centerX);
        make.top.mas_equalTo(iconImageV.mas_bottom).offset(20);
        
        
    }];
    self.iconImageView = iconImageV;
    self.nameLable = nameLable;
    
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offset =  scrollView.contentOffset.y;
    
    
    CGRect bacViewX= self.bacView.frame;
    if (offset<0) {
        
        bacViewX.size.height = self.iconView.center.y;
        
        bacViewX.size.height -=offset;
        bacViewX.origin.y = 0;
        self.bacView.frame = bacViewX;
        
        
    }else{
        
        bacViewX.origin.y =-offset* 0.5;
        
        if (-bacViewX.origin.y  >self.iconView.bounds.size.height/2) {
            bacViewX.origin.y =self.iconView.bounds.size.height/2;
            bacViewX.origin.y -= offset;
        }
        self.bacView.frame = bacViewX;
        
    }
    
    //设置渐变透明度
    
    CGFloat dali = offset - self.initOffSetY;
    NSLog(@"apth=%f",dali);
    
    NSLog(@"--%f",scrollView.contentOffset.y);
    
    CGFloat alph = dali / alphHeight;
    
    if (self.isCalculate) {
        if ([self.titleView lg_intersectWithView:self.navBar]) {
 
            
            alph = 0.99;
            self.tableView.contentInset = UIEdgeInsetsMake(LGstatusBarH, 0, 0, 0);
            
            self.tableView.contentOffset = CGPointMake(0, -navBarBottom);
            self.tableView.scrollEnabled = NO;
            //开启交互功能
            LGuserInteractionEnabled = YES;
            self.navItem.leftBarButtonItem = self.leftButton;
            //添加按钮
            
            for (UIView *view in self.contenView.subviews) {
                
                for (UIView *subView in view.subviews) {
                    if ([subView isKindOfClass:[UIScrollView class]]) {
                        UITableView *tableView = (UITableView *)subView;
                        
                        tableView.scrollEnabled = YES;
                        self.tableView.contentOffset = CGPointMake(0, -navBarBottom);
                        self.tableView.scrollEnabled = NO;
                        //开启交互功能
                        LGuserInteractionEnabled = YES;
                        self.navItem.leftBarButtonItem = self.leftButton;
                        
                        
                    }
                    
                }
                
            }
            

            
        }

    }
        
    if (alph>=1) {
        alph = 0.99;
        self.tableView.contentInset = UIEdgeInsetsMake(LGstatusBarH, 0, 0, 0);
        }

    //让navigationBar导航条变透明
    [self.navBar setBackgroundImage:[UIImage imageWithAlpha:alph]  forBarMetrics:UIBarMetricsDefault];
    self.titleLabel.textColor = [UIColor colorWithWhite:0 alpha:alph];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 20;
}
-  (void)setupVisitorView{
    
    [self.view addSubview:[LGVisitorView viewFromeNib]];
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
