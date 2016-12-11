//
//  NSObject+LGGetphoto.h
//  获得相册中的图片
//
//  Created by ming on 16/11/10.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <UIKit/UIKit.h>
#import "LGPhoto.h"
#import "LGPhotoImage.h"
@interface NSObject (LGGetphoto)
///获得相铺中的缩略图
+ (void)lg_getThumbnailImage:(void(^)(NSArray<LGPhoto *> *photos))completion;
///获得相铺中的原图
+ (void)lg_getOriginalImage:(void(^)(NSArray<LGPhoto *> *photos))completion;
/**
 *  获得相机胶卷中的所有图片
 */
+ (NSArray *)lg_getImagesFromCameraRoll;
/**
 *  获得相机胶卷中的所有名字
 */
+ (void)lg_getPhotoName:(void(^)(NSArray<NSString *> *names))completion;
@end
