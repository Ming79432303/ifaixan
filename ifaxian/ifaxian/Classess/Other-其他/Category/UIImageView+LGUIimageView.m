//
//  UIImageView+LGUIimageView.m
//  微博oc版
//
//  Created by Apple_Lzzy27 on 16/10/21.
//  Copyright © 2016年 Apple_Lzzy27. All rights reserved.
//

#import "UIImageView+LGUIimageView.h"
#import "UIImage+lg_image.h"


@implementation UIImageView (LGUIimageView)


//隔离sdimage
-(void)lg_setImageWithurl:(NSString *)url placeholderImage:(UIImage *)image {
    
    NSURL *strUrl = [NSURL URLWithString:url];
    if (strUrl == nil) {
       self.image = image;
        return;
    }
    if (image == nil) {
        image = [UIImage imageNamed:@"default_placeholder_Image"];
    }
  
    [self sd_setImageWithURL:strUrl placeholderImage:image options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
       
    }];
    
    

}
-(void)lg_setCircularImageWithurl:(NSString *)url placeholderImage:(UIImage *)image {
    
    NSURL *strUrl = [NSURL URLWithString:url];
    if (strUrl == nil) {
        self.image = image;
        return;
    }
     LGWeakSelf;
    [self sd_setImageWithURL:strUrl placeholderImage:image options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        weakSelf.image = [image lg_avatarImagesize:image.size backColor:[UIColor whiteColor] lineColor:[UIColor lightGrayColor]];
    }];
    
    
    
}
- (void)setHeader:(NSString *)url
{
    [self setCircleHeader:url];
}

- (void)setRectHeader:(NSString *)url
{
    [UIImage imageNamed:@"default_Avatar"];
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
}

- (void)setCircleHeader:(NSString *)url
{
    LGWeakSelf;
    
    UIImage *placeholder = [[UIImage imageNamed:@"default_Avatar"] lg_circleImage];
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder completed:
     ^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
         // 如果图片下载失败，就不做任何处理，按照默认的做法：会显示占位图片
         if (image == nil) return;
         
         weakSelf.image = [image lg_circleImage];
     }];

}

@end
