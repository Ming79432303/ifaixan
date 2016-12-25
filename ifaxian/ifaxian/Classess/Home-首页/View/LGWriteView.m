//
//  LGWriteView.m
//  ifaxian
//
//  Created by ming on 16/11/29.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGWriteView.h"
#import "LGSenImageController.h"
#import "LGSendVideoController.h"
#import "LGSendArticleContrloler.h"
#import "LGBasiController.h"
@implementation LGWriteView


- (void)awakeFromNib{
    [self layoutIfNeeded];
    [super awakeFromNib];
    self.frame = [UIScreen mainScreen].bounds;
        [self setupUI];

}
- (void)setupUI{
    
    UIButton *articleButton  = [[UIButton alloc] init];
    [articleButton setImage:[UIImage imageNamed:@"send_button_article"]  forState:UIControlStateNormal];
    CGFloat butnH = 35;
    CGFloat butnW = 35;
   
    

    
    articleButton.frame = CGRectMake(self.lg_width/2 - butnW/2, self.lg_height - butnH, butnH, butnH);
    [articleButton sizeToFit];
    
   
      [self addSubview:articleButton];
    [articleButton addTarget:self action:@selector(sendArticle) forControlEvents:UIControlEventTouchUpInside];
    
    
    POPSpringAnimation *animat = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    animat.toValue = [NSValue valueWithCGPoint:CGPointMake(100, 0.8 * [UIScreen lg_screenHeight])];
    animat.springBounciness = 10;
    animat.springSpeed = 20;
    
    [articleButton pop_addAnimation:animat forKey:nil];
    
    POPSpringAnimation *scaleAnimati = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];

    scaleAnimati.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
    scaleAnimati.toValue = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
    
    scaleAnimati.springBounciness = 15;
    scaleAnimati.springSpeed = 15;
    

    
    [articleButton pop_addAnimation:scaleAnimati forKey:nil];

    //动态按钮
    UIButton *dynamicButton  = [[UIButton alloc] init];
    [dynamicButton setImage:[UIImage imageNamed:@"send_image_button"] forState:UIControlStateNormal];
 
   
    
    dynamicButton.frame = CGRectMake(self.lg_width/2 - butnW/2, self.lg_height - butnH, butnH, butnH);
    [dynamicButton sizeToFit];
    [self addSubview:dynamicButton];
    
    POPSpringAnimation *dynamicAnimat = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    dynamicAnimat.toValue = [NSValue valueWithCGPoint:CGPointMake(self.lg_width * 0.5, 0.75 * [UIScreen lg_screenHeight])];
    dynamicAnimat.springBounciness = 10;
    dynamicAnimat.springSpeed = 20;
    
    [dynamicButton pop_addAnimation:dynamicAnimat forKey:nil];
    
    [dynamicButton addTarget:self action:@selector(sendImages) forControlEvents:UIControlEventTouchUpInside];
    //图片
    
    
    UIButton *videoButton  = [[UIButton alloc] init];
    [videoButton setBackgroundImage:[UIImage imageNamed:@"send_video_button"] forState:UIControlStateNormal];

    videoButton.frame = CGRectMake(self.lg_width/2 - butnW/2, self.lg_height - butnH, butnW, butnH);
     [videoButton sizeToFit];
    [videoButton addTarget:self action:@selector(sendVideo) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:videoButton];
    POPSpringAnimation *videoAnimat = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    videoAnimat.toValue = [NSValue valueWithCGPoint:CGPointMake(self.lg_width - 100, 0.8 * [UIScreen lg_screenHeight])];
    videoAnimat.springBounciness = 10;
    videoAnimat.springSpeed = 20;
    
    [videoButton pop_addAnimation:videoAnimat forKey:nil];
    
    POPSpringAnimation *videoScaleAnimati = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    
    videoScaleAnimati.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
    videoScaleAnimati.toValue = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
    
    videoScaleAnimati.springBounciness = 15;
    videoScaleAnimati.springSpeed = 15;
    
    [videoButton pop_addAnimation:videoScaleAnimati forKey:nil];
    
}
- (void)sendImages{
    
    UITabBarController *tab = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
   UINavigationController *nav = tab.selectedViewController;
    LGSenImageController *sendVc = [[LGSenImageController alloc] init];
    
    [nav presentViewController:sendVc animated:YES completion:^{
        [self removeFromSuperview];
        if ([self.delegate respondsToSelector:@selector(removerConverViewWriteView:)]) {
            [self.delegate removerConverViewWriteView:self];
        }
        
    }];
}


- (void)sendVideo{
    UITabBarController *tab = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = tab.selectedViewController;
    LGSendVideoController *sendVc = [[LGSendVideoController alloc] init];
    
    [nav presentViewController:sendVc animated:YES completion:^{
        [self removeFromSuperview];
        if ([self.delegate respondsToSelector:@selector(removerConverViewWriteView:)]) {
            [self.delegate removerConverViewWriteView:self];
        }
        
    }];

    
}
- (void)sendArticle{
    UITabBarController *tab = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = tab.selectedViewController;
    LGSendArticleContrloler *sendVc = [[LGSendArticleContrloler alloc] init];
   
    UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:sendVc];
    
    [nav presentViewController:navc animated:YES completion:^{
        [self removeFromSuperview];
        if ([self.delegate respondsToSelector:@selector(removerConverViewWriteView:)]) {
            [self.delegate removerConverViewWriteView:self];
        }
        
    }];
    

    
    
}
- (void)removeFromSuperview{
    
    [super removeFromSuperview];
}

@end
