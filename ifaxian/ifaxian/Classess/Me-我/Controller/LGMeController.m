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
#define alphHeight 115
@interface LGMecontroller ()<UITableViewDelegate,UIScrollViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,LGAliYunOssUploadDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *converView;
@property (weak, nonatomic) IBOutlet UIView *tipView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *converViewHeight;

@property (weak, nonatomic) IBOutlet UIScrollView *vcView;
@property(nonatomic, weak)  UIView *lineView;
@property(nonatomic, weak)  UIButton *lastButton;
@property(nonatomic, strong)  UITableViewController *lasttabVc;
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
@property(nonatomic, strong) UINavigationBar *navBar;
@property(nonatomic, strong)  UINavigationItem *navItem;
@property(nonatomic, strong)  NSString *path;
@end

@implementation LGMecontroller

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserImage:) name:LGUserupdataImageNotification object:nil];
    [self setupNavBar];
    [self setupBacImageView];
    self.view.frame = [UIScreen mainScreen].bounds;
    [self addConView];
    [self addtipView];
    [self setupConfigVcView];
    [self didClick:self.tipView.subviews.firstObject];
}

- (void)updateUserImage:(NSNotification *)noti{
    
    NSString *filePath = noti.userInfo[@"filePath"];
  NSDictionary *userInfo = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    
    [self.converView lg_setImageWithurl:userInfo[@"bac"] placeholderImage:nil];
    [self.iconImageView lg_setCircularImageWithurl:userInfo[@"basic_user_avatar"] placeholderImage:nil];
    self.nameLable.text = userInfo[@"signature"];
    
}

- (void)setupConfigVcView{
    self.vcView.delegate = self;
    self.vcView.pagingEnabled = YES;
    self.vcView.bounces = NO;
    self.vcView.showsHorizontalScrollIndicator = NO;
    self.vcView.showsVerticalScrollIndicator = NO;
    self.vcView.contentSize = CGSizeMake(self.childViewControllers.count * self.view.frame.size.width , 0);
    
}

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
    self.navItem.rightBarButtonItem = [UIBarButtonItem lg_itemWithImage:@"setting" highImage:@"" target:self action:@selector(seting)];
    
    
}

- (void)seting{
    LGSetingController *setVc = [[LGSetingController alloc] init];
    
    
    [self.navigationController pushViewController:setVc animated:YES];
    
    
    
}

- (void)addConView{
    LGMyArticleController *article = [[LGMyArticleController alloc] init];
    article.title = @"我发布的";
    [self addChildViewController:article];
   
    
    LGPersonalInformationController *profile = [[LGPersonalInformationController alloc] initWithStyle:UITableViewStyleGrouped];
    profile.title = @"信息";
    [self addChildViewController:profile];
    LGOtherController *other = [[LGOtherController alloc] initWithStyle:UITableViewStyleGrouped];
    other.title = @"其他";
    [self addChildViewController:other];


    UILabel *title = [[UILabel alloc] init];
    title.text = @"个人中心";
    //用颜色来设置文字透明
    title.textColor = [UIColor colorWithWhite:0 alpha:0];
    //自动根据文字设置尺寸
    [title sizeToFit];
    self.titleLabel = title;
    self.navItem.titleView = title;
    //让navigationBar导航条变透明
    //去除线
    [self.navBar setShadowImage:[[UIImage alloc] init]];

    
    
    [self.view layoutIfNeeded];
    
    for (int i = 0; i < 3; i ++) {
        
        UITableViewController *vc = self.childViewControllers[i];
        vc.view.frame = CGRectMake(i * self.view.frame.size.width, 0,  self.view.frame.size.width,  self.view.lg_height);
        
        [self.vcView addSubview:vc.view];
        
        
    }
    
    
    
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(UITableView *)scrollView change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    if (scrollView.contentOffset.y > -LGBacImageViewHeight - LGTipViewHeight - 100 && scrollView.contentOffset.y <0) {
        
        
        
        CGFloat offSetY = scrollView.contentOffset.y + 100;
            //设置渐变透明度
        CGFloat alph = 1 + offSetY / alphHeight;
        
        if (alph>=1) {
            alph = 0.99;
        }
    //让navigationBar导航条变透明
    [self.navBar setBackgroundImage:[UIImage imageWithAlpha:alph]  forBarMetrics:UIBarMetricsDefault];
    self.titleLabel.textColor = [UIColor colorWithWhite:0 alpha:alph];
    
   
    if (-scrollView.contentOffset.y - LGCommonMargin < LGnavBarH) {
        
        self.converViewHeight.constant = LGnavBarH;
        return;
    }
    self.converViewHeight.constant = -scrollView.contentOffset.y - LGCommonMargin;
        
    if (self.converViewHeight.constant >= LGBacImageViewHeight) {
        self.converViewHeight.constant = LGBacImageViewHeight;
        for (UIView *view in self.vcView.subviews) {
            if ([view isKindOfClass:[UIScrollView class]]) {
                UITableView *tabView = (UITableView *)view;
                tabView.contentInset = UIEdgeInsetsMake(LGBacImageViewHeight + LGTipViewHeight - LGstatusBarH, 0, LGtabBarH, 0);;
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
            tabView.contentInset = UIEdgeInsetsMake(LGBacImageViewHeight + LGTipViewHeight - LGstatusBarH, 0, LGtabBarH, 0);
            if (tabView == scrollView) {
                
            }else{
                
                tabView.contentOffset = scrollView.contentOffset;
            }
            
        }
     }
        
    }
        
}

- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    for (UIButton *butn in self.tipView.subviews) {
        if (butn.selected == YES) {
            UITableViewController *tabVc = self.childViewControllers[butn.tag];
            [tabVc.tableView removeObserver:self forKeyPath:@"contentOffset"];
        }
    }
    

}


- (void)setupBacImageView{
    //headerView
    UIView *headView = [[UIView alloc] init];
    CGSize screen = [UIScreen mainScreen].bounds.size;
    headView.backgroundColor = [UIColor whiteColor];
    headView.frame = CGRectMake(0, 0, screen.width, 0.35*screen.height);
    
    UIImageView *iconImageV = [[UIImageView alloc] init];
    iconImageV.backgroundColor = [UIColor redColor];
    iconImageV.image = [UIImage imageNamed:@"Screenshot_2016-11-22-13-35-51-390_微信"];
    iconImageV.layer.cornerRadius = 64/2;
    iconImageV.layer.masksToBounds = YES;
    iconImageV.userInteractionEnabled = YES;
    [self.converView addSubview:iconImageV];
    
    [iconImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(64, 64));
        make.centerX.mas_equalTo(self.converView.mas_centerX);
        make.bottom.mas_equalTo(self.converView.mas_bottom).offset(-50);
        
        
    }];
    //添加lable
    UILabel *nameLable = [[UILabel alloc] init];
    nameLable.textAlignment = NSTextAlignmentCenter;
    nameLable.text = @"夕阳无限好只是欠黄昏";
    nameLable.font = [UIFont boldSystemFontOfSize:14];
    nameLable.textColor = [UIColor whiteColor];
    [self.converView addSubview:nameLable];
    [nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(headView.lg_width, 20));
        make.centerX.mas_equalTo(iconImageV.mas_centerX);
        make.top.mas_equalTo(iconImageV.mas_bottom).offset(10);
        
        
    }];
    self.iconImageView = iconImageV;
    self.nameLable = nameLable;
    
    //添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setupConverImageView)];
    [self.converView addGestureRecognizer:tap];
    
    UITapGestureRecognizer *avatarTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setupAvatarImageView)];
    [iconImageV addGestureRecognizer:avatarTap];
    
}

- (void)setupConverImageView{
    LGLog(@"更换背景图");
    UIAlertController *alerView = [UIAlertController alertControllerWithTitle:@"更换背景图" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alerView addAction: [UIAlertAction actionWithTitle:@"更换背景图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
      
        [self picImageOnImageView:self.converView isAvatar:NO];
        
    }]];
    [alerView addAction: [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alerView animated:YES completion:nil];
    
   
    
    
    
}

- (void)setupAvatarImageView{
    
    UIAlertController *alerView = [UIAlertController alertControllerWithTitle:@"更换头像" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alerView addAction: [UIAlertAction actionWithTitle:@"更换头像" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
         [self picImageOnImageView:self.converView isAvatar:YES];
        
    }]];
    [alerView addAction: [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alerView animated:YES completion:nil];
    
    
}

- (void)picImageOnImageView:(UIImageView *)imageView isAvatar:(BOOL)isAvatar{
    
    
    UIImagePickerController *picImage = [[UIImagePickerController alloc] init];
    _path = isAvatar == YES ? @"image":@"bacImage";
    picImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picImage.delegate = self;
    picImage.mediaTypes = [NSArray arrayWithObject:@"public.image"];
    picImage.allowsEditing = YES;
    
    [self presentViewController:picImage animated:YES completion:nil];
    

    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    NSLog(@"%@",info);
    //默认头像
    UIImage *bacImage = info[UIImagePickerControllerEditedImage];
    NSData *imageDate = UIImageJPEGRepresentation(bacImage, 1);
    LGAliYunOssUpload *upload = [[LGAliYunOssUpload alloc] init];
    NSString *fileName = [NSString stringWithFormat:@"%@/%@.jpg",_path,[LGNetWorkingManager manager].account.user.username];
    upload.delegate = self;
    [picker dismissViewControllerAnimated:YES completion:nil];
    [upload uploadfileData:imageDate fileName:fileName bucketName:nil completion:^(BOOL isSuccess) {
        if (isSuccess) {
            
            NSString *url = [NSString stringWithFormat:@"%@/%@/%@.jpg",LGbuckeUrl,_path,[LGNetWorkingManager manager].account.user.username];
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            UIImage *image = [UIImage imageWithData:data];
            if ([_path isEqualToString:@"image"]) {
                self.iconImageView.image = image;
                //保存到磁盘
                
            }else{
                self.converView.image = image;
                //保存到磁盘
            }
        }
    }];
    
    
}

- (void)aliyunOssUploa:(LGAliYunOssUpload *)upload Progress:(CGFloat)progress{
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
    });
    
    
}

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
        butn.backgroundColor = [UIColor lg_colorWithRed:37 green:37 blue:37];
        [butn addTarget:self action:@selector(didClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.tipView addSubview:butn];
        
    }
    
    UIButton *butn = self.tipView.subviews.firstObject;
    
    UIView *lineView = [[UIView alloc] init];
    self.lineView = lineView;
    lineView.backgroundColor = [UIColor whiteColor];
    [butn layoutIfNeeded];
    lineView.frame = CGRectMake(0, butn.lg_bottom - 3, butn.titleLabel.lg_width, 2);
    lineView.lg_centerX = butn.center.x;
    [self.tipView addSubview:lineView];
    
}


- (void)didClick:(UIButton *)butn{
    
    _lastButton.selected = NO;
    butn.selected = YES;
    _lastButton = butn;
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
    [tabVc.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    _lasttabVc = tabVc;
}


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
