//
//  NSString+LGImageStyle.m
//  ifaxian
//
//  Created by ming on 16/12/4.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "NSString+LGImageStyle.h"

@implementation NSString (LGImageStyle)

-(NSString *)lg_largeImage{
    
    return self;
}
-(NSString *)lg_thumbnailImageSizeImageW:(int)imageW{
    
    return [NSString stringWithFormat:@"%@?image/resize,m_fill,w_100,h_100,limit_0/auto-orient,0/sharpen,239/quality,q_90/format,jpg",self];
}
-(NSString *)lg_mediumImage{
    
    return [NSString stringWithFormat:@"%@?image/resize,m_fill,w_200,h_200,limit_0/auto-orient,0/quality,q_100",self];
}

- (NSString *)lg_jpgReplaceGif{
    
    return [NSString stringWithFormat:@"%@?x-oss-process=image/format,jpg",self];
    
}
@end
