//
//  LGSetingItem.m
//  ifaxian
//
//  Created by ming on 16/12/10.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGSetingItem.h"

@implementation LGSetingItem

+(instancetype)setingTitle:(NSString *)title detail:(NSString *)detail;{
    
    LGSetingItem *item = [[self alloc] init];
    item.title = title;
    item.detail = detail;
    
    
    return item;
}

@end
