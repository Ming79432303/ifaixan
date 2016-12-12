//
//  LGShareImage.m
//  ifaxian
//
//  Created by ming on 16/11/30.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGShareImage.h"

@implementation LGShareImage
- (NSString *)imageUrl{
//    
//    if (_imageUrl.length) {
//        
//        return _imageUrl;
//    }
    _imageUrl = [self.content lg_getImageUrl];
    
    return _imageUrl;
}

@end
