//
//  NSString+CZPath.h
//
//  Created by ming on 16/6/10.
//  Copyright © 2016年 ming All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LGPath)

/// 给当前文件追加文档路径
- (NSString *)lg_appendDocumentDir;

/// 给当前文件追加缓存路径
- (NSString *)lg_appendCacheDir;

/// 给当前文件追加临时路径
- (NSString *)lg_appendTempDir;

@end
