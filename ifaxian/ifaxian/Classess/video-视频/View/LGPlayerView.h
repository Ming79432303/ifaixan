//
//  LGPlayerView.h
//  LGPlayer
//
//  Created by ming on 16/12/2.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LGPlayerView : UIView

/** 需要播放的视频资源 */
@property(nonatomic,strong)NSString *urlString;
@property (weak, nonatomic) IBOutlet UIImageView *bacImagView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;

/* 包含在哪一个控制器中 */
@property (nonatomic, weak) UIViewController *contrainerViewController;


+ (instancetype)videoPlayView;

@end
