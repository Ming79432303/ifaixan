//
//  LGShow.h
//  ifaxian
//
//  Created by ming on 16/11/28.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGShow : NSObject
@property(nonatomic, copy) NSString *title;
@property(nonatomic, strong) NSArray *posts;
+(instancetype)showTitle:(NSString *)title posts:(NSArray *)post;
@end
