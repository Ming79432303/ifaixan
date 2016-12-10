//
//  LGComment.m
//  ifaxian
//
//  Created by Apple_Lzzy27 on 16/11/17.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGComment.h"
#import "NSString+LGRegularExpressions.h"

@implementation LGComment


#warning 4s运行行高有误差

- (CGFloat)rowHeght{
    if (_rowHeght) {
        return _rowHeght;
    }
    
    CGFloat height = 0;
    
    height += LGCommentNameHeight + 2 * LGCommonMargin;
    
    height += [self.content boundingRectWithSize:CGSizeMake(LGScreenW - 3*LGCommonMargin - LGCommentIconHeight, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:LGCommentFontSize]} context:nil].size.height;
       CGFloat timeLableH = LGCommentToolHeight;
    
    height += timeLableH +2 * LGCommonMargin + LGCommonSmallMargin;
    
    _rowHeght = height;
 
    
    
    return _rowHeght;
}

-(CGFloat)replyHeght{
    if (_replyHeght) {
        return _replyHeght;
    }
    
    CGFloat height = 0;
    NSString *rewTitle = [NSString stringWithFormat:@"@%@ 发表于 %@",self.name,self.date];
    height += [rewTitle boundingRectWithSize:CGSizeMake(LGScreenW - 7*LGCommonMargin - 35, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:LGCommentReplyFontSize]} context:nil].size.height;
   
    
    height += [self.content boundingRectWithSize:CGSizeMake(LGScreenW - 7*LGCommonMargin - 35, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:LGCommentReplyFontSize]} context:nil].size.height;

    NSLog(@"%@,%f",rewTitle,[rewTitle boundingRectWithSize:CGSizeMake(LGScreenW - 7*LGCommonMargin - 35, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:LGCommentReplyFontSize]} context:nil].size.height);
    height += 2 * LGCommonMargin;
    _replyHeght = height + LGCommonMargin;
    
    return _replyHeght;
}

- (NSString *)content{
    
    return   [NSString lg_regularExpression:_content];
    
    
}

@end
