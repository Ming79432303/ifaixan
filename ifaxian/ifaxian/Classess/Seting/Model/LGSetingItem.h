//
//  LGSetingItem.h
//  ifaxian
//
//  Created by ming on 16/12/10.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGSetingItem : NSObject
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *detail;

+(instancetype)setingTitle:(NSString *)title detail:(NSString *)detail;

@end
