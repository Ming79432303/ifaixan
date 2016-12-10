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
    
    [self sd_setImageWithURL:strUrl placeholderImage:image options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
       
    }];
    
    

}
-(void)lg_setCircularImageWithurl:(NSString *)url placeholderImage:(UIImage *)image {
    
    NSURL *strUrl = [NSURL URLWithString:url];
    if (strUrl == nil) {
        self.image = image;
        return;
    }
    
    [self sd_setImageWithURL:strUrl placeholderImage:image options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.image = [image lg_avatarImagesize:image.size backColor:[UIColor whiteColor] lineColor:[UIColor lightGrayColor]];
    }];
    
    
    
}


@end
