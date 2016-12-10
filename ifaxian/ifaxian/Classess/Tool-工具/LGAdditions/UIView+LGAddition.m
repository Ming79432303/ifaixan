//
//  UIView+CZAddition.m
//
//  Created by ming on 16/5/11.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "UIView+LGAddition.h"

@implementation UIView (LGAddition)

- (UIImage *)lg_snapshotImage {

    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0);
    
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return result;
}

@end
