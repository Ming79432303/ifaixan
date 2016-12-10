//
//  LGcategories.h
//  ifaxian
//
//  Created by Apple_Lzzy27 on 16/11/17.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGCategories : NSObject
/**
 *  分类名称
 */
@property (nonatomic,copy) NSString *title;
/**
 *  分类路径
 */
@property (nonatomic,copy) NSString *slug;
/**
 *  分类id
 */
@property (nonatomic,copy) NSString *ID;

@property(nonatomic, copy) NSString *describe;

@end
