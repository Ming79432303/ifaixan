//
//  LGMecontroller.m
//  个人中心
//
//  Created by ming on 16/12/11.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGMecontroller.h"
#import "LGVisitorView.h"
#import "UIImage+AlphaImage.h"
#import "LGSetingController.h"
#import "LGMyArticleController.h"
#import "LGOtherController.h"
#import "LGPersonalInformationController.h"
#import "LGAliYunOssUpload.h"
#import "LGVisitorView.h"
#import "UIImage+lg_image.h"

#define alphHeight 115
@interface LGMecontroller ()<UITableViewDelegate,UIScrollViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *converView;
@property (weak, nonatomic) IBOutlet UIView *tipView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *converViewHeight;

@property (weak, nonatomic) IBOutlet UIScrollView *vcView;
@property(nonatomic, weak)  UIView *lineView;
@property(nonatomic, weak)  UIButton *lastButton;
@property(nonatomic, strong)  UITableViewController *lasttabVc;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, weak) UIImageView *bacView;
@property(nonatomic, weak) UIImageView *iconView;
@property(nonatomic, weak) UIImageView *picView;
@property(nonatomic, weak) UIButton *popView;
@property(nonatomic, assign) CGFloat initOffSetY;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, weak) UIScrollView *contenView;
@property(nonatomic, strong) UIBarButtonItem *leftButton;
@property(nonatomic, strong) UIImageView *iconImageView;
@property(nonatomic, strong) UILabel *nameLable;
@property(nonatomic, weak) UIView *titleView;
@property(nonatomic, strong) UIImageView *titleImageView;
@property(nonatomic, strong) UINavigationBar *navBar;
@property(nonatomic, strong)  UINavigationItem *navItem;
@property(nonatomic, strong)  NSString *path;
@end

@implementation LGMecontroller

#pragma mark - 懒加载
//自定义导航栏
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

//个人说明
- (UILabel *)nameLable{
    if (_nameLable == nil) {
        _nameLable = [[UILabel alloc] init];
    }
    
    return _nameLable;
}
//用户的昵称
- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
    }
    
    return _titleLabel;
}

//用户头像
- (UIImageView *)iconImageView{
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] init];
    }
    
    return _iconImageView;
    
}
//显示用户小头像
- (UIImageView *)titleImageView{
    if (_titleImageView == nil) {
        _titleImageView = [[UIImageView alloc] init];
       
    }
    return _titleImageView;
}

- (void)viewDidLoad {
   
    [super viewDidLoad];
    [self notification];
    [self setupNavBar];
    [self setupBacImageView];
    self.view.frame = [UIScreen mainScreen].bounds;
    //判断是否显示哪个界面
    [LGNetWorkingManager manager].isLogin ? [self addConView]:[self addvisitorView];
    [self setupConfigVcView];
}

#pragma mark - 接收通知
- (void)notification{
    //接收通知更新用户数据通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserImage:) name:LGUserupdataImageNotification object:nil];
    //接收用户登录成功数据通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginOrLogout) name:LGUserLoginSuccessNotification object:nil];
    //接收用户退出成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginOrLogout) name:LGUserLogoutSuccessNotification object:nil];
    
}
#pragma mark - 用户登录和登出方法
- (void)userLoginOrLogout{
     [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.vcView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.childViewControllers makeObjectsPerformSelector:@selector(removeFromParentViewController)];
    [self.tipView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.nameLable.text = nil;
   
    [self viewDidLoad];
    
}
#pragma mark - 添加访客视图
- (void)addvisitorView{
    
    UIView *visitorView = [LGVisitorView viewFromeNib];
    visitorView.frame = self.vcView.frame;

    
    [self.vcView addSubview:visitorView];
}
#pragma mark - 更新用户数据
- (void)updateUserImage:(NSNotification *)noti{
    
    NSString *filePath = noti.userInfo[@"filePath"];
  NSDictionary *userInfo = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    NSString *singleText = userInfo[@"signature"];
    NSString *avUrl = userInfo[@"signature"];
    NSString *bcUrl = userInfo[@"bac"];
    if (!avUrl.length) {
        self.iconImageView.image = [UIImage imageNamed:@"default_Avatar"];
        
    }
    
    if (!bcUrl.length) {
        self.iconImageView.image = [UIImage imageNamed:@"default_user_bac"];
    }
    if ([LGNetWorkingManager manager].account.isOtherLogin) {
        
        [self.iconImageView setHeader:[LGNetWorkingManager manager].account.user.userAvatar];
        return;
    }
    LGWeakSelf;
    self.nameLable.text = singleText.length ? singleText:@"尚未设置个人说明";
           dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSString *urlstr = [NSString stringWithFormat:@"%@ifaxian/avatars/%@lg_user_avatar.jpg",LGbuckeUrl,[LGNetWorkingManager manager].account.user.username];
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlstr]];
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *image = [UIImage imageWithData:imageData];
                if (!image) {
                    weakSelf.iconImageView.image = [UIImage imageNamed:@"default_Avatar"];
                }else{
                    
                    weakSelf.iconImageView.image = [image lg_avatarImagesize:_iconImageView.bounds.size backColor:[UIColor whiteColor] lineColor:[UIColor whiteColor]];
                    weakSelf.titleImageView.image = weakSelf.iconImageView.image;
                }
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        NSString *urlstr = [NSString stringWithFormat:@"%@ifaxian/avatars/%@bac.jpg",LGbuckeUrl,[LGNetWorkingManager manager].account.user.username];
                        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlstr]];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIImage *image = [UIImage imageWithData:imageData];
                            if (!image) {
                                weakSelf.converView.image = [UIImage imageNamed:@"default_user_bac"];
                            }else{
                                
                                weakSelf.converView.image = image;
                            }

                            
                        });
                        
                    });
                
            });
            
        });


    
    
}
#pragma mark - 配置当前存放底部三个控制的scroview的初始化
- (void)setupConfigVcView{
    self.vcView.delegate = self;
    self.vcView.pagingEnabled = YES;
    self.vcView.bounces = NO;
    self.vcView.showsHorizontalScrollIndicator = NO;
    self.vcView.showsVerticalScrollIndicator = NO;
    self.vcView.contentSize = CGSizeMake(self.childViewControllers.count * self.view.frame.size.width , 0);

}
#pragma mark - setupNavBar设置显示文字，去出线等
- (void)setupNavBar{
    self.navigationController.navigationBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navBar.frame = self.navigationController.navigationBar.bounds;
    self.navBar.lg_height += 20;
    self.navBar.items = @[self.navItem];
    self.navBar.barTintColor = [UIColor lg_colorWithHex:0xF6F6F6];
    self.navBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor lg_colorWithRed:37 green:37 blue:37]};
    [self.navBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navBar setShadowImage:[[UIImage alloc] init]];

    [self.view addSubview:self.navBar];
    self.navItem.rightBarButtonItem = [UIBarButtonItem lg_itemWithImage:@"mine-setting-icon" highImage:@"mine-setting-icon" target:self action:@selector(seting)];
    self.titleLabel.text = [LGNetWorkingManager manager].isLogin ? [LGNetWorkingManager manager].account.user.nickname : @"请登录";
    self.titleImageView.lg_width = 35;
    self.titleImageView.lg_height = 35;
    self.titleImageView.image = self.iconImageView.image;
    self.titleImageView.layer.cornerRadius = 35/2;
    self.titleImageView.layer.masksToBounds = YES;
    self.titleImageView.hidden = YES;
    self.titleImageView.center = self.navBar.center;
    self.titleImageView.lg_centerY += LGCommonMargin;
    [self.navBar addSubview:self.titleImageView];
    [self.navBar setShadowImage:[[UIImage alloc] init]];
    
    
}
#pragma mark - 点击设置跳转设置界面方法
- (void)seting{
    LGSetingController *setVc = [[LGSetingController alloc] init];
    [self.navigationController pushViewController:setVc animated:YES];
    [self setupConfigVcView];
    
}
#pragma mark - 添加子控制器到vcView上
- (void)addConView{
    self.titleLabel.text = [LGNetWorkingManager manager].account.user.nickname;
    LGMyArticleController *article = [[LGMyArticleController alloc] init];
    article.userName = [LGNetWorkingManager manager].account.user.username;
    article.title = @"我发布的";
    [self addChildViewController:article];
    LGPersonalInformationController *profile = [[LGPersonalInformationController alloc] initWithStyle:UITableViewStyleGrouped];
    profile.title = @"信息";
    [self addChildViewController:profile];
    LGOtherController *other = [[LGOtherController alloc] initWithStyle:UITableViewStyleGrouped];
    other.title = @"其他";
    [self addChildViewController:other];

    
    [self.view layoutIfNeeded];
    
    for (int i = 0; i < 3; i ++) {
        UITableViewController *vc = self.childViewControllers[i];
        vc.view.frame = CGRectMake(i * self.view.frame.size.width, 0,  self.view.frame.size.width,  self.view.lg_height);
        vc.tableView.contentInset =  UIEdgeInsetsMake(LGBacImageViewHeight - LGstatusBarH + LGCommonMargin, 0, LGtabBarH, 0);
        [self.vcView addSubview:vc.view];
        
        
    }
    //添加完控制器之后添加显示标题的view
     [self addtipView];
    //第一次进来自动单击一次
     [self didClick:self.tipView.subviews.firstObject];
   
    
}

#pragma mark - 监听scroview得滚动
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(UITableView *)scrollView change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    //判断时候在背景图片这个高度范围内，只要在范围内就需要你更改控制器的insert
    if (scrollView.contentOffset.y > -LGBacImageViewHeight - LGstatusBarH && scrollView.contentOffset.y < -64) {
        CGFloat offSetY = scrollView.contentOffset.y + 100;
            //设置渐变透明度
        CGFloat alph = 1 + offSetY / alphHeight;
        //根据alph让导航栏变透明，让小头像显示
        if (alph>=1) {
            _iconImageView.hidden = YES;
            _nameLable.hidden = YES;
            _titleImageView.hidden = NO;
            alph = 0.99;
        }else{
            _iconImageView.hidden = NO;
            _nameLable.hidden = NO;
            _titleImageView.hidden = YES;
            
        }
    //让navigationBar导航条变透明
    
    [self.navBar setBackgroundImage:[UIImage imageWithAlpha:alph * 0.45]  forBarMetrics:UIBarMetricsDefault];
   
    
     self.converViewHeight.constant = -scrollView.contentOffset.y - LGCommonMargin + LGTipViewHeight;
        
    if (self.converViewHeight.constant >(LGBacImageViewHeight - LGstatusBarH)) {
        self.converViewHeight.constant = LGBacImageViewHeight;
        //遍历出所有子控制器更改Insets
        for (UIView *view in self.vcView.subviews) {
            if ([view isKindOfClass:[UIScrollView class]]) {
                UITableView *tabView = (UITableView *)view;
                tabView.contentInset = UIEdgeInsetsMake(LGBacImageViewHeight - LGstatusBarH, 0, LGtabBarH + 20, 0);
                if (tabView == scrollView) {
                    
                }else{
                    
                    tabView.contentOffset = scrollView.contentOffset;
                }
                
            }
        }
        return;
    }
    for (UIView *view in self.vcView.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            UITableView *tabView = (UITableView *)view;
            tabView.contentInset = UIEdgeInsetsMake(LGBacImageViewHeight - LGstatusBarH, 0, LGtabBarH, 0);
            if (tabView == scrollView) {
                
            }else{
                
                tabView.contentOffset = scrollView.contentOffset;
            }
            
        }
     }
        
    }
    //小于最小值
    if (-scrollView.contentOffset.y - LGCommonMargin < LGnavBarH) {
        
        self.converViewHeight.constant = LGnavBarH + LGTipViewHeight;
        return;
    }

    
}

#pragma mark - 控制器销毁方法移除Observer
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    for (UIButton *butn in self.tipView.subviews) {
        if (butn.selected == YES) {
            UITableViewController *tabVc = self.childViewControllers[butn.tag];
            [tabVc.tableView removeObserver:self forKeyPath:@"contentOffset"];
        }
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 布局显示用户中心的背景和头像，个人说明
- (void)setupBacImageView{
    //headerView
    //背景图片
    self.converView.image = [UIImage imageNamed:@"default_user_bac"];
    UIView *headView = [[UIView alloc] init];
    CGSize screen = [UIScreen mainScreen].bounds.size;
    headView.backgroundColor = [UIColor whiteColor];
    headView.frame = CGRectMake(0, 0, screen.width, 0.35*screen.height);
   //用户头像
    self.iconImageView.backgroundColor = [UIColor whiteColor];
    self.iconImageView.image = [UIImage imageNamed:@"default_Avatar"];
    self.iconImageView.layer.cornerRadius = 64/2;
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.userInteractionEnabled = YES;
    [self.converView addSubview:self.iconImageView];
    //用户头像约束
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(64, 64));
        make.centerX.mas_equalTo(self.converView.mas_centerX);
        make.bottom.mas_equalTo(self.converView.mas_bottom).offset(-110);
    }];
    //添加lable用于显示用户个人说明
    LGWeakSelf;
    self.nameLable.textAlignment = NSTextAlignmentCenter;
    self.nameLable.font = [UIFont boldSystemFontOfSize:14];
    self.nameLable.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    //用户显示用户昵称
    self.titleLabel.textColor = [UIColor whiteColor];
    [self.converView addSubview: self.nameLable];
    [self.converView addSubview: self.titleLabel];
    //添加约束
    [ self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(headView.lg_width, 20));
        make.centerX.mas_equalTo(weakSelf.iconImageView.mas_centerX);
        make.top.mas_equalTo(weakSelf.iconImageView.mas_bottom).offset(35);

    }];
     //添加约束
    [ self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(headView.lg_width, 20));
        make.centerX.mas_equalTo(weakSelf.iconImageView.mas_centerX);
        make.top.mas_equalTo(weakSelf.iconImageView.mas_bottom).offset(10);
        
    }];


    
    //添加手势
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setupConverImageView)];
//    [self.converView addGestureRecognizer:tap];
//    
//    UITapGestureRecognizer *avatarTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setupAvatarImageView)];
//    [self.iconImageView addGestureRecognizer:avatarTap];
    
}
//
//- (void)setupConverImageView{
//    
//    UIAlertController *alerView = [UIAlertController alertControllerWithTitle:@"更换背景图" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
//    
//    [alerView addAction: [UIAlertAction actionWithTitle:@"更换背景图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//      
//        [self picImageOnImageView:self.converView isAvatar:NO];
//        
//    }]];
//    [alerView addAction: [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//    }]];
//    
//    [self presentViewController:alerView animated:YES completion:nil];
//    
//   
//    
//    
//    
//}
//
//- (void)setupAvatarImageView{
//    
//    UIAlertController *alerView = [UIAlertController alertControllerWithTitle:@"更换头像" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
//    
//    [alerView addAction: [UIAlertAction actionWithTitle:@"更换头像" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//         [self picImageOnImageView:self.converView isAvatar:YES];
//        
//    }]];
//    [alerView addAction: [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//    }]];
//    
//    [self presentViewController:alerView animated:YES completion:nil];
//    
//    
//}
//
//- (void)picImageOnImageView:(UIImageView *)imageView isAvatar:(BOOL)isAvatar{
//    
//    
//    UIImagePickerController *picImage = [[UIImagePickerController alloc] init];
//    _path = isAvatar == YES ? @"image":@"bacImage";
//    picImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    picImage.delegate = self;
//    picImage.mediaTypes = [NSArray arrayWithObject:@"public.image"];
//    picImage.allowsEditing = YES;
//    
//    [self presentViewController:picImage animated:YES completion:nil];
//    
//
//    
//}
//
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
//    
//    NSLog(@"%@",info);
//    //默认头像
//    UIImage *bacImage = info[UIImagePickerControllerEditedImage];
//    NSData *imageDate = UIImageJPEGRepresentation(bacImage, 1);
//    LGAliYunOssUpload *upload = [[LGAliYunOssUpload alloc] init];
//    NSString *fileName = [NSString stringWithFormat:@"%@/%@.jpg",_path,[LGNetWorkingManager manager].account.user.username];
//    upload.delegate = self;
//    [picker dismissViewControllerAnimated:YES completion:nil];
//    [upload uploadfileData:imageDate fileName:fileName bucketName:nil completion:^(BOOL isSuccess) {
//        if (isSuccess) {
//            
//            NSString *url = [NSString stringWithFormat:@"%@/%@/%@.jpg",LGbuckeUrl,_path,[LGNetWorkingManager manager].account.user.username];
//            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
//            UIImage *image = [UIImage imageWithData:data];
//            if ([_path isEqualToString:@"image"]) {
//                self.iconImageView.image = image;
//                //保存到磁盘
//                
//            }else{
//                self.converView.image = image;
//                //保存到磁盘
//            }
//        }
//    }];
//    
//    
//}
//
//- (void)aliyunOssUploa:(LGAliYunOssUpload *)upload Progress:(CGFloat)progress{
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//       
//    });
//    
//    
//}
#pragma mark - 添加显示控制器标题的view
- (void)addtipView{
    NSInteger count = self.childViewControllers.count;
    CGFloat butnW = self.tipView.lg_width/count;
    CGFloat butnH = self.tipView.lg_height;
    for (int i = 0; i < count; i ++) {
        UIButton *butn = [[UIButton alloc] init];
        butn.tag = i;
        [butn setTitle:self.childViewControllers[i].title forState:UIControlStateNormal];
        [butn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [butn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        butn.frame = CGRectMake(i * butnW, 0, butnW, butnH);
        butn.backgroundColor = [UIColor clearColor];
        
        [butn addTarget:self action:@selector(didClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.tipView addSubview:butn];
        
    }
    UIButton *butn = self.tipView.subviews.firstObject;
    UIView *lineView = [[UIView alloc] init];
    self.lineView = lineView;
    lineView.backgroundColor = [UIColor whiteColor];
    //这里有一个问题底部白色的指示view移动的位置有问题在这里需要更新下约束
    [butn layoutIfNeeded];
    lineView.frame = CGRectMake(0, butn.lg_bottom - 3, butn.titleLabel.lg_width, 2);
    lineView.lg_centerX = butn.center.x;
    [self.tipView addSubview:lineView];
    
}

#pragma mark - 按钮单击方法
- (void)didClick:(UIButton *)butn{
    
    _lastButton.selected = NO;
    butn.selected = YES;
    _lastButton = butn;
    //添加动画让白色的指示view移动到按钮的中间
    [UIView animateWithDuration:0.25 animations:^{
        self.lineView.lg_width = butn.titleLabel.lg_width;
        self.lineView.lg_centerX = butn.center.x;
        
    }];
    CGFloat offsetX = butn.tag * self.view.lg_width;
    CGPoint offset = self.vcView.contentOffset;
    offset.x = offsetX;
    [self.vcView setContentOffset:offset animated:YES];
    [_lasttabVc.tableView removeObserver:self forKeyPath:@"contentOffset"];
    UITableViewController *tabVc = self.childViewControllers[butn.tag];
    //移除上一监听的Observer
    [tabVc.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    _lasttabVc = tabVc;
}

#pragma mark - scrollview代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    
    if ([scrollView isKindOfClass:[UITableView class]]) {
        return;
    }
    NSInteger curPage = scrollView.contentOffset.x / self.view.lg_width;
    
    UIButton *butn = self.tipView.subviews[curPage];
    [self didClick:butn];
    
    
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    
    
    
}
@end
