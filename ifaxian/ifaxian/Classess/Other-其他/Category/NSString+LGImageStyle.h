//
//  NSString+LGImageStyle.h
//  ifaxian
//
//  Created by ming on 16/12/4.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LGImageStyle)

-(NSString *)lg_largeImage;
-(NSString *)lg_thumbnailImageSizeImageW:(int)imageW;
-(NSString *)lg_mediumImage;
- (NSString *)lg_jpgReplaceGif;
@end
