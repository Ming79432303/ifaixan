//
//  UIView+Frame.h
//  百思不得姐
//
//  Created by Apple_Lzzy27 on 16/11/2.
//  Copyright © 2016年 Apple_Lzzy27. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)
@property (nonatomic, assign) CGSize lg_size;
@property (nonatomic, assign) CGFloat lg_width;
@property (nonatomic, assign) CGFloat lg_height;
@property (nonatomic, assign) CGFloat lg_x;
@property (nonatomic, assign) CGFloat lg_y;
@property (nonatomic, assign) CGFloat lg_centerX;
@property (nonatomic, assign) CGFloat lg_centerY;
@property (nonatomic, assign) CGFloat lg_right;
@property (nonatomic, assign) CGFloat lg_bottom;
+(instancetype)viewFromeNib;
- (BOOL)lg_intersectWithView:(UIView *)view;
@end
