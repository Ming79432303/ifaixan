//
//  NSURL+LGImageSave.h
//  ifaxian
//
//  Created by ming on 16/12/6.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (LGImageSave)
/**
 *  根据URL保存一张图片
 *
 *  @param completion 回调结果
 */
- (void)lg_saveImage:(void(^)(bool isSuccess ,NSString * info))completion;
@end
