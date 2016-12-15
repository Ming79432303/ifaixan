//
//  LGOther.m
//  ifaxian
//
//  Created by ming on 16/12/14.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGOther.h"

@implementation LGOther

+(instancetype)otherImageName:(NSString *)imageName title:(NSString *)title {
    
    LGOther *other = [[self alloc] init];
    other.imageName = imageName;
    other.title = title;
    return other;
    
}

@end
