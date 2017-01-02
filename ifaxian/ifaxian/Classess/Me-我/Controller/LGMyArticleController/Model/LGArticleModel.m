//
//  LGArticleModel.m
//  ifaxian
//
//  Created by ming on 16/11/22.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGArticleModel.h"
#import "NSString+LGStringSize.h"
@implementation LGArticleModel

/**
 *  行高计算
 */
- (CGFloat)articleCellHeight{
    
    
    if (_articleCellHeight) {
        return _articleCellHeight;
    }

        
  
    
    _articleCellHeight += LGCommonMargin;
    CGFloat nameLableH = 16
    ;
    _articleCellHeight += nameLableH + LGCommonMargin;
    
    _articleCellHeight +=[self.title boundingRectWithSize:CGSizeMake(LGScreenW - 2 * LGCommonMargin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height;
    CGFloat bottomH = 16;
    _articleCellHeight += bottomH + 2 * LGCommonMargin;
    return _articleCellHeight;
    
}


@end
