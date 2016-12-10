//
//  LGPlayerView.h
//  LGPlayer
//
//  Created by ming on 16/12/2.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LGPlayerView;

@protocol LGPlayerViewDelegate <NSObject>

- (void)playerFailuretoreplay:(LGPlayerView *)view;

@end

@interface LGPlayerView : UIView
/** 需要播放的视频资源 */
@property(nonatomic,strong)NSString *urlString;
@property (weak, nonatomic) IBOutlet UIImageView *bacImagView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property (weak, nonatomic) IBOutlet UIButton *fullStarButton;

/* 包含在哪一个控制器中 */
@property (nonatomic, weak) UIViewController *contrainerViewController;
@property (nonatomic, weak) UIView *contrainerView;
@property (nonatomic, weak) id<LGPlayerViewDelegate> delegate;
+ (instancetype)videoPlayView;
- (IBAction)starVideo:(UIButton *)sender;

@end
