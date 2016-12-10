//
//  NSString+CZBase64.h
//
//  Created by ming on 16/6/7.
//  Copyright © 2016年 ming All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LGBase64)

/// 对当前字符串进行 BASE 64 编码，并且返回结果
- (NSString *)lg_base64Encode;

/// 对当前字符串进行 BASE 64 解码，并且返回结果
- (NSString *)lg_base64Decode;

@end
