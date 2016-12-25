//
//  LGCategoryCell.m
//  图片浏览相册
//
//  Created by ming on 16/11/27.
//  Copyright © 2016年 ming. All rights reserved.
//
#import "LGCategoryCell.h"
#import "UIImageView+WebCache.h"
@interface LGCategoryCell()

@property (weak, nonatomic) IBOutlet UIView *showView;
@property (weak, nonatomic) IBOutlet UILabel *titleView;

@end



@implementation LGCategoryCell



- (void)awakeFromNib {
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
    
   
    int count = 4;
   

    for (int i = 0; i < count; i ++) {
        
        UIImageView *imageView = [[UIImageView alloc] init];
        
        [self.showView addSubview:imageView];
    }
    
    
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self layoutIfNeeded];
    CGFloat margin = 3;
    NSInteger count = self.showView.subviews.count;
    CGFloat imageW = (self.showView.bounds.size.width - margin) * 0.5;
    CGFloat imageH = (self.showView.bounds.size.height - margin) * 0.5;
    for (int i = 0; i<count ; i++) {
        UIImageView *imageView = self.showView.subviews[i];
        
        CGFloat lin = i/2;
        CGFloat loc = i%2;
        
        imageView.frame = CGRectMake(loc * (imageW + margin), lin * (imageH + margin), imageW, imageH);
  
    }
}
- (void)setModel:(LGShow *)model{
  
    _model = model;
    self.titleView.text = model.title;
    for (int i = 0; i < model.posts.count; i ++) {
        
        UIImageView *imageV = self.showView.subviews[i];
        imageV.contentMode = UIViewContentModeScaleAspectFill;
        imageV.clipsToBounds = YES;
        LGPostModel  *post = model.posts[i];
        NSString *url = post.imageUrl;
        [imageV sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"1479723749506"]];
        
    }
}


@end
