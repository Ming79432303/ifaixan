//
//  LGShare.m
//  ifaxian
//
//  Created by ming on 16/11/30.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGShare.h"

@implementation LGShare

- (instancetype)initWithModel:(LGShareImage *)shareImage{
    
    if (self = [super init]) {
        
        self.share = shareImage;
        
        [self setupImageArray];
        [self calculateHeight];
    }
    
    return self;
}



//- (NSMutableArray *)images{
//    if (_images == nil) {
//        _images = [NSMutableArray array];
//    }
//    
//    return _images;
//}


- (void)calculateHeight{
       _rowHeight = 0;
    
    CGFloat iconH = 35;
    
    _rowHeight += iconH + 3 * LGCommonMargin;
    
    //计算文本的高度
   _rowHeight += [self.share.title boundingRectWithSize:CGSizeMake(LGScreenW - 2 * LGCommonMargin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height;
    
    //计算图像的高度
    CGFloat imageH = 0;
    if (self.VideoUrl.length) {
        _videoViewFrame = CGRectMake(LGCommonMargin, _rowHeight, LGScreenW - 4 * LGCommonMargin, 200);
        _rowHeight += 200;
    }
    if (self.images.count > 0) {
    switch (self.images.count) {
          //一张图片
        case LGOnePictures:{
            
            
            imageH = _oneImageSize.height;
            
        }break;
                 //两张图片
        case LGTwoPictures:{
            
            imageH = LGTowImageItemWH ;
            
        }break;
        //四站图片
        case LGFourpictures:{
             imageH = 2 * LGTowImageItemWH ;
        }break;
        default:{
            
             imageH = ((self.images.count - 1)/3 + 1) * LGImageItemWH + (((self.images.count - 1)/3 + 1)-1) * LGCommonSmallMargin;
           
            
        }
            break;
        }
    }else{
        _rowHeight -= LGCommonMargin;
    }
    _rowHeight += imageH;
    
    CGFloat toolBarH = 44;
    
    _rowHeight += toolBarH + 2 * LGCommonMargin;
    
}
//重新计算单张图的行高
- (void)calculateOneHeight:(CGSize)imageSize{
    
    _oneImageSize = imageSize;
    
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    //从新计算行高
    //单张图如处理
    //最大宽
    CGFloat maxWidth = LGScreenW - 4 * LGCommonMargin;
    //最小高
    CGFloat minWidth = 50;
    
    
    if (width > maxWidth) {
        
        //        width/height = image.size.width/image.size.height
        //
        //        heigh * image.size.width = width * image.size.height
        //
        //        height = width * image.size.height/image.size.width;
        width = maxWidth;
        height = width * imageSize.height/imageSize.width;
        
        //进行等宽等高比例
    }
    if (width < minWidth) {
        width = minWidth;
        height = width * imageSize.height/imageSize.width;
    }
    //最大宽
    CGFloat maxHeight = 0.8 * LGScreenH;
    if (height > maxHeight) {
        height = maxHeight;
    }
    CGSize size = CGSizeMake(width, height + LGCommonMargin);
    self.oneImageSize = size;
    //重新计算行高
    [self calculateHeight];
    
    
}



//获取图片
- (void)setupImageArray{
    
    NSString *url = [NSString lg_regularExpression:_share.content];
    if (url.length) {
        if ([url hasSuffix:@".mp4"]) {
            self.VideoUrl = [NSString stringWithFormat:@"%@video/%@",LGbuckeUrl,url];
            return;
        }
        self.images = [_share.content lg_getAllImages];
       }
}

@end
