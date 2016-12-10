//
//  LGPhotoNavigationController.h
//  自定义相册
//
//  Created by ming on 16/11/16.
//  Copyright © 2016年 Apple_Lzzy27. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LGPhotoNavigationController : UINavigationController
@property(nonatomic, copy) NSString *count;
+ (instancetype)photoList:(void(^)(NSArray<UIImage *>* images))selectedImages;

@end
