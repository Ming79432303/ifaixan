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
@property(nonatomic, copy) NSString *type;
@property(nonatomic, copy) NSString *time;
@property(nonatomic, copy) NSString *action;
@property(nonatomic, copy) NSString *content;
@property(nonatomic, strong) LGActivityUser *user;
@property(nonatomic, strong) NSArray *linkAndText;;
@property(nonatomic, copy) NSString *imageUrl;
@property(nonatomic, copy) NSString *contenText;
@property(nonatomic, assign) CGFloat rowHeight;
@property(nonatomic, copy) NSString *secondary_item_id;
typedef NS_ENUM(NSInteger , LGActivitieType) {
    LGActivitieNew,//新发布
    LGActivitieComment,//新的评论
};
@end
