//
//  NSString+CZBase64.m
//
//  Created by ming on 16/6/7.
//  Copyright © 2016年 ming All rights reserved.
//

#import "NSString+LgBase64.h"

@implementation NSString (CZBase64)

- (NSString *)lg_base64Encode {
    
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    return [data base64EncodedStringWithOptions:0];
}

- (NSString *)lg_base64Decode {
    
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:0];
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
