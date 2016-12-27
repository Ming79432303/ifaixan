//
//  LGXiaoHuaCell.m
//  ifaxian
//
//  Created by ming on 16/12/7.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGXiaoHuaCell.h"
#import "LWImageBrowser.h"
@interface LGXiaoHuaCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *contentLable;
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property (weak, nonatomic) IBOutlet UILabel *dateLable;

@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@end
@implementation LGXiaoHuaCell

- (void)awakeFromNib {
    // Initialization code
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeImage:)];
    [self.picImageView addGestureRecognizer:tap];
}

- (void)setModel:(LGRecommend *)model{
    _model = model;
    self.nameLable.text = model.author.name;
    self.titleLable.text = model.title;
    self.imageViewHeight.constant = model.imageSize.height;
    self.dateLable.text = model.date;
    if (model.comments.count > 0) {
        
        [self.commentButton setTitle:[NSString stringWithFormat:@"%zd",model.comments.count] forState:UIControlStateNormal];
    }else{
        
        [self.commentButton setTitle:@"评论" forState:UIControlStateNormal];
    }
    if (model.imageUrl.length) {
        self.imageView.hidden = NO;
        self.contentLable.hidden = YES;
        self.contentLable.text = nil;
        [self.picImageView lg_setImageWithurl:model.imageUrl placeholderImage:nil];
    }else{
        self.contentLable.hidden = NO;
        self.imageView.hidden = YES;
        self.contentLable.text = model.contentText;
        
    }

}
- (void)setFrame:(CGRect)frame{
    
    CGRect cellFrame = frame;
    cellFrame.size.height -= LGCommonMargin;
    cellFrame.size.width -= 2 * LGCommonSmallMargin;
    cellFrame.origin.x += LGCommonSmallMargin;
    cellFrame.origin.y += LGCommonMargin;
    
    
    [super setFrame:cellFrame];
    
}


- (void)seeImage:(UIGestureRecognizer *)tap{
    
    NSURL *url = [NSURL URLWithString:self.model.imageUrl];
    
    LWImageBrowserModel *model = [[LWImageBrowserModel alloc] initWithplaceholder:nil thumbnailURL:url HDURL:url containerView:self positionInContainer:self.picImageView.frame index:0];
    LWImageBrowser *imageBrow = [[LWImageBrowser alloc] initWithImageBrowserModels:@[model] currentIndex:0];
    imageBrow.isShowPageControl = NO;
    [imageBrow show];
    
    
    
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
            
            NSLog(@"%@",responseObject);
        }];
    }else{
        
        if (!_likeButton.selected) {
            [[LGNetWorkingManager manager] requestAddLikeAction:@"subLike" umid:[NSString stringWithFormat:@"%zd",self.model.ID] completion:^(BOOL isSuccess, id responseObject) {
                
            }];
            
        }
    }
    
}

@end
