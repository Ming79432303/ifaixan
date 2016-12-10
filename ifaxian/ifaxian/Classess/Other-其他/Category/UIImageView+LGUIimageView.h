//
//  UIImageView+LGUIimageView.h
//  微博oc版
//
//  Created by Apple_Lzzy27 on 16/10/21.
//  Copyright © 2016年 Apple_Lzzy27. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (LGUIimageView)

-(void)lg_setImageWithurl:(NSString *)url placeholderImage:(UIImage *)image;
-(void)lg_setCircularImageWithurl:(NSString *)url placeholderImage:(UIImage *)image;
@end
