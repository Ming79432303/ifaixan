//
//  LGHeaderModel.m
//  ifaxian
//
//  Created by ming on 16/12/31.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGHeaderModel.h"

@implementation LGHeaderModel
//创建模型的类方法
+ (instancetype)headerImage:(UIImage *)image url:(NSString *)url{
    
    LGHeaderModel *header = [[self alloc] init];
    header.image = image;
    header.url = url;
    
    
    return header;
    
    
}
@end
