//
//  UIImage+LGSaveImage.h
//  test
//
//  Created by ming on 16/11/9.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LGSaveImage)

- (void)lg_saveImage:(void(^)(bool isSuccess ,NSString * info))completion;
- (void)lg_saveGifImage:(NSURL *)imageUrl completion:(void(^)(bool isSuccess ,NSString * info))completion;
@end
