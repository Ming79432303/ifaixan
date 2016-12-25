//
//  LGUserList.h
//  ifaxian
//
//  Created by ming on 16/12/13.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGUserList : NSObject
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *content;
@property(nonatomic, copy) NSString *parameter;
+ (instancetype)userTitle:(NSString *)title content:(NSString *)content parameter:(NSString *)parameter;
@end
