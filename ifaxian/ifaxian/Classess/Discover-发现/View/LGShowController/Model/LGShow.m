//
//  LGShow.m
//  ifaxian
//
//  Created by ming on 16/11/28.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGShow.h"

@implementation LGShow
+(instancetype)showTitle:(NSString *)title posts:(NSArray *)post;{
    LGShow *show = [[self alloc] init];
    
    show.title = title;
    show.posts = post;
    
    
    return show;
    
    
}
@end
