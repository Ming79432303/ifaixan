//
//  LGOther.h
//  ifaxian
//
//  Created by ming on 16/12/14.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  用户个人中心其他界面模型
 */
@interface LGOther : NSObject
/**
 *  图片的名字
 */
@property(nonatomic, copy) NSString *imageName;
/**
 *  标题
 */
@property(nonatomic, copy) NSString *title;
/**
 *  子标题
 */
@property(nonatomic, copy) NSString *detail;
/**
 *  模型类方法
 *
 *  @param imageName 图片的名字
 *  @param title     标题
 *
 *  @return 模型
 */
+(instancetype)otherImageName:(NSString *)imageName title:(NSString *)title;
@end
