//
//  LGPhotoNavigationController.m
//  自定义相册
//
//  Created by ming on 16/11/16.
//  Copyright © 2016年 Apple_Lzzy27. All rights reserved.
//

#import "LGPhotoNavigationController.h"
#import "LGPhotoListController.h"
@interface LGPhotoNavigationController ()

@end

@implementation LGPhotoNavigationController


+ (instancetype)photoList:(void(^)(NSArray<UIImage *>* images))selectedImages;{
    LGPhotoNavigationController *nav = [[LGPhotoNavigationController alloc] initWithRootViewController:[LGPhotoListController photoList:selectedImages]];
    return nav;
}



@end
