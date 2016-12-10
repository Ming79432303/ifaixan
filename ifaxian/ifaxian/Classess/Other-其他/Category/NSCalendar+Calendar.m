//
//  NSCalendar+Calendar.m
//  时间处理
//
//  Created by ming on 16/11/8.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "NSCalendar+LGExtension.h"

@implementation NSCalendar (LGExtension)
+ (instancetype)lg_calendar{
    if ( [NSCalendar respondsToSelector:@selector(calendarWithIdentifier:)]) {//ios7后的
        return [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    }else{//ios7前的
        return [NSCalendar currentCalendar];
    }    
}

@end
