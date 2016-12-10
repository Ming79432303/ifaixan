//
//  LGPhotoImage.m
//  自定义相册
//
//  Created by ming on 16/12/5.
//  Copyright © 2016年 Apple_Lzzy27. All rights reserved.
//

#import "LGPhotoImage.h"

@implementation LGPhotoImage
+ (instancetype)phototisGif:(BOOL )isGif image:(UIImage *)image imageData:(NSData *)imageData;{
    LGPhotoImage *photoImage = [[LGPhotoImage alloc] init];
    photoImage.isGif = isGif;
    photoImage.image = image;
    photoImage.imageData = imageData;
    return photoImage;
    
}
@end
