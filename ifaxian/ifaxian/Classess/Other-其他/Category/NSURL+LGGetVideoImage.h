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
+ (void)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time completion:(void(^)(UIImage *thumbnailImage))completion;
@end
