//
//  NSString+LGRequestBasiPath.h
//  ifaxian
//
//  Created by ming on 16/11/27.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LGRequestBasiPath)

//主url
+ (NSString *)requestBasiPathAppend:(NSString *)path;
//用户头像
- (NSString *)lg_getuserAvatar;
//主url
- (NSString *)requestBasiPathAppend:(NSString *)path;
@end
