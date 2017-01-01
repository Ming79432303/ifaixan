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
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@property (weak, nonatomic) IBOutlet UILabel *nameLable;

@property (weak, nonatomic) IBOutlet UILabel *dateLable;

@property (weak, nonatomic) LGPlayerView *videoPlayer;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgaeView;

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
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playerVieo)];
    [self.starVideoButton addGestureRecognizer:tap];
    
}




- (void)setModel:(LGRecommend *)model{
    _model = model;
    
    if (model.comments.count > 0) {
        
        [self.commentButton setTitle:[NSString stringWithFormat:@"%zd",model.comments.count] forState:UIControlStateNormal];
    }else{
        
        [self.commentButton setTitle:@"评论" forState:UIControlStateNormal];
    }
    _dateLable.text = model.date;
    _titleLable.text = model.title;
    _nameLable.text = model.author.name;
    [_iconImgaeView setHeader:[model.author.slug lg_getuserAvatar]];
    
    [_picImageView lg_setImageWithurl:model.thumbnail_images.full.url placeholderImage:nil];

}

//调用代理
- (void)playerFailuretoreplay:(LGPlayerView *)view{
    
    [self playerVieo];
}

- (void)playerVieo{
     // [self.playerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.playerView.frame = self.picImageView.frame;
    self.playerView.lg_width = LGScreenW - 3 * LGCommonMargin;
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
    LGLog(@"%@",self.model.videoUrl);
    [plaer starVideo:self.videoPlayer.fullStarButton];
    
}

- (void)setFrame:(CGRect)frame{
    
    CGRect cellFrame = frame;
    cellFrame.size.height -= LGCommonMargin;
    cellFrame.size.width -= 2 * LGCommonSmallMargin;
    cellFrame.origin.x += LGCommonSmallMargin;
    cellFrame.origin.y += LGCommonMargin;
    
    
    [super setFrame:cellFrame];
    
}
- (IBAction)addLike:(id)sender {
    _likeButton.selected = !_likeButton.selected;
    
    if (_likeButton.selected) {
        
        _likeButton.enabled = NO;
        POPSpringAnimation *animat = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
        animat.toValue = [NSValue valueWithCGPoint:CGPointMake(1.5, 1.5)];
        animat.springBounciness = 20;
        animat.springSpeed = 20;
        [_likeButton pop_addAnimation:animat forKey:nil];
        POPBasicAnimation *basiAnimati = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
        basiAnimati.toValue = @(0);
        basiAnimati.duration = 0.6;
        [_likeButton pop_addAnimation:basiAnimati forKey:nil];
        [UIView animateWithDuration:0.25 animations:^{
            
            animat.completionBlock =  ^(POPAnimation *anim, BOOL finished){
                _likeButton.transform = CGAffineTransformMakeScale(1, 1);
                _likeButton.alpha = 1;
                _likeButton.enabled = YES;
                _likeButton.selected = NO;
                NSString *din = self.likeButton.currentTitle;
                
                NSInteger  dinCount = [din integerValue];
                dinCount++;
                
                [_likeButton setTitle:[NSString stringWithFormat:@"%zd",dinCount] forState:UIControlStateNormal];
                
                
            };
            
        }];
        
        [[LGNetWorkingManager manager] requestAddLikeAction:@"addLike" umid:[NSString stringWithFormat:@"%zd",self.model.ID] completion:^(BOOL isSuccess, id responseObject) {
            
           
        }];
    }else{
        
        if (!_likeButton.selected) {
            [[LGNetWorkingManager manager] requestAddLikeAction:@"subLike" umid:[NSString stringWithFormat:@"%zd",self.model.ID] completion:^(BOOL isSuccess, id responseObject) {
                
            }];
            
        }
    }
    
}



@end
