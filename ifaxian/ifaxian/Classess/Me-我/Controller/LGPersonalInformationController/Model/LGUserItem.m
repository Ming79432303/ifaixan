//
//  LGUserItem.m
//  ifaxian
//
//  Created by ming on 16/12/13.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGUserItem.h"

@implementation LGUserItem
+ (instancetype)userGruopTitle:(NSString *)title userInfo:(NSArray *)userInfo{
    LGUserItem *item = [[self alloc] init];
    
    item.title = title;
    item.userInfos = userInfo;

    return item;
    
}
@end
