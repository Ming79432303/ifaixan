//
//  LGOther.h
//  ifaxian
//
//  Created by ming on 16/12/14.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGOther : NSObject
@property(nonatomic, copy) NSString *imageName;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *detail;
+(instancetype)otherImageName:(NSString *)imageName title:(NSString *)title;
@end
