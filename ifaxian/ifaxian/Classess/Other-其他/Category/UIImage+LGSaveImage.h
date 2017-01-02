//
//  UIImage+LGSaveImage.h
//  test
//
//  Created by ming on 16/11/9.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LGSaveImage)
/**
 *  保存一张图片
 *
 *  @param completion 回调结果
 */
- (void)lg_saveImage:(void(^)(bool isSuccess ,NSString * info))completion;
/**
 *  保存一张gif图
 *
 *  @param imageUrl   gif图片的url
 *  @param completion 完成回调
 */
- (void)lg_saveGifImage:(NSURL *)imageUrl completion:(void(^)(bool isSuccess ,NSString * info))completion;
@end
