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
@implementation LGScrollContenView


- (void)awakeFromNib{
    
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(go2:)];
    
    
    
    [self.titileLable addGestureRecognizer:tap];
    
}

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
- (void)setModel:(LGHomeModel *)model{
    _model = model;
    
        
        self.timeLable.text = model.date;
    self.titileLable.text = model.title;
    if (model.categories.firstObject.title.length) {
        [self.categoryButton  setTitle:model.categories.firstObject.title forState:UIControlStateNormal];
      
    }else{
        [self.categoryButton  setTitle:@"文章" forState:UIControlStateNormal];
        
    }
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.thumbnail_images.full.url] placeholderImage:nil];
    
    [self setNeedsLayout];
    
}


@end
