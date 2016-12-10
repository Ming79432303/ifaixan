//
//  LGPhoto.m
//  获得相册中的图片
//
//  Created by ming on 16/11/10.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGPhoto.h"
#import "MJExtension.h"

@implementation LGPhoto


+ (instancetype)phototTitle:(NSString *)albumName images:(NSArray *)images{
    LGPhoto *photo= [[self alloc] init];
    photo.albumName = albumName;
    photo.images = images;
    
    return photo;
    
}
+(NSDictionary *)mj_objectClassInArray{
    
    return @{
             @"statuses" : [LGPhotoImage class]
             };
}
@end
