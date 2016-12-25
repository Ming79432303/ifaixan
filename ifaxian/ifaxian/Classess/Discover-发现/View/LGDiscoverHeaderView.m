//
//  LGDiscoverHeaderView.m
//  ifaxian
//
//  Created by ming on 16/11/29.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGDiscoverHeaderView.h"

@interface LGDiscoverHeaderView()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scroView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageView;
@property(nonatomic, weak) UIImageView *visiView;
@property(nonatomic, weak) UIImageView *reuseView;
@property(nonatomic, strong) NSTimer *timer;
@property(nonatomic, assign) NSInteger curPage;
@end

#define kCount  3
@implementation LGDiscoverHeaderView
- (void)awakeFromNib{
    
    [super awakeFromNib];
    self.lg_width = [UIScreen lg_screenWidth];
    self.scroView.lg_width = [UIScreen lg_screenWidth];
    self.scroView.delegate = self;
    [self setupUI];
    [self addtimer];
    
    
}
- (void)addtimer{
    
    self.timer = [NSTimer timerWithTimeInterval:4.0 target:self selector:@selector(time) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    
    
    
}

- (void)time{
    CGPoint offset = self.scroView.contentOffset;
    offset.x += self.scroView.lg_width;
    [self.scroView setContentOffset:offset animated:YES];
    
}
- (void)removeTime{
    [self.timer invalidate];
    
    
}

- (void)dealloc{
    
    [self removeTime];
}


- (void)setupUI{
    //    _currentPageImage _pageImage
    
    
    
    
    CGFloat w = self.scroView.bounds.size.width;
    CGFloat h = self.scroView.bounds.size.height;
    
    //初始化scroview
    self.scroView.contentOffset = CGPointMake(w, 0);
    self.scroView.contentSize = CGSizeMake(3 * w, 0);
    self.scroView.pagingEnabled = YES;
    self.scroView.delegate = self;
    self.scroView.showsHorizontalScrollIndicator = NO;
    
    
    //创建一个重用的imageView
    UIImageView *reuseView = [[UIImageView alloc] init];
    reuseView.backgroundColor = [UIColor yellowColor];
    reuseView.contentMode = UIViewContentModeScaleAspectFill;
    reuseView.clipsToBounds = YES;
    reuseView.frame = self.scroView.bounds;
    
    [self.scroView addSubview:reuseView];
    //添加一个用来显示的imageVIew
    UIImageView *visiView = [[UIImageView alloc] init];
    visiView.contentMode = UIViewContentModeScaleAspectFill;
    visiView                                                          .clipsToBounds = YES;
    visiView.tag = 0;
    visiView.backgroundColor = [UIColor redColor];
    visiView.frame = CGRectMake(w, self.scroView.frame.origin.y, w, h);
    [self.scroView addSubview:visiView];
    visiView.image = [UIImage imageNamed:@"disvc1"];
    self.visiView = visiView;
    self.reuseView = reuseView;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    CGRect rect = self.reuseView.frame;
    CGFloat offSetX = scrollView.contentOffset.x;
    CGFloat w = self.scroView.bounds.size.width;
    
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
        rect.origin.x = self.scroView.contentSize.width - w;
        index =  self.visiView.tag + 1;
        self.pageView.currentPage = self.visiView.tag;
        if (index >= kCount) {
            index = 0;
        }
        
    }
    
    rect.origin.y = scrollView.bounds.origin.y;
    self.reuseView.frame = rect;
    _reuseView.tag = index;
    _curPage = index;
    NSLog(@"%zd",self.curPage);
    NSString *imageName = [NSString stringWithFormat:@"disvc%zd",_curPage + 1];
    UIImage *image = [UIImage imageNamed:imageName];
    _reuseView.image = image;

       // 2.滚动到 最左 或者 最右 的图片
    if (offSetX <= 0 || offSetX >= w * 2) {
        // 2.1.交换 中间的 和 循环利用的指针
        UIImageView *temp = _visiView;
        _visiView = _reuseView;
        _reuseView = temp;
        
        // 2.2.交换显示位置
        _visiView.frame = _reuseView.frame;
        
        // 2.3 初始化scrollView的偏移量
        scrollView.contentOffset = CGPointMake(w, 0);
        
    }
    
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self removeTime];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self addtimer];
}







@end
