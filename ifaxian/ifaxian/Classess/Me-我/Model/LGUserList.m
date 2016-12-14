//
//  LGUserList.m
//  ifaxian
//
//  Created by ming on 16/12/13.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGUserList.h"

@implementation LGUserList

+ (instancetype)userTitle:(NSString *)title content:(NSString *)content parameter:(NSString *)parameter{
    LGUserList *list = [[self alloc] init];
    list.title = title;
    list.content = content;
    list.parameter = parameter;
    return list;
}

@end
