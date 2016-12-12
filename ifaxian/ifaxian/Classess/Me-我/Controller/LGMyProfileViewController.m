//
//  LGMyProfileViewController.m
//  ifaxian
//
//  Created by ming on 16/11/20.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGMyProfileViewController.h"
#import "LGMyProfileViewController.h"
#import "LGMyArticleController.h"
#import "LGMyActivityController.h"
#import "LGPersonalInformationController.h"
static CGFloat const lableW = 100;
static CGFloat const lableScale = 1.1;
#define  LGScreen  [UIScreen mainScreen].bounds.size.width
@interface LGMyProfileViewController ()<UIScrollViewDelegate>
@property(nonatomic, strong) NSMutableArray *dataArray;


@property(nonatomic, weak) UILabel *lasLable;
@end

@implementation LGMyProfileViewController

#pragma mark - load lazy
- (NSMutableArray *)dataArray{
    
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
        
    }
    
    
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    //取消系统添加多余的偏移量

    self.automaticallyAdjustsScrollViewInsets = NO;
    //添加所有子控制器
    [self setAllChileControllers];
    //添加表头题
    [self setTitleHeadView];
    //初始化UIScrollView
    [self setScrollVIew];
#warning ??
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(user) name:@"user" object:nil];
    
}

#pragma mark - 添加所有子控制器
- (void)setAllChileControllers{
    LGMyArticleController *article = [[LGMyArticleController alloc] init];
    article.title = @"我发布的";
    [self addChildViewController:article];
    LGMyActivityController *activity = [[LGMyActivityController alloc] init];
    activity.title = @"我的动态";
    [self addChildViewController:activity];

      LGPersonalInformationController *profile = [[LGPersonalInformationController alloc] init];
    profile.title = @"我的信息";
    [self addChildViewController:profile];

    
}
#pragma mark - 设置标题view内容
- (void)setTitleHeadView{
    
    NSInteger count = self.childViewControllers.count;
    
    
    CGFloat lableY = 0;
    
    CGFloat lableH = 30;
    
    CGFloat lableX = ([UIScreen lg_screenWidth] - count * lableW) /2;
   
    
    for (int i = 0; i < count; i++) {
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(lableX + lableW * i, lableY, lableW, lableH)];
        [self.dataArray addObject:lable];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.tag = i;
        UIViewController *vc = self.childViewControllers[i];
        
        lable.highlightedTextColor = [UIColor whiteColor];
        lable.textColor = [UIColor lightGrayColor];
        lable.backgroundColor = [UIColor redColor];
        lable.text = vc.title;
        //添加单击手势事件
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selecedLable:)];
        //开启用户交互
        lable.userInteractionEnabled = YES;
        //添加手势事件
        [lable addGestureRecognizer:tap];
        if (i==0) {
            [self selecedLable:tap];
        }
        
        [self.titleView addSubview:lable];
    }
    
    
}

- (void)addtipView{
    
    UIView *tipView = [[UIView alloc] init];

    
    
}

#pragma mark - 单击手势事件
- (void)selecedLable:(UITapGestureRecognizer *)tap{
    //单击之后要做的事情
    //1,让lable选中变为红色
    //2,添加控制器，到当前对应的按钮
    
    UILabel *lable = (UILabel *)tap.view;
    //3
    //选中lable和取消上一次的选中
    [self selectedWithcancelSeleced:lable];
    //4
    //在当前的偏移量上添加控制器的View
    NSInteger index = lable.tag;
    [self addChileView:index];
    //5
    //单击上边的按钮之后让其居中显示
    //获取居中偏移量,让当前lable中心点的x 减去屏幕宽度的一般即可得出当前按钮居中所需要的偏移量
    [self setLableCenter:lable];
}


#pragma mark - 选中lable和取消上一次的选中
- (void) selectedWithcancelSeleced:(UILabel *)lable{
    //取消上一次按钮单击三部曲
    _lasLable.highlighted = NO;
    //恢复按钮颜色
    _lasLable.textColor = [UIColor lightGrayColor];
    //恢复上一次按钮的大小
    _lasLable.transform = CGAffineTransformIdentity;
    //设置选中的大小
    lable.transform = CGAffineTransformMakeScale(lableScale, lableScale);
    lable.highlighted = YES;
    
    _lasLable = lable;
}

#pragma mark - 单击按钮添加对应的控制器 以及偏转何时的位置
- (void)addChileView:(NSInteger)index{
    
    
    UIViewController *vc = self.childViewControllers[index];
    CGFloat vcX = index * self.contentView.bounds.size.width;
    CGFloat vcW = self.contentView.bounds.size.width;
    CGFloat vcH = self.contentView.bounds.size.height;
    self.contentView.contentOffset = CGPointMake(vcX, 0);
    vc.view.frame = CGRectMake(vcX, 0, vcW, vcH);
    [self.contentView addSubview:vc.view];
    
}
#pragma mark - 让按钮居中
- (void)setLableCenter:(UILabel *)lable{
    
//    CGFloat offSetX = lable.center.x - LGScreen * 0.5;
//    if (offSetX<0) offSetX = 0;
//    CGFloat maxOffSet = self.titleView.contentSize.width - LGScreen;
//    if (offSetX>maxOffSet) {
//        offSetX = maxOffSet;
//    }
//    [self.titleView setContentOffset:CGPointMake(offSetX, 0) animated:YES];
    
    
}

#pragma mark - 初始化ScrollVIew
- (void)setScrollVIew{
    NSInteger count = self.childViewControllers.count;
    self.titleView.contentSize = CGSizeMake(count * lableW, 0);
    self.titleView.showsHorizontalScrollIndicator = NO;
    
    CGFloat contenX = count * LGScreen;
    self.contentView.contentSize = CGSizeMake(contenX,0);
    self.contentView.pagingEnabled = YES;
    self.contentView.showsHorizontalScrollIndicator = NO;
    self.contentView.delegate = self;
    
}

#pragma mark - UIScrollViewDelegate
//滚动的时候调用
//让按钮变大变小
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger count = self.childViewControllers.count;
  
    CGFloat index = scrollView.contentOffset.x / LGScreen;
    //获取左边按钮
     
    UILabel *leftLble = self.dataArray[(int)index];
    //获取右边按钮 //获取左边按钮
    UILabel *rightLble;
    if (index < count - 1) {
        rightLble =self.dataArray[(int)index + 1];
    }
    //右边的缩放放大系数
    CGFloat rightscale = index - (int)index;
    //左边的放大系数
    NSLog(@"%f",rightscale);
    CGFloat leftscale = 1- rightscale;
    leftLble.transform = CGAffineTransformMakeScale(leftscale * 0.1 + 1, leftscale * 0.1 + 1);
    rightLble.transform = CGAffineTransformMakeScale(rightscale * 0.1 + 1 , rightscale * 0.1 + 1);
    //设置渐变颜色,黑色是最纯洁的RGB:0,0,0
//    leftLble.textColor = [UIColor colorWithWhite:leftscale alpha:1.0];
//  
//    rightLble.textColor  = [UIColor colorWithWhite:rightscale alpha:1.0];
    
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //当scrollview滚动完成之后要做的事情
    //当我滚动时根据当前滚动的偏移量的出索引,添加对应的Veiw，然后再让对应的按钮进行选中
    //获取当前控制器滑动对应的索引
    NSInteger index = scrollView.contentOffset.x / LGScreen;
    
    //让对应的按钮选中
    
    //不能从scrollView提出出子控件，因为scrollView姿带多两个控件，两个滚动条,所以我们用数组的方式来保存
    UILabel *lable = self.dataArray[index];
    [self selectedWithcancelSeleced:lable];
    //根据索引在当前偏移结束的位置添加view
    [self addChileView:index];
    //滚动的时候也让按钮居中
    [self setLableCenter:lable];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
