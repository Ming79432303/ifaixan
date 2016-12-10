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

@interface LGSquareCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property (weak, nonatomic) IBOutlet UILabel *contenText;

@property (weak, nonatomic) IBOutlet UIImageView *imagev;

@property (weak, nonatomic) IBOutlet LGImagesView *imagesView;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;

@property (weak, nonatomic) IBOutlet UILabel *dataLable;
@property(nonatomic, strong) LGPlayerView *playerView;
@end


@implementation LGSquareCell

- (LGPlayerView *)playerView{
    if (_playerView == nil) {
        _playerView = [LGPlayerView videoPlayView];
        _playerView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_playerView];
    }
    
    return _playerView;
}


- (void)awakeFromNib {
    // Initialization code
    
    [super awakeFromNib];
    
}

- (void)setModel:(LGShare *)model{
    _model = model;
    _nameLable.text = model.share.author.nickname;
    _contenText.text = model.share.title;
    _dataLable.text = model.share.date;
    
    if (model.images.count) {
        self.imagev.image = [UIImage imageNamed:@"image_icon"];
        self.playerView.hidden = YES;
        _imagesView.hidden = NO;
        _imagesView.model = model;
    }else if (model.VideoUrl.length) {
         self.imagev.image = [UIImage imageNamed:@"video_icon"];
        self.playerView.hidden = NO;
        _imagesView.hidden = YES;
        self.playerView.urlString = model.VideoUrl;
        self.playerView.frame = model.videoViewFrame;
        self.playerView.bacImagView.image = model.videoImage;
    }else{
         self.imagev.image = [UIImage imageNamed:@"text_icon"];
        self.playerView.hidden = YES;
        _imagesView.hidden = YES;

         LGLog(@"文字");
    }
    
    
    
    [_likeButton setTitle:model.share.ding forState:UIControlStateNormal];
    [_commentButton setTitle:[NSString stringWithFormat:@"%zd",model.share.comments.count] forState:UIControlStateNormal];

   
}

- (void)setFrame:(CGRect)frame{
    
    CGRect cellFrame = frame;
    cellFrame.size.height -= LGCommonMargin;
    cellFrame.size.width -= 2 * LGCommonMargin;
    cellFrame.origin.x += LGCommonMargin;
    cellFrame.origin.y += LGCommonMargin;
    
    
    
    [super setFrame:cellFrame];
    
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
