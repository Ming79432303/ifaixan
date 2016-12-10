//
//  UIView+Frame.m
//  百思不得姐
//
//  Created by Apple_Lzzy27 on 16/11/2.
//  Copyright © 2016年 Apple_Lzzy27. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)



- (CGSize)lg_size
{
    return self.frame.size;
}

- (void)setLg_size:(CGSize)lg_size
{
    CGRect frame = self.frame;
    frame.size = lg_size;
    self.frame = frame;
}

- (CGFloat)lg_width
{
    return self.frame.size.width;
}

- (CGFloat)lg_height
{
    return self.frame.size.height;
}

- (void)setLg_width:(CGFloat)lg_width
{
    CGRect frame = self.frame;
    frame.size.width = lg_width;
    self.frame = frame;
}

- (void)setLg_height:(CGFloat)lg_height
{
    CGRect frame = self.frame;
    frame.size.height = lg_height;
    self.frame = frame;
}

- (CGFloat)lg_x
{
    return self.frame.origin.x;
}

- (void)setLg_x:(CGFloat)lg_x
{
    CGRect frame = self.frame;
    frame.origin.x = lg_x;
    self.frame = frame;
}

- (CGFloat)lg_y
{
    return self.frame.origin.y;
}

- (void)setLg_y:(CGFloat)lg_y
{
    CGRect frame = self.frame;
    frame.origin.y = lg_y;
    self.frame = frame;
}

- (CGFloat)lg_centerX
{
    return self.center.x;
}

- (void)setLg_centerX:(CGFloat)lg_centerX
{
    CGPoint center = self.center;
    center.x = lg_centerX;
    self.center = center;
}

- (CGFloat)lg_centerY
{
    return self.center.y;
}

- (void)setLg_centerY:(CGFloat)lg_centerY
{
    CGPoint center = self.center;
    center.y = lg_centerY;
    self.center = center;
}

- (CGFloat)lg_right
{
   
    return CGRectGetMaxX(self.frame);
}

-(CGFloat)lg_bottom{
    return CGRectGetMaxY(self.frame);
    
}



- (void)setLg_right:(CGFloat)lg_right
{
    self.lg_x = lg_right - self.lg_width;
}

- (void)setLg_bottom:(CGFloat)lg_bottom
{
    self.lg_y = lg_bottom - self.lg_height;
}
+(instancetype)viewFromeNib{
    
    
    return  [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    
}
- (BOOL)lg_intersectWithView:(UIView *)view
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect selfRect = [self convertRect:self.bounds toView:window];
    CGRect viewRect = [view convertRect:view.bounds toView:window];
    return CGRectIntersectsRect(selfRect, viewRect);
}
@end
