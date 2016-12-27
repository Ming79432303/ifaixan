//
//  LGAliYunOss.m
//  aliyunoss
//
//  Created by ming on 16/11/23.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGAliYunOssUpload.h"
#import <AliyunOSSiOS/OSSService.h>
#import <MJExtension.h>
#import "LGAliAccessToken.h"
#import <AliyunOSSiOS/OSSService.h>
@implementation LGAliYunOssUpload
/**
 *  根据文件路径上传文件
 *
 *  @param filePath   文件的路径
 *  @param fileName   文件的名称
 *  @param bucketName 容器的名称
 *  @param completion 是否上传成功回调
 */
-(void)uploadfilePath:(NSString *)filePath fileName:(NSString *)fileName bucketName:(NSString *)bucketName completion:(void(^)(BOOL isSuccess))completion{
    
#warning 待做
    //    需要注意，由于苹果的限制，后台上传只支持直接上传文件，所以，SDK目前只在 putObject 接口，且只在 设置 fileURL 上传时，支持后台传输服务。所需操作步骤如下：
    //
    //    1. 初始化OSSClient时，设置 configuration 支持后台：
    //
    //    ...
    //    conf.enableBackgroundTransmitService = YES;
    //    conf.backgroundSesseionIdentifier = @"com.xxx.xxx";
    //    ...
    //
    //    2. 在 AppDelegate.m 文件中，声明并实现如下方法：
    //
    //    - (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler {
    //        NSLog(@"application - handler event handler: %@", identifier);
    //
    //        completionHandler(); // 这个调用一定要记得加上
    //    }
    //
    //    3. 上传文件时，必须是设置 文件URL 来上传：
    //
    //    putRequest.uploadingFileURL = [NSURL fileURLWithPath:@"xxxx/xxxx.img"];
    
    
 
    //
    //    // 可选字段，可不设置
    //    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
    //        // 当前上传段长度、当前已经上传总长度、一共需要上传的总长度
    //        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    //    };
    //
    //    // 以下可选字段的含义参考： https://docs.aliyun.com/#/pub/oss/api-reference/object&PutObject
    //    // put.contentType = @"";
    //    // put.contentMd5 = @"";
    //    // put.contentEncoding = @"";
    //    // put.contentDisposition = @"";
    //
    //     //put.objectMeta = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"value1", @"x-oss-meta-name1", nil]; // 可以在上传时设置元信息或者其他HTTP头部
    //
    //    OSSTask * putTask = [client putObject:put];
    //
    //    [putTask continueWithBlock:^id(OSSTask *task) {
    //        if (!task.error) {
    //            OSSPutObjectResult * result = task.result;
    //            NSLog(@"Result - requestId: %@, headerFields: %@, servercallback: %@",
    //                  result.requestId,
    //                  result.httpResponseHeaderFields,
    //                  result.serverReturnJsonString);
    //            NSLog(@"upload object success!URL-----%@%@",url,key);
    //        } else {
    //            NSLog(@"upload object failed, error: %@" , task.error);
    //        }
    //        return nil;
    //    }];
    //    NSString * publicURL = nil;
    //
    
    
    //    NSString * publicURL = nil;
    ///如果Bucket或Object是公共可读的，那么调用一下接口，获得可公开访问Object的URL：
    // sign public url
    //OSSTask *task = [client presignPublicURLWithBucketName:@"79432303"
    //withObjectKey:@"123"];
    //  OSSTask  *task = [client presignPublicURLWithBucketName:@"<79432303>"
    //                                    withObjectKey:@"123.png"];
    //    if (!task.error) {
    //        publicURL = task.result;
    //        NSLog(@"%@",publicURL);
    //    } else {
    //        NSLog(@"sign url error: %@", task.error);
    //    }
    
    //    id<OSSCredentialProvider> credentia = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:@"<StsToken.AccessKeyId>" secretKeyId:@"<StsToken.SecretKeyId>" securityToken:@"<StsToken.SecurityToken>"];
    //
    //    client = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credentia];
    //
    //    client.credentialProvider = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:@"<StsToken.AccessKeyId>" secretKeyId:@"<StsToken.SecretKeyId>" securityToken:@"<StsToken.SecurityToken>"];

    id<OSSCredentialProvider>  credential = [self getCredential];
    NSString *endpoint = @"https://oss-cn-shanghai.aliyuncs.com";
    // 由阿里云颁发的AccessKeyId/AccessKeySecret构造一个CredentialProvider。
    // 明文设置secret的方式建议只在测试时使用，更多鉴权模式请参考后面的访问控制章节。
    // Do any additional setup after loading the view, typically from a nib.
    OSSClientConfiguration * conf = [OSSClientConfiguration new];
    conf.maxRetryCount = 3; // 网络请求遇到异常失败后的重试次数
    conf.timeoutIntervalForRequest = 30; // 网络请求的超时时间
    conf.timeoutIntervalForResource = 24 * 60 * 60; // 允许资源传输的最长时间
    
    OSSClient * client = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential];
    
    [self uploadFile:filePath fileName:fileName client:client completion:completion];
    
}
/**
 *  根据文件二进制数据上传文件
 *
 *  @param data       文件的二进制数
 *  @param fileName   文件的名称
 *  @param bucketName 容器的名字
 *  @param cmpletion  上传成功回调
 */
-(void)uploadfileData:(NSData *)data fileName:(NSString *)fileName bucketName:(NSString *)bucketName completion:(void(^)(BOOL isSuccess))cmpletion{
 
    id<OSSCredentialProvider>  credential = [self getCredential];
    NSString *endpoint = @"https://oss-cn-shanghai.aliyuncs.com";
    // 由阿里云颁发的AccessKeyId/AccessKeySecret构造一个CredentialProvider。
    // 明文设置secret的方式建议只在测试时使用，更多鉴权模式请参考后面的访问控制章节。
    // Do any additional setup after loading the view, typically from a nib.
    OSSClientConfiguration * conf = [OSSClientConfiguration new];
    conf.maxRetryCount = 3; // 网络请求遇到异常失败后的重试次数
    conf.timeoutIntervalForRequest = 30; // 网络请求的超时时间
    conf.timeoutIntervalForResource = 24 * 60 * 60; // 允许资源传输的最长时间
    
    OSSClient * client = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential];
    [self uploadFileData:data fileName:fileName client:client completion:cmpletion];

    
}


/**
 *  根据文件二进制数据上传文件
 *
 *  @param data       文件的二进制数
 *  @param fileName   文件的名称
 *  @param bucketName 容器的名字
 *  @param cmpletion  上传成功回调
 */
- (id<OSSCredentialProvider>)getCredential{
    
    id<OSSCredentialProvider> credential = [[OSSFederationCredentialProvider alloc] initWithFederationTokenGetter:^OSSFederationToken * {
        // 构造请求访问您的业务server
        NSURL * urlk = [NSURL URLWithString:@"http://wap52.cn/app-server/sts.php"];
        NSURLRequest * request = [NSURLRequest requestWithURL:urlk];
        OSSTaskCompletionSource * tcs = [OSSTaskCompletionSource taskCompletionSource];
        NSURLSession * session = [NSURLSession sharedSession];
        
        // 发送请求
        NSURLSessionTask * sessionTask = [session dataTaskWithRequest:request
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                        if (error) {
                                                            [tcs setError:error];
                                                            return;
                                                        }
                                                        [tcs setResult:data];
                                                    }];
        [sessionTask resume];
        // 需要阻塞等待请求返回
        [tcs.task waitUntilFinished];
        // 解析结果
        if (tcs.task.error) {
            NSLog(@"get token error: %@", tcs.task.error);
            return nil;
        } else {
            // 返回数据是json格式，需要解析得到token的各个字段
            NSDictionary * object = [NSJSONSerialization JSONObjectWithData:tcs.task.result
                                                                    options:kNilOptions
                                                                      error:nil];
            LGAliAccessToken *accessToken = [LGAliAccessToken mj_objectWithKeyValues:object];
            
            OSSFederationToken * token = [OSSFederationToken new];
            token.tAccessKey = accessToken.AccessKeyId;
            token.tSecretKey = accessToken.AccessKeySecret;
            token.tToken = accessToken.SecurityToken;
            token.expirationTimeInGMTFormat = accessToken.Expiration;
            return token;
        }
    }];
    

    return   credential;
    
}
- (void)uploadFile:(NSString *)filePath fileName:(NSString *)fileName client:(OSSClient *)client completion:(void(^)(BOOL isSuccess))completion{
    
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    // 必填字段
    put.bucketName = @"79432303";
    put.objectKey = fileName;
    // 设置Content-Type，可选
    //put.contentType = @"application/octet-stream";
    if (!filePath.length) {
        return;
    }
    put.uploadingFileURL = [NSURL fileURLWithPath:filePath];
    // put.uploadingData = <NSData *>; // 直接上传NSData
    // 可选字段，可不设置
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        // 当前上传段长度、当前已经上传总长度、一共需要上传的总长度
        double progrss = (totalByteSent * 1.0/totalBytesExpectedToSend) * 100;
        if ([self.delegate respondsToSelector:@selector(aliyunOssUploa:Progress:)]) {
            [self.delegate aliyunOssUploa:self Progress:progrss];
        }
    };
    OSSTask * putTask = [client putObject:put];
    [putTask continueWithBlock:^id(OSSTask *task) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (!task.error) {
                completion(YES);
            } else {
                LGLog(@"upload object failed, error: %@" , task.error);
                completion(NO);
            }

        });

        
                return nil;
    }];
}
- (void)uploadFileData:(NSData *)data fileName:(NSString *)fileName client:(OSSClient *)client completion:(void(^)(BOOL isSuccess))completion{
    
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    // 必填字段
    put.bucketName = @"79432303";
    put.objectKey = fileName;
    put.uploadingData = data; // 直接上传NSData
    // 可选字段，可不设置
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        // 当前上传段长度、当前已经上传总长度、一共需要上传的总长度
        double progrss = (totalByteSent * 1.0/totalBytesExpectedToSend) * 100;
        if ([self.delegate respondsToSelector:@selector(aliyunOssUploa:Progress:)]) {
            [self.delegate aliyunOssUploa:self Progress:progrss];
        }
        
       
    };
    OSSTask * putTask = [client putObject:put];
    [putTask continueWithBlock:^id(OSSTask *task) {
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            if (!task.error) {
                
                completion(YES);
                
            } else {
                
                completion(NO);
            }
            
        });
        
        return nil;
    }];
}
@end
