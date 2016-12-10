//
//  NSDate+myDate.h
//  时间处理
//
//  Created by ming on 16/11/8.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSCalendar+LGExtension.h"
@interface NSDate (myDate)

///是否是今天
- (BOOL)isToday;
///是否是明天
- (BOOL)isTomorrow;
///是否为昨天
- (BOOL)isYesterday;
//是否是今年
- (BOOL)isThisYear;



@end
