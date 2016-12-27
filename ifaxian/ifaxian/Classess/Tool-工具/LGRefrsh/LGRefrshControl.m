//
//  LGRefrshControl.m
//  下拉刷新oc
//
//  Created by ming on 16/10/31.
//  Copyright © 2016年 ming. All rights reserved.
//
#define refHeight 65
#import "LGRefrshControl.h"
#import "LGRefrshView.h"
#import "LGRefreshViewFont.h"
@interface LGRefrshControl()
@property(nonatomic, strong) UIScrollView *scrroView;
@property(nonatomic, strong) LGRefreshViewFont *refrshView;

@end
@implementation LGRefrshControl

- (LGRefreshViewFont *)refrshView{
    
    if (_refrshView == nil) {
        _refrshView = [LGRefreshViewFont refrshView];
    }
  
    return _refrshView;
}


- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self setupUI];
       
    }
    
    return self;
}
//移除监听者
- (void)willRemoveSubview:(UIView *)subview{

    
    
        
        [self removeObserver:self forKeyPath:@"contentOffset"];


    
}
/// willMove addSubview 方法调用
///单添加在父控件视图的时候，newSuperView是父视图
//当俯视图被移除 newSuperView 是nil
///

- (void)willMoveToSuperview:(UIView *)newSuperview{
    
  
    if (![newSuperview isKindOfClass:[UIScrollView class]]) {
        return;
    }
    self.backgroundColor = newSuperview.backgroundColor;
    UIScrollView *scr = (UIScrollView *)newSuperview;
    
    
    _scrroView = scr;
   //添加监听者
    [scr addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
}
//刷新方法
///开始刷新
- (void)beginRefreshing{
  
    if (_scrroView == nil) {
        return;
    }
    if (self.refrshView.refState == willRefresh) {
        return;
    }
      self.refrshView.refState = willRefresh;
  UIEdgeInsets inset = self.scrroView.contentInset;
    inset.top += refHeight;
    _scrroView.contentInset = inset;
}
///结束刷新
- (void)endRefreshing{
    

    if (self.scrroView == nil) {
        return;
    }
    if (self.refrshView.refState != willRefresh) {
        return;
    }
    UIEdgeInsets inset = self.scrroView.contentInset;
    inset.top -= refHeight;
    self.scrroView.contentInset = inset;

    
     self.refrshView.refState = Normal;
}


//监听者执行方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    CGFloat heiht = -(self.scrroView.contentOffset.y + 64);
    if (heiht < 0) {
        return;
    }
    //设置下拉控件的frame
  CGRect rect = CGRectMake(0, -heiht, self.scrroView.bounds.size.width, heiht);
    self.frame = rect;
    if (self.refrshView.refState != willRefresh) {
        self.refrshView.parentViewHeight = heiht;
        
    }
    //对下拉高度进行判断
    //判断是下拉状态
    if (self.scrroView.isDragging) {
        if (heiht < refHeight && self.refrshView.refState == PullIng) {
        
            self.refrshView.refState = Normal;
            
        }else if (heiht > refHeight && self.refrshView.refState == Normal) {
            self.refrshView.refState = PullIng;
          
        }
    }else{
        if (heiht > refHeight && self.refrshView.refState == PullIng) {
          
            //执行刷新控件
            [self beginRefreshing];
          //发送事件
            [self sendActionsForControlEvents:UIControlEventValueChanged];
            
   
        }
        
    }

}
//设置界面
- (void)setupUI{
  
    
    [self addSubview:self.refrshView];
    //添加约束
    self.refrshView.translatesAutoresizingMaskIntoConstraints = NO;
   
    NSLayoutConstraint *centerCons = [NSLayoutConstraint constraintWithItem:self.refrshView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    [self addConstraint:centerCons];
    
    NSLayoutConstraint *bottomCons = [NSLayoutConstraint constraintWithItem:self.refrshView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [self addConstraint:bottomCons];
    
    ///在这里用的就是Xib的宽高度
    NSLayoutConstraint *widthCons = [NSLayoutConstraint constraintWithItem:self.refrshView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute: NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.refrshView.bounds.size.width];
    [self addConstraint:widthCons];
    
    NSLayoutConstraint *heightCons = [NSLayoutConstraint constraintWithItem:self.refrshView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute: NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.refrshView.bounds.size.height];
    [self addConstraint:heightCons];
    
}





@end
