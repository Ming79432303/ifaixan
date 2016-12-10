//
//  LGAliYunOss.h
//  aliyunoss
//
//  Created by ming on 16/11/23.
//  Copyright © 2016年 ming. All rights reserved.
//



#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class LGAliYunOssUpload;
@protocol LGAliYunOssUploadDelegate <NSObject>
/**
 *  文件上传的进度
 *
 *  @param upload
 *  @param progress 上传的进度0~100
 */
- (void)aliyunOssUploa:(LGAliYunOssUpload *)upload Progress:(CGFloat)progress;

@end

@interface LGAliYunOssUpload : NSObject
@property (nonatomic,weak) id<LGAliYunOssUploadDelegate>delegate;
/**
 *  根据文件路径上传文件
 *
 *  @param filePath   文件的路径
 *  @param fileName   文件的名称
 *  @param bucketName 容器的名称
 *  @param completion 是否上传成功回调
 */
-(void)uploadfilePath:(NSString *)filePath fileName:(NSString *)fileName bucketName:(NSString *)bucketName completion:(void(^)(BOOL isSuccess))completion;
/**
 *  根据文件二进制数据上传文件
 *
 *  @param data       文件的二进制数
 *  @param fileName   文件的名称
 *  @param bucketName 容器的名字
 *  @param cmpletion  上传成功回调
 */
-(void)uploadfileData:(NSData *)data fileName:(NSString *)fileName bucketName:(NSString *)bucketName completion:(void(^)(BOOL isSuccess))cmpletion;

@end

