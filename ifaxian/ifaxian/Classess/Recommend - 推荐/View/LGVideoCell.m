//
//  LGVideoCell.m
//  ifaxian
//
//  Created by ming on 16/12/8.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGVideoCell.h"
#import "LGPlayerView.h"
@interface  LGVideoCell()<LGPlayerViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property (weak, nonatomic) IBOutlet UILabel *nameLable;


@property (weak, nonatomic) LGPlayerView *videoPlayer;

@end

@implementation LGVideoCell


- (UIView *)playerView{
    if (_playerView == nil) {
        _playerView = [[UIView alloc] init];
    }
    
    return _playerView;
}

- (void)awakeFromNib {
    [self layoutIfNeeded];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playerVieo)];
    [self.starVideoButton addGestureRecognizer:tap];
    
}




- (void)setModel:(LGRecommend *)model{
    _model = model;
    _titleLable.text = model.title;
    _nameLable.text = model.author.name;
    
    [_picImageView lg_setImageWithurl:model.thumbnail_images.medium.url placeholderImage:nil];

}

//调用代理
- (void)playerFailuretoreplay:(LGPlayerView *)view{
    
    [self playerVieo];
}

- (void)playerVieo{
     // [self.playerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.playerView.frame = self.picImageView.frame;
    self.playerView.lg_width = LGScreenW - 2 * LGCommonMargin;
    self.playerView.backgroundColor = [UIColor yellowColor];
    [self.contentView addSubview:self.playerView];

    LGPlayerView *plaer = [LGPlayerView videoPlayView];
    
    plaer.frame = self.playerView.bounds;
   
    plaer.delegate = self;
    UITabBarController *tab = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = tab.selectedViewController;
    plaer.contrainerViewController = nav;
    plaer.contrainerView = self.playerView;
    [self.playerView addSubview:plaer];
    self.videoPlayer = plaer;
   plaer.urlString = self.model.videoUrl;
    [plaer starVideo:self.videoPlayer.fullStarButton];
    
}

@end
