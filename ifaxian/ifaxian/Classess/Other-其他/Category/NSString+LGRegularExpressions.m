//
//  NSString+LGRegularExpressions.m
//  ifaxian
//
//  Created by ming on 16/11/24.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "NSString+LGRegularExpressions.h"

@implementation NSString (LGRegularExpressions)
//邮箱
+ (BOOL)lg_dateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
//密码
+ (BOOL)lg_datePassword:(NSString *)passWord
{
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}
//用户名
+ (BOOL)lg_dateUserName:(NSString *)name
{
    NSString *userNameRegex = @"^[A-Za-z0-9]{6,20}+$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    return [userNamePredicate evaluateWithObject:name];
}
+ (NSString *)lg_replaceUnicode:(NSString *)unicodeStr

{
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:NULL error:NULL];
  
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}

+ (NSString *)lg_regularExpression:(NSString *)text{
    
    NSString *urlString = text;
    NSError *error = NULL;
    //创建正则表达式
    NSString *pattern = @"<p>(.*?)</p>";
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    __block NSString *resultString;
    if (text.length < 6) {
        return @"";
    }
    [regex enumerateMatchesInString:urlString options:0 range:NSMakeRange(0, [urlString length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        if (flags != NSMatchingInternalError) {
            NSRange firstHalfRange = [result rangeAtIndex:0];
            if (firstHalfRange.length > 0) {
                NSRange resRang = NSMakeRange(firstHalfRange.location + 3, firstHalfRange.length-7);
                resultString = [urlString substringWithRange:resRang];
            }
        }
        *stop = YES;
    }];
    
    return resultString;
    
}

- (NSString *)lg_getImageUrl{
    
    NSString *urlString = self;
    NSError *error = NULL;
    //创建正则表达式
     NSString *pattern = @"(?<=img src=\\\")[^\"]*(?=\")";
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    __block NSString *resultString;
    [regex enumerateMatchesInString:urlString options:0 range:NSMakeRange(0, [urlString length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        if (flags != NSMatchingInternalError) {
            NSRange firstHalfRange = [result rangeAtIndex:0];
            if (firstHalfRange.length > 0) {
                NSRange resRang = NSMakeRange(firstHalfRange.location, firstHalfRange.length);
              
                resultString = [urlString substringWithRange:resRang];
            }
        }
        if (resultString.length) {
            
            *stop = YES;
        }
    }];
    
    return resultString;
    
}

- (NSString *)lg_getVideoUrl{
    
    NSString *urlString = self;
    NSError *error = NULL;
    //创建正则表达式
    NSString *pattern = @"https://.*?.mp4";
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    __block NSString *resultString;
    [regex enumerateMatchesInString:urlString options:0 range:NSMakeRange(0, [urlString length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        if (flags != NSMatchingInternalError) {
            NSRange firstHalfRange = [result rangeAtIndex:0];
            if (firstHalfRange.length > 0) {
                NSRange resRang = NSMakeRange(firstHalfRange.location, firstHalfRange.length);
                
                resultString = [urlString substringWithRange:resRang];
            }
        }
        *stop = YES;
    }];
    
    
    return resultString;
    
}

- (NSArray *)lg_getImages{
    
    
    NSString *urlString = self;
    NSError *error = NULL;
    //创建正则表达式
    //(?i)http://[^'\"]+
    NSString *pattern = @"(?<=img src=\\\")[^\"]*(?=\")";
    NSMutableArray *arrayM = [NSMutableArray array];
   __block int index = 0;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
 
    [regex enumerateMatchesInString:urlString options:0 range:NSMakeRange(0, [urlString length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        if (flags != NSMatchingInternalError) {
            NSRange firstHalfRange = [result rangeAtIndex:0];
            if (firstHalfRange.length > 0) {
                NSRange resRang = NSMakeRange(firstHalfRange.location, firstHalfRange.length);
             
               [arrayM addObject:[urlString substringWithRange:resRang]];
                index += 1;
            }
        }
        if (index == 6) {
               *stop = YES;
        }
    }];
    
    
    return arrayM;
    
}
- (NSArray *)lg_getAllImages{
    
    
    NSString *urlString = self;
    NSError *error = NULL;
    //创建正则表达式
    //(?i)http://[^'\"]+
    NSString *pattern = @"(?<=img src=\\\")[^\"]*(?=\")";
    NSMutableArray *arrayM = [NSMutableArray array];
    __block int index = 0;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    
    [regex enumerateMatchesInString:urlString options:0 range:NSMakeRange(0, [urlString length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        if (flags != NSMatchingInternalError) {
            NSRange firstHalfRange = [result rangeAtIndex:0];
            if (firstHalfRange.length > 0) {
                NSRange resRang = NSMakeRange(firstHalfRange.location, firstHalfRange.length);
                
                [arrayM addObject:[urlString substringWithRange:resRang]];
                index += 1;
            }
        }
        if (index == 9) {
            *stop = YES;
        }
    }];
    
    
    return arrayM;
    
}
//获得链接中的所有a标签
- (NSArray *)lg_get_lasA_Link_text{

    
    NSError *error = NULL;
    //创建正则表达式
    NSMutableArray *arrayM = [NSMutableArray array];
    NSString *pattern = @"<a href=\"[^\"]*\"[^>]*>(.*?)</a>";
     NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    [regex enumerateMatchesInString:self options:0 range:NSMakeRange(0, [self length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        if (flags != NSMatchingInternalError) {
            NSRange firstHalfRange = [result rangeAtIndex:0];
            if (firstHalfRange.length > 0) {
                NSRange resRang = NSMakeRange(firstHalfRange.location, firstHalfRange.length);
                
                [arrayM addObject:[self substringWithRange:resRang]];
            }
        }
    }];
    
  NSArray *array = [arrayM.lastObject getLink_text];
    return array;
    
}

//传入一个a标签
- (NSArray *)getLink_text{
    NSError *error = NULL;
    NSString *pattern = @"<a href=\"(.*?)\".*?>(.*?)</a>";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSTextCheckingResult *result = [regex firstMatchInString:self options:0 range:NSMakeRange(0, self.length)];
    ;
    
    NSMutableArray *arrayM = [NSMutableArray array];
    NSString *link = [self substringWithRange:[result rangeAtIndex:1]];
    [arrayM addObject:link];
    NSString *text = [self substringWithRange:[result rangeAtIndex:2]];
    [arrayM addObject:text];
    

    return  arrayM;
    
}

@end
