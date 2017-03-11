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
#import "LGUserListController.h"
@interface LGSquareCell()<LGPlayerViewDelegate>
//用户头像
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
//内容
@property (weak, nonatomic) IBOutlet UILabel *contenText;
//发表文章的内容类型
@property (weak, nonatomic) IBOutlet UIImageView *imagev;
//图片
@property (weak, nonatomic) IBOutlet LGImagesView *imagesView;
//昵称
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
//赞
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
//评论
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
//时间
@property (weak, nonatomic) IBOutlet UILabel *dataLable;
//背景图片用来显示视频的第一张图
@property(nonatomic, strong) UIImageView *bacImageView;
@property (weak, nonatomic) IBOutlet UIImageView *jubao;
//开始图片
@property(nonatomic, strong) UIImageView *starImageView;
@end
@implementation LGSquareCell

#pragma mark - 懒加载
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
        _bacImageView.backgroundColor = [UIColor darkGrayColor];
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

#pragma mark - nib加载完毕
- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    //添加手势
    self.autoresizingMask = UIViewAutoresizingNone;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(go2userController)];
    [self.iconImage addGestureRecognizer:tap];
    _commentButton.imageView.contentMode  = UIViewContentModeScaleAspectFit;
    
    UITapGestureRecognizer *jubaoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jubaoUser)];
    [self.jubao addGestureRecognizer:jubaoTap];
    
    [self layoutIfNeeded];
}
#pragma mark - 跳转控制器
- (void)go2userController{
    //判断当前控制器是否是LGUserListController如果是就唔需要再点击了
    if ([[self getCurrentViewController] isKindOfClass:[LGUserListController class]]) {
        return;
    }
    UIStoryboard *story = [UIStoryboard storyboardWithName:NSStringFromClass([LGUserController class]) bundle:nil];
    LGUserController *userVc = [story instantiateInitialViewController];
    userVc.author = _model.share.author;
    UITabBarController *tab = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = tab.selectedViewController;
    [nav pushViewController:userVc animated:YES];
    
}
//得到当前cell所在的控制器
-(UIViewController *)getCurrentViewController{
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}
#pragma mark - 模型赋值
- (void)setModel:(LGShare *)model{
    _model = model;
    //昵称
    _nameLable.text = model.share.author.nickname;
    //内容文本
    _contenText.text = model.share.title;
    //时间
    _dataLable.text = model.share.date;
    //用户头像
    [_iconImage setHeader:model.userAvatar];
    //如果存在那么就是图片
    if (model.images.count) {
        self.imagev.image = [UIImage imageNamed:@"image_icon"];
        _bacImageView.hidden = YES;
        _imagesView.hidden = NO;
        _imagesView.model = model;
        //如果存在视频那么就是视频类型
    }else if (model.VideoUrl.length) {
         self.imagev.image = [UIImage imageNamed:@"video_icon"];
         self.bacImageView.frame = model.videoViewFrame;
         self.starImageView.center = CGPointMake(model.videoViewFrame.size.width/2, model.videoViewFrame.size.height/2);
        _bacImageView.hidden = NO;
        _imagesView.hidden = YES;
        self.bacImageView.image = model.videoImage;
        //其他那么就是文本类型
    }else{
         self.imagev.image = [UIImage imageNamed:@"text_icon"];
        _bacImageView.hidden = YES;
        _imagesView.hidden = YES;
    }
    //获取当前的点赞数
    [_likeButton setTitle:model.share.ding forState:UIControlStateNormal];
    //评论数
    [_commentButton setTitle:[NSString stringWithFormat:@"%zd",model.share.comments.count] forState:UIControlStateNormal];

   
}
#pragma mark - 拦截系统的frame
- (void)setFrame:(CGRect)frame{
    
    CGRect cellFrame = frame;
    cellFrame.size.height -= LGCommonMargin;
    cellFrame.size.width -= 2 * LGCommonSmallMargin;
    cellFrame.origin.x += LGCommonSmallMargin;
    cellFrame.origin.y += LGCommonMargin;
    [super setFrame:cellFrame];
    
}

#pragma mark - LGplayer的代理方法
- (void)playerFailuretoreplay:(LGPlayerView *)view{
    
    [self playerVieo];
}
#pragma mark - 播放视频

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
#pragma mark - 点赞按钮事件
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
        //添加动画
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
       
        
    }];
    }else{
       
        if (!_likeButton.selected) {
            [[LGNetWorkingManager manager] requestAddLikeAction:@"subLike" umid:[NSString stringWithFormat:@"%zd",self.model.share.ID] completion:^(BOOL isSuccess, id responseObject) {
                
            }];

        }
    }
       
}
- (IBAction)comments:(id)sender {
    
     LGLog(@"评论");
}
//举报
- (void)jubaoUser{
    
    [LGJubaoView showView];
    
    
    
}

@end
