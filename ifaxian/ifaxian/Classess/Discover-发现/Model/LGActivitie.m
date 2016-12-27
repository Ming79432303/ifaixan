//
//  LGActivitie.m
//  ifaxian
//
//  Created by ming on 16/12/17.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGActivitie.h"
#import "NSCalendar+LGExtension.h"
#import "NSDate+myDate.h"
@implementation LGActivitie
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

- (NSString *)time{
    
    //时间的转换
    //2016-11-08 10:08:02
    
    
    fmt_.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [fmt_ dateFromString:_time];
    
    
    //NSString转NSDate
//    NSString *dateString = @"2016-06-01 18:00:00";

//    NSDate *date = [formatter dateFromString:dateString];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] init];
    timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSTimeInterval interval = [timeZone secondsFromGMT];
    NSDate *GMTDate = [date dateByAddingTimeInterval:interval * 2];
    //注：北京时间在iOS的timeZone对照表里面并没有，中国标准时间在里面存的是上海时间，也就是上面的Asia/Shanghai，因为是转换到GMT所以interval前面加了负号
    timeZone = [NSTimeZone systemTimeZone];//获取本地时区
    interval = [timeZone secondsFromGMT];
    NSDate *localDate = [GMTDate dateByAddingTimeInterval:-interval];//localDate
    //注意：这里是从GMT时间转换为本地时间所以interval不变号，此时localData的值为2016-06-01 10:00:00 +0000
    NSString *localDateString = [fmt_ stringFromDate:localDate];
   
//    //NSDate转回NSString时根据本地时区减去之前加上的4个小时，此时localDateString的值为2016-06-1 06:00:00
    
    
    
    
    
    
  
    
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
    NSDateComponents *comps = [canlendar_ components:unit fromDate:localDate toDate:[NSDate date] options:0];
    //ios8的方法低版本无法运行
    
    //所以需要自己写
    
    NSString *dateStr;
    
    if (localDate.isThisYear) {
        if (localDate.isToday) {
            if (comps.hour >= 1) {
                dateStr = [NSString stringWithFormat:@"%zd小时前",comps.hour];
            }else if (comps.minute >= 1){
                dateStr = [NSString stringWithFormat:@"%zd分钟前",comps.minute];
            }else{
                dateStr = @"刚刚";
            }
        }else if (localDate.isYesterday){
            fmt_.dateFormat = @"昨天hh:mm";
            dateStr = [fmt_ stringFromDate:date];
            
        }else if (localDate.isTomorrow){
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

- (NSArray *)linkAndText{
    
    if (_linkAndText.count) {
        return _linkAndText;
    }
    
    NSArray *array = [_action lg_get_lasA_Link_text];
    _linkAndText = array;
    
    return _linkAndText;
}
- (NSString *)imageUrl{
    
    if (_imageUrl.length) {
        
        return _imageUrl;
    }
    _imageUrl = [self.content lg_getImageUrl];
    
    return _imageUrl;
}

- (NSString *)contenText{
    
    if (_contenText.length) {
        return _contenText;
    }
    
    NSString *text = [NSString lg_regularExpression:_content];
    
    _contenText = text;
    return _contenText;
}


- (CGFloat )rowHeight{
    
    if (_rowHeight > 0) {
        return _rowHeight;
    }
    CGFloat actionW = LGScreenW - LGCommonMargin - LGAvatarHeight - 3 * LGCommonSmallMargin;
    _rowHeight += LGAvatarHeight;
    NSString *actionStr;
    if ([self.type isEqualToString:@"new_blog_comment"]) {
        actionStr =  @"发布了一条评论";
        _rowHeight += [self.contenText boundingRectWithSize:CGSizeMake(actionW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size.height + LGCommonMargin;
       
    }else if([self.type isEqualToString:@"new_blog_post"]){
        //发布了一条动态
        actionStr = @"发布了一条动态";
    }
//
//    NSString *action = [NSString stringWithFormat:@"%@%@",_time,actionStr];
//    
//    
    
    
 // _rowHeight += [action boundingRectWithSize:CGSizeMake(actionW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size.height;
    NSString *titleStr = [NSString stringWithFormat:@"#%@",self.linkAndText.lastObject];
    _rowHeight += [titleStr boundingRectWithSize:CGSizeMake(actionW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height;
    
    if (self.imageUrl.length) {
        _rowHeight += 168 + LGCommonMargin;
    }
    
    _rowHeight += 3 * LGCommonMargin;
   
    return _rowHeight;
}


@end
