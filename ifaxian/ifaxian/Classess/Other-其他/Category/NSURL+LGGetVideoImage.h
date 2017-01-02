//
//  NSURL+LGGetVideoImage.h
//  ifaxian
//
//  Created by ming on 16/12/3.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
@interface NSURL (LGGetVideoImage)
/**
 *  得到视频的第一张图片
 *
 *  @param videoURL   视频的地址
 *  @param time       需要获时间对应的图片
 *  @param completion 完成回调
 */
+ (void)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time completion:(void(^)(UIImage *thumbnailImage))completion;
@end
