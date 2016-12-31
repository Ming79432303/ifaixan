//
//  NSString+LGImageStyle.m
//  ifaxian
//
//  Created by ming on 16/12/4.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "NSString+LGImageStyle.h"

@implementation NSString (LGImageStyle)

//原图
-(NSString *)lg_largeImage{
    
    return self;
}
//略缩图
-(NSString *)lg_thumbnailImageSizeImageW:(int)imageW{
    
    return [NSString stringWithFormat:@"%@?x-oss-process=image/resize,w_400",self];
}
//中图
-(NSString *)lg_mediumImage{
    
    return [NSString stringWithFormat:@"%@?image/resize,m_fill,w_200,h_200,limit_0/auto-orient,0/quality,q_100",self];
}
//截取gif第一张图片

- (NSString *)lg_jpgReplaceGif{
    
    return [NSString stringWithFormat:@"%@?x-oss-process=image/format,jpg",self];
    
}
@end
