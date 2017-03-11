//
//  LGScrollContenView.m
//  ifaxian
//
//  Created by ming on 16/11/25.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGScrollContenView.h"
#import <UIImageView+WebCache.h>
#import "LGImageSize.h"
#import "LGImage.h"
#import "LGDisplayController.h"
@interface LGScrollContenView()

@property(nonatomic, copy) LGPostModel *lasModel;

@end;

@implementation LGScrollContenView


- (void)awakeFromNib{
    
    [super awakeFromNib];
    //给标题文字添加单击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(go2:)];
    
    
    
    [self.titileLable addGestureRecognizer:tap];
    
}
//点击图片跳转
- (void)go2:(UIGestureRecognizer *)tap{
   
    self.titileLable.highlighted = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.titileLable.highlighted = NO;
    });
    
  UITabBarController *tabar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
   UINavigationController *nav = tabar.selectedViewController;
    
    LGDisplayController *showVc = [[LGDisplayController alloc] init];
    
    showVc.model = self.model;
    
    [nav pushViewController:showVc animated:YES];
    
    
}
//设置模型数据
- (void)setModel:(LGHomeModel *)model{

    _model = model;
    //判断上次的模型是否与当前模型相同相同就不用再设置了
    if (_lasModel == model) {
        return;
    }
    self.timeLable.text = model.date;
    self.titileLable.text = model.title;
    //拿到分类中的第一个标题
    if (model.categories.firstObject.title.length) {
        [self.categoryButton  setTitle:model.tags.firstObject.title forState:UIControlStateNormal];
      
    }else{
        //如果模型中不存在分类那么就显示文章
        [self.categoryButton  setTitle:@"文章" forState:UIControlStateNormal];
        
    }
    //设置图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.images.firstObject] placeholderImage:nil];
    
    [self setNeedsLayout];
    //赋值给上一次的模型
    _lasModel = model;
}


@end
