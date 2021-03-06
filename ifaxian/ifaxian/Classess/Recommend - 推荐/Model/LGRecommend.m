//
//  LGRecommend.m
//  ifaxian
//
//  Created by ming on 16/12/7.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGRecommend.h"
#import "NSString+LGRegularExpressions.h"

@implementation LGRecommend

//获取视频的地址
- (NSString *)videoUrl{
    
    if (_videoUrl.length) {
        
        return _videoUrl;
    }
    _videoUrl = [self.content lg_getVideoUrl];
    
    return _videoUrl;
}

//根据原始图片获取等比例缩放后的地址
- (void)setOriginalImageSize:(CGSize)originalImageSize{
    
    _originalImageSize = originalImageSize;
    /**
     *  等比例缩放
     */
    CGFloat imageW = LGScreenW - 2 * LGCommonMargin;
    CGFloat imageH = 0;
    if (originalImageSize.width <= 0) {
        _imageSize = CGSizeMake(0, 0);
        return;
    }
    imageH   = imageW * (originalImageSize.height/originalImageSize.width);
    _imageSize = CGSizeMake(imageW, imageH);
}
#pragma mark - 计算推荐界面的行高
//计算行高
- (CGFloat)xhCellHeght{
    if (_xhCellHeght) {
        return _xhCellHeght;
    }
    CGFloat nameIcomW = 35;
    _xhCellHeght += nameIcomW;
    _xhCellHeght += [self.title boundingRectWithSize:CGSizeMake(LGScreenW - 3*LGCommonMargin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size.height + LGCommonMargin * 5;
    if (self.imageUrl.length) {
        _xhCellHeght += self.imageSize.height;
    }else{
        _xhCellHeght += [self.contentText boundingRectWithSize:CGSizeMake(LGScreenW - 3*LGCommonMargin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
    }
    CGFloat toolViewH = 35;
    _xhCellHeght += toolViewH;
    return _xhCellHeght;
}
- (NSString *)contentText{
    if (self.imageUrl.length) {
        return _contentText;
    }
    _contentText = [NSString lg_regularExpression:self.content];
    _contentText = [_contentText stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
    return _contentText;
}
- (CGFloat)dmCellHeght{
    
    if (_dmCellHeght) {
            return _dmCellHeght;
        }
        _dmCellHeght += [self.title boundingRectWithSize:CGSizeMake(LGScreenW - 5*LGCommonMargin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17]} context:nil].size.height + LGCommonMargin * 3;
        _dmCellHeght += self.imageSize.height;
        return _dmCellHeght;
}

- (CGFloat)VideoCellHeght{
    
    if (_VideoCellHeght) {
        return _VideoCellHeght;
    }
    
    _VideoCellHeght += [self.title boundingRectWithSize:CGSizeMake(LGScreenW - 4*LGCommonMargin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17]} context:nil].size.height + LGCommonMargin * 3;
    
    _VideoCellHeght += 250;
    CGFloat toolViewH = 35;
    
    _VideoCellHeght += toolViewH;
    return _VideoCellHeght;

    
}
- (CGFloat)jueWuHeight{
    
    if (_jueWuHeight) {
        return _jueWuHeight;
    }
    _jueWuHeight += LGAvatarHeight + 2 * LGCommonMargin;
    
    _jueWuHeight += [self.title boundingRectWithSize:CGSizeMake(LGScreenW - 3*LGCommonMargin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16]} context:nil].size.height + LGCommonMargin * 2;
    _jueWuHeight += 128;
    
    _jueWuHeight += [self.excerpt boundingRectWithSize:CGSizeMake(LGScreenW - 3*LGCommonMargin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:12]} context:nil].size.height + LGCommonMargin * 2;
    
    return _jueWuHeight;
}
- (NSString *)descriptions{
    
    return [[NSString lg_regularExpression:self.excerpt] stringByReplacingOccurrencesOfString:@" [&hellip;]" withString:@"..."];
}


@end
