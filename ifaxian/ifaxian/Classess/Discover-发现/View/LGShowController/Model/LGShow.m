//
//  LGShow.m
//  ifaxian
//
//  Created by ming on 16/11/28.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGShow.h"

@interface  LGShow()<NSCoding>

@end

@implementation LGShow
+(instancetype)showTitle:(NSString *)title posts:(NSArray *)post;{
    LGShow *show = [[self alloc] init];
    
    show.title = title;
    show.posts = post;
    
    
    return show;
    
    
}

//归档
-(void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.posts forKey:@"posts"];
    
    
}
//反归档
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.posts = [aDecoder decodeObjectForKey:@"posts"];
    }
    
    return self;
}


@end
