
//
//  NSString+LGMessgesStringSize.m
//  QQ聊天模拟
//
//  Created by ming on 19/7/16.
//  Copyright © 2016年 ming. All rights reserved.
//
#define ufont [UIFont systemFontOfSize:12]
#import "NSString+LGStringSize.h"

@implementation NSString (LGStringSize)

- (CGRect)sizeOfTextWithMaxSize:(CGSize)maxSize font:(UIFont *)font
{
    NSDictionary * attr = @{NSFontAttributeName:ufont};
    
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil];

}
+ (CGRect)sizeWithText:(NSString *)text maxSize:(CGSize)maxSize font:(UIFont *)font
{
    return [text sizeOfTextWithMaxSize:maxSize font:ufont];
   
}
@end
