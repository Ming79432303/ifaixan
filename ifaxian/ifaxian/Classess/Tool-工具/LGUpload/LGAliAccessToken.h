//
//  LGAliAccessToken.h
//  aliyunoss
//
//  Created by ming on 16/11/12.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGAliAccessToken : NSObject
@property(nonatomic, copy) NSString *AccessKeyId;
@property(nonatomic, copy) NSString *AccessKeySecret;
@property(nonatomic, copy) NSString *Expiration;
@property(nonatomic, copy) NSString *SecurityToken;

@end
