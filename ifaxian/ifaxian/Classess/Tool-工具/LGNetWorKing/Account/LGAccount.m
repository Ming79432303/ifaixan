//
//  LGAccount.m
//  ifaxian
//
//  Created by ming on 16/11/20.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGAccount.h"
NSString *fileName = @"account.json";
@implementation LGAccount

//保存账户数据
-(void)accountSave{
    NSString *file =  [fileName lg_appendDocumentDir];
    NSData *data  = [self mj_JSONData];
    [data writeToFile:file atomically:YES];
}
//读取账户数据
- (void)readAccount{
    NSString *file =  [fileName lg_appendDocumentDir];
    
    NSData  *accountData = [[NSData alloc] initWithContentsOfFile:file];
    if (accountData == nil) {
        return;
    }
    NSDictionary *accountDict = [NSJSONSerialization JSONObjectWithData:accountData options:0 error:nil];
    
    [self mj_setKeyValues:accountDict];
  
    
}
//在初始化方法了加载模型数据
- (instancetype)init{
    if (self = [super init]) {
        [self readAccount];
    }
    return self;
}
@end
