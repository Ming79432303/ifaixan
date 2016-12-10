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


-(void)accountSave{
    
    
   
    
  NSString *file =  [fileName lg_appendDocumentDir];
    
    NSLog(@"%@",file);
    NSData *data  = [self mj_JSONData];
    
    [data writeToFile:file atomically:YES];
}

- (void)readAccount{
     NSString *file =  [fileName lg_appendDocumentDir];
    
  NSData  *accountData = [[NSData alloc] initWithContentsOfFile:file];
    if (accountData == nil) {
        return;
    }
    NSDictionary *accountDict = [NSJSONSerialization JSONObjectWithData:accountData options:0 error:nil];
    
    [self mj_setKeyValues:accountDict];
  
    
}
- (instancetype)init{
    if (self = [super init]) {
        [self readAccount];
        
    }
    
    return self;
}
@end
