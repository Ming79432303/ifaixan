//
//  LGVideoCell.m
//  ifaxian
//
//  Created by ming on 16/12/8.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGVideoCell.h"
#import "LGPlayerView.h"
@interface  LGVideoCell()//<LGPlayerViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property (weak, nonatomic) IBOutlet UILabel *nameLable;

@property (weak, nonatomic) LGPlayerView *videoPlayer;

@end

@implementation LGVideoCell

- (void)awakeFromNib {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playerVieo)];
    
    
    [self.playerView addGestureRecognizer:tap];
    
}


- (void)playerVideo:(LGPlayerView *)playerView{
    
    [self playerVieo];
}

- (void)setModel:(LGRecommend *)model{
    _model = model;
    _titleLable.text = model.title;
    _nameLable.text = model.author.name;
    
    [_picImageView lg_setImageWithurl:model.thumbnail_images.medium.url placeholderImage:nil];

}
- (void)playerVieo{
    
//    [self.playerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//  
//    LGPlayerView *plaer = [LGPlayerView videoPlayView];
//    
//    plaer.frame = self.playerView.bounds;
//   
//    plaer.delegate = self;
//    UITabBarController *tab = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//    UINavigationController *nav = tab.selectedViewController;
//    
//
//    plaer.contrainerViewController = nav;
//    plaer.contrainerView = self.playerView;
//    [self.playerView addSubview:plaer];
////    self.videoPlayer = plaer;
//
//   plaer.urlString = self.model.videoUrl;
//    [plaer starVideo:self.videoPlayer.fullStarButton];
    
}

@end
