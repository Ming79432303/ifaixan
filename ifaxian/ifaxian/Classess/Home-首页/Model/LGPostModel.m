//
//  LGPostModel.m
//  ifaxian
//
//  Created by Apple_Lzzy27 on 16/11/17.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGPostModel.h"
#import "NSString+LGStringSize.h"
#import "NSCalendar+LGExtension.h"
#import "NSDate+myDate.h"

@implementation LGPostModel

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
- (NSString *)imageUrl{
    
        if (_imageUrl.length) {
    
            return _imageUrl;
        }
    _imageUrl = [self.content lg_getImageUrl];
    
    return _imageUrl;
}
//归档
-(void)encodeWithCoder:(NSCoder *)aCoder{
    
   
    [aCoder encodeObject:self.imageUrl forKey:@"imageUrl"];
    
    
}
//反归档
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        
      
        self.imageUrl = [aDecoder decodeObjectForKey:@"imageUrl"];
    }
    
    return self;
}

@end
