//
//  NSString+LGRequestBasiPath.m
//  ifaxian
//
//  Created by ming on 16/11/27.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "NSString+LGRequestBasiPath.h"

@implementation NSString (LGRequestBasiPath)
+(NSString *)requestBasiPathAppend:(NSString *)path{
    
    return [NSString stringWithFormat:@"%@%@",LGBasiRequestUrl,path];
    
}

-(NSString *)requestBasiPathAppend:(NSString *)path{
    
    return [NSString stringWithFormat:@"%@%@",LGBasiRequestUrl,self];
    
}

- (NSString *)lg_getuserAvatar{
    
     NSString * userAvatar = [NSString stringWithFormat:@"%@ifaxian/avatars/%@lg_user_avatar.jpg",LGbuckeUrl,self];
    return userAvatar;
}
@end
