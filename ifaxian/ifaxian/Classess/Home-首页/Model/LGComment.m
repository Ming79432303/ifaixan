//
//  LGComment.m
//  ifaxian
//
//  Created by Apple_Lzzy27 on 16/11/17.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGComment.h"
#import "NSString+LGRegularExpressions.h"
#import "NSCalendar+LGExtension.h"
#import "NSDate+myDate.h"

@implementation LGComment

//时间日期格式不要每一次都要创建
static NSDateFormatter *fmt_;
static  NSCalendar *canlendar_;
/**
 *  在第一次使当前类类时调用1次
 */
+ (void)initialize{
    fmt_ = [[NSDateFormatter alloc] init];
    canlendar_ = [NSCalendar lg_calendar];
    
}


- (CGFloat)rowHeght{
    //如果行高存在就不需要再次计算行高了
    if (_rowHeght) {
        return _rowHeght;
    }
    
    CGFloat height = 0;
    
    height += LGCommentNameHeight + 2 * LGCommonSmallMargin;
    
    height += [self.content boundingRectWithSize:CGSizeMake(LGScreenW - 3*LGCommonMargin - 2 * LGCommonSmallMargin - LGAvatarHeight, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:LGCommentFontSize]} context:nil].size.height;
       CGFloat timeLableH = LGCommentToolHeight;
    
    height += timeLableH +2 * LGCommonMargin + LGCommonSmallMargin;
    
    _rowHeght = height;
 
    
    
    return _rowHeght;
}
//父评论的高度
-(CGFloat)replyHeght{
    if (_replyHeght) {
        return _replyHeght;
    }
    
    CGFloat height = 0;
    NSString *rewTitle = [NSString stringWithFormat:@"@%@ 发表于 %@",self.self.author.nickname,self.date];
    CGFloat replayW = LGScreenW - 5*LGCommonMargin - LGAvatarHeight;
    height += [rewTitle boundingRectWithSize:CGSizeMake(replayW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:LGCommentReplyFontSize]} context:nil].size.height;
   
    
    height += [self.content boundingRectWithSize:CGSizeMake(replayW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:LGCommentReplyFontSize]} context:nil].size.height;

    height += 2 * LGCommonMargin;
    _replyHeght = height + LGCommonMargin + LGCommonSmallMargin;
    
    return _replyHeght;
}

- (NSString *)content{
    
    return   [NSString lg_regularExpression:_content];
    
    
}


- (NSString *)date{
    
        //时间的转换
        //2016-11-08 10:08:02
        
        
        fmt_.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate *date = [fmt_ dateFromString:_date];
        NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        
        //    //进行适配
        //    if ( [NSCalendar respondsToSelector:@selector(calendarWithIdentifier:)]) {//ios7后的
        //        canlendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
        //    }else{//ios7前的
        //        canlendar = [NSCalendar currentCalendar];
        //    }
        //获取传入时间的年月日小时
        // NSDateComponents  *compsonest = [canlendar components:unit fromDate:date];
        //获取当前时与传入时间的时间差值
        NSDateComponents *comps = [canlendar_ components:unit fromDate:date toDate:[NSDate date] options:0];
        //ios8的方法低版本无法运行
        
        //所以需要自己写
        
        NSString *dateStr;
        
        if (date.isThisYear) {
            if (date.isToday) {
                if (comps.hour >= 1) {
                    dateStr = [NSString stringWithFormat:@"%zd小时前",comps.hour];
                }else if (comps.minute >= 1){
                    dateStr = [NSString stringWithFormat:@"%zd分钟前",comps.minute];
                }else{
                    dateStr = @"刚刚";
                }
            }else if (date.isYesterday){
                fmt_.dateFormat = @"昨天hh:mm";
                dateStr = [fmt_ stringFromDate:date];
                
            }else if (date.isTomorrow){
                fmt_.dateFormat = @"明天hh:mm";
                dateStr = [NSString stringWithFormat:@"%@",[fmt_ stringFromDate:date]];
            }else{
                
                fmt_.dateFormat = @"MM-dd hh:mm";
                dateStr = [NSString stringWithFormat:@"%@",[fmt_ stringFromDate:date]];
            }
        }else{
            
            fmt_.dateFormat = @"yyyy-MM-dd-hh:mm";
        }
        
        return dateStr.length > 0 ? dateStr:@"";
}

@end
