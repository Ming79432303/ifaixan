//
//  LGHomeCommentView.m
//  ifaxian
//
//  Created by ming on 16/12/6.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGHomeCommentView.h"
#import "LGHomeCommntContentView.h"
@interface LGHomeCommentView ()<UIScrollViewDelegate>

@property(nonatomic, weak) LGHomeCommntContentView *visiView;
@property(nonatomic, weak) LGHomeCommntContentView *reuseView;
@property(nonatomic, assign) NSInteger curPage;
@end



@implementation LGHomeCommentView
#define kCount  self.comments.count
- (void)awakeFromNib{
    
    [super awakeFromNib];

    self.delegate = self;
    [self setupUI];
    
    
}


- (void)setupUI{
    //    _currentPageImage _pageImage
    
    
    
    
    CGFloat w = self.self.bounds.size.width;
    CGFloat h = self.self.bounds.size.height;
    
    //初始化scroview
    self.contentOffset = CGPointMake(0,  h);
    self.contentSize = CGSizeMake(0,3 * h);
    self.pagingEnabled = YES;
    self.delegate = self;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    
    
    //创建一个重用的imageView
    LGHomeCommntContentView *reuseView = [LGHomeCommntContentView viewFromeNib];
   
    
    reuseView.frame = self.bounds;
    
    [self addSubview:reuseView];
    //添加一个用来显示的imageVIew
    LGHomeCommntContentView *visiView = [LGHomeCommntContentView viewFromeNib];
    visiView.tag = 0;
   
 
    visiView.frame = CGRectMake(0, h, w, h);
    [self addSubview:visiView];
    
    self.visiView = visiView;
    self.reuseView = reuseView;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    
    CGRect rect = self.reuseView.frame;
    CGFloat offSetY = scrollView.contentOffset.y;
    CGFloat h = self.bounds.size.height;
    
    //左边滑动
    NSInteger index = 0;
    
    if (offSetY < self.visiView.frame.origin.y) {
        rect.origin.y = 0;
        index = self.visiView.tag - 1;
        self.curPage = self.visiView.tag;
        if (index < 0) {
            index = kCount-1;
            
        }
    }else{
        //右边滑动
        rect.origin.y = self.contentSize.height - h;
        index =  _visiView.tag + 1;
       
        self.curPage  = self.visiView.tag;
        if (index >= kCount) {
            index = 0;
        }
        
    }
    
    
    
    
    
    rect.origin.x = scrollView.bounds.origin.x;
    self.reuseView.frame = rect;
    _reuseView.tag = index;
 
   
 
    // 2.滚动到 最左 或者 最右 的图片
    if (offSetY <= 0 || offSetY >= h * 2) {
        // 2.1.交换 中间的 和 循环利用的指针
        LGHomeCommntContentView *temp = _visiView;
        _visiView = _reuseView;
        _reuseView = temp;
        
        // 2.2.交换显示位置
        _visiView.frame = _reuseView.frame;
        
        // 2.3 初始化scrollView的偏移量
        scrollView.contentOffset = CGPointMake(0, h);
        
    }
    
    
}
- (void)commentViewSetOffset{
    
    CGPoint offset = self.contentOffset;
    offset.y += self.bounds.size.height;
    [self setContentOffset:offset animated:YES];
    
}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if (self.curPage >= self.comments.count) {
        return;
    }
     self.reuseView.comment = self.comments[self.curPage];
}
- (void)setComments:(NSArray *)comments{
    if (comments.count<=0) {
        return;
    }
    _comments = comments;
    
    self.reuseView.comment = comments.firstObject;
    self.contentOffset = CGPointMake(0, self.bounds.size.height);
    [self commentViewSetOffset];
}


@end
