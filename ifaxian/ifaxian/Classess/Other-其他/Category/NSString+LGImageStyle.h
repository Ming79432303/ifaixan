//
//  NSString+LGImageStyle.h
//  ifaxian
//
//  Created by ming on 16/12/4.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LGImageStyle)
/**
 *  返回大图
 *
 *  @return 返回大图地址
 */
-(NSString *)lg_largeImage;
/**
 *  返回小图
 *
 *  @return 返回小图地址
 */
-(NSString *)lg_thumbnailImageSizeImageW:(int)imageW;
/**
 *  返回中
 *
 *  @return 返回中图地址
 */
-(NSString *)lg_mediumImage;
/**
 *  gif图转jpg
 *
 *  @return jpg图片的地址
 */

- (NSString *)lg_jpgReplaceGif;
@end
