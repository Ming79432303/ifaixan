//
//  LGAuthor.h
//  ifaxian
//
//  Created by Apple_Lzzy27 on 16/11/17.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGAuthor : NSObject
@property(nonatomic, copy) NSString *first_name;
/**
 *  名字
 */
@property(nonatomic, copy) NSString *nickname;
@property(nonatomic, copy) NSString *name;
/**
 *  路径
 */
@property(nonatomic, copy) NSString *slug;
@property(nonatomic, copy) NSString *ID;

@end
