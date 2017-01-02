//
//  LGShow.h
//  ifaxian
//
//  Created by ming on 16/11/28.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  发现界面分类展示图片模型
 */
@interface LGShow : NSObject
/**
 *  标题
 */
@property(nonatomic, copy) NSString *title;
/**
 *  分类的数据四张图片
 */
@property(nonatomic, strong) NSArray *posts;
+(instancetype)showTitle:(NSString *)title posts:(NSArray *)post;
@end
