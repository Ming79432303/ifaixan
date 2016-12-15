//
//  LGSquareCell.m
//  ifaxian
//
//  Created by ming on 16/11/30.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGSquareCell.h"
#import "LGImagesView.h"
#import "NSString+LGRegularExpressions.h"
#import "LGPlayerView.h"
#import "NSURL+LGGetVideoImage.h"
#import "LGUserController.h"

@interface LGSquareCell()<LGPlayerViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *contenText;
@property (weak, nonatomic) IBOutlet UIImageView *imagev;
@property (weak, nonatomic) IBOutlet LGImagesView *imagesView;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UILabel *dataLable;
@property(nonatomic, strong) UIImageView *bacImageView;
@property(nonatomic, strong) UIImageView *starImageView;
@end


@implementation LGSquareCell

- (UIView *)playerView{
    
    if (_playerView == nil) {
        _playerView = [[LGPlayerView alloc] init];
    }
    
    return _playerView;
}


- (UIImageView *)bacImageView{
    
    if (_bacImageView == nil) {
        _bacImageView = [[UIImageView alloc] init];
        _bacImageView.userInteractionEnabled = YES;
        _bacImageView.backgroundColor = [UIColor yellowColor];
        _bacImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bacImageView.clipsToBounds = YES;
        [_bacImageView addSubview:self.starImageView];
        [self.contentView addSubview:_bacImageView];
    }
    
    return _bacImageView;
}

- (UIImageView *)starImageView{
    if (_starImageView == nil) {
        _starImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"视频播放"]];
        _starImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playerVieo)];
        [_starImageView addGestureRecognizer:tap];
    }
    return _starImageView;
}


- (void)awakeFromNib {
    // Initialization code
    
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(go2userController)];
    
    [self.iconImage addGestureRecognizer:tap];
    
    
    [self layoutIfNeeded];
}

- (void)go2userController{
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:NSStringFromClass([LGUserController class]) bundle:nil];
    LGUserController *userVc = [story instantiateInitialViewController];
    userVc.author = _model.share.author;
    UITabBarController *tab = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = tab.selectedViewController;
    [nav pushViewController:userVc animated:YES];
    
}


- (void)setModel:(LGShare *)model{
    _model = model;
    _nameLable.text = model.share.author.nickname;
    _contenText.text = model.share.title;
    _dataLable.text = model.share.date;
    
    if (model.images.count) {
        self.imagev.image = [UIImage imageNamed:@"image_icon"];
        _bacImageView.hidden = YES;
        _imagesView.hidden = NO;
        _imagesView.model = model;
    }else if (model.VideoUrl.length) {
         self.imagev.image = [UIImage imageNamed:@"video_icon"];
         self.bacImageView.frame = model.videoViewFrame;
     
         self.starImageView.center = CGPointMake(model.videoViewFrame.size.width/2, model.videoViewFrame.size.height/2);
        _bacImageView.hidden = NO;
        _imagesView.hidden = YES;

        self.bacImageView.image = model.videoImage;
    }else{
         self.imagev.image = [UIImage imageNamed:@"text_icon"];
        _bacImageView.hidden = YES;
        _imagesView.hidden = YES;

         LGLog(@"文字");
    }
    [_likeButton setTitle:model.share.ding forState:UIControlStateNormal];
    [_commentButton setTitle:[NSString stringWithFormat:@"%zd",model.share.comments.count] forState:UIControlStateNormal];

   
}

- (void)setFrame:(CGRect)frame{
    
    CGRect cellFrame = frame;
    cellFrame.size.height -= LGCommonMargin;
    cellFrame.size.width -= 2 * LGCommonSmallMargin;
    cellFrame.origin.x += LGCommonSmallMargin;
    cellFrame.origin.y += LGCommonMargin;
    

    [super setFrame:cellFrame];
    
}

//调用代理
- (void)playerFailuretoreplay:(LGPlayerView *)view{
    
    [self playerVieo];
}

- (void)playerVieo{
    // [self.playerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.playerView.frame = self.bacImageView.frame;
    self.playerView.lg_width = LGScreenW - 4 * LGCommonMargin;
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

    plaer.urlString = self.model.VideoUrl;
    [plaer starVideo:plaer.fullStarButton];
    
}
- (IBAction)addLike:(id)sender {
    _likeButton.selected = !_likeButton.selected;

    if (_likeButton.selected) {
        LGLog(@"赞");
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
        
         [[LGNetWorkingManager manager] requestAddLikeAction:@"addLike" umid:[NSString stringWithFormat:@"%zd",self.model.share.ID] completion:^(BOOL isSuccess, id responseObject) {
       
        NSLog(@"%@",responseObject);
    }];
    }else{
        LGLog(@"取消赞");
        if (!_likeButton.selected) {
            [[LGNetWorkingManager manager] requestAddLikeAction:@"subLike" umid:[NSString stringWithFormat:@"%zd",self.model.share.ID] completion:^(BOOL isSuccess, id responseObject) {
                
            }];

        }
    }
       
}
- (IBAction)comments:(id)sender {
    
     LGLog(@"评论");
}


@end
