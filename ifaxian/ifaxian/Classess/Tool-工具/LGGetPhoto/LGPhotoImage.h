//
//  LGPhotoImage.h
//  自定义相册
//
//  Created by ming on 16/12/5.
//  Copyright © 2016年 Apple_Lzzy27. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface LGPhotoImage : NSObject

@property(nonatomic, assign) BOOL isGif;
@property(nonatomic, strong) UIImage *image;
@property(nonatomic, strong) NSData *imageData;
+ (instancetype)phototisGif:(BOOL)isGif image:(UIImage *)image imageData:(NSData *)imageData;
@end
