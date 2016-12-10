//
//  LGPhotoListController.h
//  自定义相册
//
//  Created by Apple_Lzzy27 on 16/11/16.
//  Copyright © 2016年 Apple_Lzzy27. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LGPhotoListController : UITableViewController
@property(nonatomic, copy) void (^photoBlock)(NSArray<UIImage *>* images);
+ (instancetype)photoList:(void(^)(NSArray<UIImage *>* images))selectedImages;

@end
