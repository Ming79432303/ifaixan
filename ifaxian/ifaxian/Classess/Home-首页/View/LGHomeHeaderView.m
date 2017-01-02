//
//  LGHomeHeaderView.m
//  ifaxian
//
//  Created by ming on 16/11/25.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGHomeHeaderView.h"
#import "UIImage+AlphaImage.h"
#import "LGScrollContenView.h"
@interface LGHomeHeaderView()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageView;
@property(nonatomic, weak) LGScrollContenView *visiView;
@property(nonatomic, weak) LGScrollContenView *reuseView;
@property(nonatomic, strong) NSTimer *timer;
@end;

#define kCount self.headerArray.count

@implementation LGHomeHeaderView

- (void)awakeFromNib{
    
    [super awakeFromNib];
    //当前尺寸有问题需要手动设置下
    self.lg_width = [UIScreen lg_screenWidth];
    self.scrollView.lg_width = [UIScreen lg_screenWidth];
    self.scrollView.delegate = self;
    [self setupUI];
    [self addtimer];
    
    
}
//添加定时器
- (void)addtimer{
    
  self.timer = [NSTimer timerWithTimeInterval:6.0 target:self selector:@selector(time) userInfo:nil repeats:YES];
    //添加到消息循环中
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    
    
    
}
//定期器方法
- (void)time{
    CGPoint offset = self.scrollView.contentOffset;
    offset.x += self.scrollView.lg_width;
    [self.scrollView setContentOffset:offset animated:YES];
    
}
//移除定时器
- (void)removeTime{
    [self.timer invalidate];
    self.timer = nil;
   
    
}
//当控制器销魂时移除定时器
- (void)dealloc{
    
    [self removeTime];
}

#pragma mark - scrollview初始化
- (void)setupUI{

   
    [self.pageView setValue:[UIImage WhiteimageWithAlpha:0.3] forKeyPath:@"_pageImage"];
    [self.pageView setValue:[UIImage WhiteimageWithAlpha:1] forKeyPath:@"_currentPageImage"];
    CGFloat w = self.scrollView.bounds.size.width;
    CGFloat h = self.scrollView.bounds.size.height;
    //初始化scroview
    self.scrollView.contentOffset = CGPointMake(w, 0);
    self.scrollView.contentSize = CGSizeMake(3 * w, 0);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    //创建一个重用的imageView
    LGScrollContenView *reuseView = [LGScrollContenView viewFromeNib];
    reuseView.frame = self.scrollView.bounds;
    [self.scrollView addSubview:reuseView];
    //添加一个用来显示的imageVIew
    LGScrollContenView *visiView = [LGScrollContenView viewFromeNib];
    visiView.tag = 0;
    visiView.frame = CGRectMake(w, self.scrollView.frame.origin.y, w, h);
    [self.scrollView addSubview:visiView];
    self.visiView = visiView;
    self.reuseView = reuseView;
    
}
#pragma mark - 无限轮播器核心代码
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    CGRect rect = self.reuseView.frame;
    CGFloat offSetX = scrollView.contentOffset.x;
    CGFloat w = self.scrollView.bounds.size.width;
    //左边滑动
    NSInteger index = 0;
    if (offSetX < self.visiView.frame.origin.x) {
        rect.origin.x = 0;
        index = self.visiView.tag - 1;
         self.pageView.currentPage = self.visiView.tag;
        if (index < 0) {
            index = kCount-1;
        }
    }else{
        //右边滑动
        rect.origin.x = self.scrollView.contentSize.width - w;
        index =  self.visiView.tag + 1;
        self.pageView.currentPage = self.visiView.tag;
        if (index >= kCount) {
            index = 0;
        }
        
    }
    
    rect.origin.y = scrollView.bounds.origin.y;
    self.reuseView.frame = rect;
    _reuseView.tag = index;
    LGHomeModel *model = self.headerArray[index];
    self.reuseView.model = model;
    // 2.滚动到 最左 或者 最右 的图片
    if (offSetX <= 0 || offSetX >= w * 2) {
        // 2.1.交换 中间的 和 循环利用的指针
        LGScrollContenView *temp = _visiView;
        _visiView = _reuseView;
        _reuseView = temp;
        // 2.2.交换显示位置
        _visiView.frame = _reuseView.frame;
        // 2.3 初始化scrollView的偏移量
        scrollView.contentOffset = CGPointMake(w, 0);
        
    }
    
    
}

#pragma mark - scroview代理方法
//开始拖拽时移除定时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    [self removeTime];
    
}
//拖拽完毕之后天剑定时器
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
 
    [self addtimer];
    
}


/**
 *  设置一开始时，第一次赋值时的数据(赋值时首页轮播是没有数据的要等到轮播器滚动才开始有数据，所以这里要提前设置好)
 *
 *  @param headerArray 首页获取轮播器的数据
 */
- (void)setHeaderArray:(NSArray<LGHomeModel *> *)headerArray{
    
    _headerArray = headerArray;
    self.visiView.model = headerArray.firstObject;
    self.pageView.numberOfPages = headerArray.count;
    
}


@end
