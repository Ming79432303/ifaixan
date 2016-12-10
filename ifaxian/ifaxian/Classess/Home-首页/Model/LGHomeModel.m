//
//  LGHomeModel.m
//  ifaxian
//
//  Created by ming on 16/12/6.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGHomeModel.h"
#import "NSString+LGRegularExpressions.h"
@implementation LGHomeModel

- (CGFloat)rowHeight{
    
        NSLog(@"%@",self.title);
    if (_rowHeight == 0){
        
        
        CGFloat height = 0;
        height += [self.title boundingRectWithSize:CGSizeMake(LGScreenW - 2*LGCommonMargin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15]} context:nil].size.height;
        CGFloat iconH = 35;
        CGFloat timeH = 17;
        height += iconH;
        height += timeH;
        height += 5 * LGCommonMargin;
 
        if (self.excerpt.length) {
            height += [self.excerpt boundingRectWithSize:CGSizeMake(LGScreenW - 2 * LGCommonMargin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:13]} context:nil].size.height;
        }
        
        if (self.images.count >= 1) {
            if (self.images.count == 1) {
            
                height += 200;
            }else {
                  height += ((self.images.count - 1)/3 +1) * LGHomeImageViewItemWH;
            }
            
            
            
        }
    

        _rowHeight = height;
    }
    NSLog(@"%f",_rowHeight);
    return _rowHeight;
}


- (NSString *)description{

    return [[NSString lg_regularExpression:self.excerpt] stringByReplacingOccurrencesOfString:@" [&hellip;]" withString:@"..."];
}

//- (NSArray *)images{
//    
//    if (self.content.length) {
//     _images = [self.content lg_getImages];
//    }
//    
//    return _images;
//}
- (void)setContent:(NSString *)content{
    
    [super setContent:content];
    
    if (self.content.length) {
        _images = [self.content lg_getImages];
    }
    
 

    
}


@end
