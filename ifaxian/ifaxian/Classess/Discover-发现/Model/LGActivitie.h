//
//  LGActivitie.h
//  ifaxian
//
//  Created by ming on 16/12/17.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LGActivityUser.h"
@interface LGActivitie : NSObject
/**
 *  用户发表动态的类型，评论或者发布一条动态
 */
@property(nonatomic, copy) NSString *type;
/**
 *  发布的时间
 */
@property(nonatomic, copy) NSString *time;
/**
 *  发表的动作评论或者发布一条动态
 */
@property(nonatomic, copy) NSString *action;
/**
 *  发布的内容
 */
@property(nonatomic, copy) NSString *content;
/**
 *  发布的用户
 */
@property(nonatomic, strong) LGActivityUser *user;
/**
 *  用正则表达式匹配出来的（链接+标题）数组
 */
@property(nonatomic, strong) NSArray *linkAndText;;
/**
 *  发布的第一张图
 */
@property(nonatomic, copy) NSString *imageUrl;
/**
 *  发布的内容
 */
@property(nonatomic, copy) NSString *contenText;
/**
 *  行高
 */
@property(nonatomic, assign) CGFloat rowHeight;
/**
 *  未知
 */
@property(nonatomic, copy) NSString *secondary_item_id;
typedef NS_ENUM(NSInteger , LGActivitieType) {
    LGActivitieNew,//新发布
    LGActivitieComment,//新的评论
};
@end
