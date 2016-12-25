//
//  LGUserItem.h
//  ifaxian
//
//  Created by ming on 16/12/13.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGUserItem : NSObject
@property(nonatomic, copy) NSString *title;
@property(nonatomic, strong) NSArray *userInfos;
+ (instancetype)userGruopTitle:(NSString *)title userInfo:(NSArray *)userInfo; 
@end
