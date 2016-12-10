//
//  NSString+lgPath.m
//
//  Created by ming on 16/6/10.
//  Copyright © 2016年 ming All rights reserved.
//

#import "NSString+LGPath.h"

@implementation NSString (LGPath)

- (NSString *)lg_appendDocumentDir {
    NSString *dir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    
    return [dir stringByAppendingPathComponent:self.lastPathComponent];
}

- (NSString *)lg_appendCacheDir {
    NSString *dir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    
    return [dir stringByAppendingPathComponent:self.lastPathComponent];
}

- (NSString *)lg_appendTempDir {
    NSString *dir = NSTemporaryDirectory();
    
    return [dir stringByAppendingPathComponent:self.lastPathComponent];
}

@end
