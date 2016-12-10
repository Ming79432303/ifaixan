//
//  NSString+LGMessgesStringSize.h
//  QQ聊天模拟
//
//  Created by ming on 19/7/16.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (LGStringSize)

- (CGRect)sizeOfTextWithMaxSize:(CGSize)maxSize font:(UIFont *)font;
+ (CGRect)sizeWithText:(NSString *)text maxSize:(CGSize)maxSize font:(UIFont *)font;

@end
