//
//  NSString+HSYFileSize.m
//  百思不得姐
//
//  Created by ming on 16/11/5.
//  Copyright © 2016年 Apple_Lzzy27. All rights reserved.
//

#import "NSString+LGFileSize.h"

@implementation NSString (LGYFileSize)

- (unsigned long long)lg_fileSize{
    
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    unsigned long long size = 0;
    if ([[mgr attributesOfItemAtPath:self error:nil].fileType isEqual:@"NSFileTypeRegular"]) {
        return [mgr attributesOfItemAtPath:self error:nil].fileSize;
        
    }else{
        
        NSDirectoryEnumerator *fileEnumerator = [mgr enumeratorAtPath:self];
        
        for (NSString *suPath in fileEnumerator) {
            NSString *filePath = [self stringByAppendingPathComponent:suPath];
            
            size += [mgr  attributesOfItemAtPath:filePath error:nil].fileSize;
        }
        
    }
    
    return size;
}
//
//- (void)getSize2{
//    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
//
//    NSString *file =  [path stringByAppendingPathComponent:@"default"];
//    // NSLog(@"%@",file);
//    //NSInteger size = [SDImageCache sharedImageCache].getSize;
//    NSFileManager *mgr = [NSFileManager defaultManager];
//
//
//
//
//    NSArray *array = [mgr subpathsOfDirectoryAtPath:file error:nil];
//    unsigned long long size = 0;
//    for (NSString *suPathName in array) {
//        //fileSize
//        NSString *filePath = [file stringByAppendingPathComponent:suPathName];
//        size += [mgr attributesOfItemAtPath:filePath error:nil].fileSize;
//
//
//
//
//        // NSDirectoryEnumerator *fileEnumerator = [_fileManager enumeratorAtPath:self.diskCachePath];
//        //        for (NSString *fileName in fileEnumerator) {
//        //            NSString *filePath = [self.diskCachePath stringByAppendingPathComponent:fileName];
//        //            NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
//        //            size += [attrs fileSize];
//        //        }
//    }
//
//
//
//    NSLog(@"%zd---%zd",size,[SDImageCache sharedImageCache].getSize);
//}


@end
