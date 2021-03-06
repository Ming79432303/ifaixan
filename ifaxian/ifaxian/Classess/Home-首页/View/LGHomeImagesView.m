//
//  LGHomeImagesView.m
//  ifaxian
//
//  Created by ming on 16/12/9.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGHomeImagesView.h"
#import "LWImageBrowser.h"
@interface LGHomeImagesView ()
@property(nonatomic, strong) NSMutableArray *imageModels;
@end

@implementation LGHomeImagesView

- (NSMutableArray *)imageModels{
    if (_imageModels == nil) {
        _imageModels = [NSMutableArray array];
    }
    
    return _imageModels;
}


- (void)awakeFromNib{
    
    [super awakeFromNib];
    [self setupUI];
    self.backgroundColor = [UIColor whiteColor];
    
}

- (void)setImages:(NSArray *)images{
    _images = images;
    //先隐藏所有图片防止出现循环引用的图片
    for (UIImageView *imageV in self.subviews) {
        imageV.hidden = YES;
    }
    //多图布局业务逻辑
    if (images.count > 0) {
        //只有一张图布局
        if (images.count == 1) {
            
            UIImageView *imageV = self.subviews.firstObject;
            imageV.hidden = NO;
            imageV.frame = CGRectMake(0, 0,LGScreenW - 3 * LGCommonMargin,200);
            [imageV lg_setImageWithurl:images.firstObject placeholderImage:nil];
            
        }else{
            //第一行张图的imageView恢复原来的形状
            UIImageView *imageV = self.subviews.firstObject;
            imageV.frame = CGRectMake(0, 0, LGHomeImageViewItemWH, LGHomeImageViewItemWH);
        }
        //只有四张图
        if (images.count == 4) {
            int index = 0;
            for (int i =0; i<= images.count; i++) {
                UIImageView *v = self.subviews[i];
                //特殊处理
                if (i == 2) {
                    continue;
                }
                int lin = i % 3;
                int loc = i / 3;
                //九宫格布局
                v.frame = CGRectMake(LGCommonMinMargin * (lin) + lin * (LGHomeImageViewItemWH), LGCommonMinMargin * (loc) + loc * (LGHomeImageViewItemWH), LGHomeImageViewItemWH, LGHomeImageViewItemWH);
                v.hidden = NO;
                NSString *url =  images[index];
                [v lg_setImageWithurl:url placeholderImage:nil];
                index ++;
            }
        }else{
        //其他类型图片布局
        for (int i = 0;i < images.count; i++) {
            
            UIImageView *v = self.subviews[i];
            v.hidden = NO;
            [v lg_setImageWithurl:images[i] placeholderImage:nil];
            
        }
    }
   }
}
//布局UI最多6张
- (void)setupUI{
    //循环添加6张图，先添加好所有空间
    for (int i = 0; i < 6; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        int lin = i % 3;
        int loc = i / 3;
        imageView.frame = CGRectMake(LGCommonMinMargin * (lin) + lin * (LGHomeImageViewItemWH), LGCommonMinMargin * (loc) + loc * (LGHomeImageViewItemWH), LGHomeImageViewItemWH, LGHomeImageViewItemWH);
        imageView.hidden = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:tap];
        [self addSubview:imageView];
    }
}
//点击图片方法
- (void)tap:(UIGestureRecognizer *)tap{
    //先移除当前数组的所有数据
    [self.imageModels removeAllObjects];
    
    int index = 0;
    int page =0;
    //从新天剑当前图片数组
    for (NSString *urlStr in self.images) {
        //4张图图片点击处理
        if (self.images.count == 4) {
            if (index == 2) {
                
                index += 1;
            }
        }
        
        //创建图片浏览模型
        NSURL *url = [NSURL URLWithString:urlStr];
        UIImageView *imageV = self.subviews[index];
        imageV.tag = page;
       
        LWImageBrowserModel *imageModel = [[LWImageBrowserModel alloc] initWithplaceholder:[UIImage imageNamed:@"default_placeholder_Image"] thumbnailURL:url HDURL:url containerView:self positionInContainer:imageV.frame index:imageV.tag];
        [self.imageModels addObject:imageModel];
        index ++;
        page += 1;
    }
    //显示图片
    if (self.imageModels.count) {

        LWImageBrowser *imageBrowser = [[LWImageBrowser alloc] initWithImageBrowserModels:self.imageModels currentIndex:tap.view.tag];

        
        [imageBrowser show];
    }

   }

@end
