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
#pragma mark - UI布局
- (void)setupUI{
  
     //*****发表文章按钮******
    UIButton *articleButton  = [[UIButton alloc] init];
    [articleButton setImage:[UIImage imageNamed:@"send_button_article"]  forState:UIControlStateNormal];
    //按钮的大小
    CGFloat butnH = 35;
    CGFloat butnW = 35;
    //按钮的尺寸
    articleButton.frame = CGRectMake(self.lg_width/2 - butnW/2, self.lg_height - butnH, butnH, butnH);
    [articleButton sizeToFit];
    //添加按钮到视图上
    [self addSubview:articleButton];
    //按钮的单击方法
    [articleButton addTarget:self action:@selector(sendArticle) forControlEvents:UIControlEventTouchUpInside];
    
    //发表文章按钮动画
    POPSpringAnimation *animat = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    //动画移动到的位置 需要NSValue转换
    animat.toValue = [NSValue valueWithCGPoint:CGPointMake(100, 0.8 * [UIScreen lg_screenHeight])];
    //弹性
    animat.springBounciness = 10;
    //弹性的速度
    animat.springSpeed = 20;
    //添加动画
    [articleButton pop_addAnimation:animat forKey:nil];
    //发表文章按钮缩放动画
    POPSpringAnimation *scaleAnimati = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    //缩放从哪个的大小 需要NSValue转换
    scaleAnimati.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
    //缩放到哪个大小需 要NSValue转换
    scaleAnimati.toValue = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
    //弹簧的弹性
    scaleAnimati.springBounciness = 15;
    //弹性的速度
    scaleAnimati.springSpeed = 15;
    //添加图片
    [articleButton pop_addAnimation:scaleAnimati forKey:nil];
    
    //*****发送图片******
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
 
    //*****发送视频按钮******
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

#pragma mark - 发送图片点击方法
- (void)sendImages{
    //获取根控制器
    UITabBarController *tab = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
   UINavigationController *nav = tab.selectedViewController;
    LGSenImageController *sendVc = [[LGSenImageController alloc] init];
    [nav presentViewController:sendVc animated:YES completion:^{
        //模态出界面后移除当前界面
        [self removeFromSuperview];
        if ([self.delegate respondsToSelector:@selector(removerConverViewWriteView:)]) {
            //移除当前界面，让中间按钮复原
            [self.delegate removerConverViewWriteView:self];
        }
        
    }];
}

#pragma mark - 发送视频点击方法
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
#pragma mark - 发送文章点击方法
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
