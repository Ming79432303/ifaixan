//
//  LGActivityUser.h
//  ifaxian
//
//  Created by ming on 16/12/17.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGActivityUser : NSObject
/**
 *  用户名
 */
@property(nonatomic, copy) NSString *username;
/**
 *  昵称
 */
@property(nonatomic, copy) NSString *display_name;
@end
