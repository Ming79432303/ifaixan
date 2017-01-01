//
//  LGHeaderModel.h
//  ifaxian
//
//  Created by ming on 16/12/31.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGHeaderModel : NSObject
@property(nonatomic, copy) UIImage *image;
@property(nonatomic, copy) NSString *url;
+ (instancetype)headerImage:(UIImage *)image url:(NSString *)url;
@end
