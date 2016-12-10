//
//  NSDate+myDate.m
//  时间处理
//
//  Created by ming on 16/11/8.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "NSDate+myDate.h"

@implementation NSDate (myDate)

///是否是今天
- (BOOL)isToday{
      // 获得年月日元素
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    
    NSCalendar *calendar = [NSCalendar lg_calendar];
    // 获得传入的年月日元素
  NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    //获得当前时间的年月日元素
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    return selfCmps.year = nowCmps.year && selfCmps.month == nowCmps.month && selfCmps.day == nowCmps.day;
}

- (BOOL)isYesterday{
    
    // self == 2015-10-31 23:07:08 -> 2015-10-31 00:00:00
    // now  == 2015-11-01 14:39:20 -> 2015-11-01 00:00:00
    //创建日期格式
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    ///拿到年月日
    fmt.dateFormat = @"yyyyMMdd";
    NSString *selfStr =  [fmt stringFromDate:self];
    NSString *nowStr = [fmt stringFromDate:[NSDate date]];
    NSDate *selfDate = [fmt dateFromString:selfStr];
    NSDate *nowDate = [fmt dateFromString:nowStr];
    
    //计算差值
    NSCalendar *calen = [NSCalendar lg_calendar];
    // 年月日元素
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *compos =  [calen components:unit fromDate:selfDate toDate:nowDate options:0];
    
    
    
    return compos.year == 0 && compos.month == 0 && compos.day == 1;
    
    
}

///是否是明天
- (BOOL)isTomorrow{
    
    // self == 2015-10-31 23:07:08 -> 2015-10-31 00:00:00
    // now  == 2015-11-01 14:39:20 -> 2015-11-01 00:00:00
    //创建日期格式
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    ///拿到年月日
    fmt.dateFormat = @"yyyyMMdd";
    NSString *selfStr =  [fmt stringFromDate:self];
    NSString *nowStr = [fmt stringFromDate:[NSDate date]];
    NSDate *selfDate = [fmt dateFromString:selfStr];
    NSDate *nowDate = [fmt dateFromString:nowStr];
    
    //计算差值
    NSCalendar *calen = [NSCalendar lg_calendar];
    // 年月日元素
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *compos =  [calen components:unit fromDate:selfDate toDate:nowDate options:0];
    
    
    
    return compos.year == 0 && compos.month == 0 && compos.day == -1;
    

}

//是否是今年
- (BOOL)isThisYear{
    // 获得年月日元素

    
    NSCalendar *calendar = [NSCalendar lg_calendar];
    // 获得传入的年月日元素
    NSDateComponents *selfCmps = [calendar components:NSCalendarUnitYear fromDate:self];
    //获得当前时间的年月日元素
    NSDateComponents *nowCmps = [calendar components:NSCalendarUnitYear fromDate:[NSDate date]];
    
    return selfCmps.year = nowCmps.year;

}


@end
