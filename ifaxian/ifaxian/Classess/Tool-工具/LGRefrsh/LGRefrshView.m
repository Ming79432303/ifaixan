//
//  LGRefrshView.m
//  下拉刷新oc
//
//  Created by ming on 16/10/31.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGRefrshView.h"
@interface LGRefrshView()
@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *actuvitiView;

@end

@implementation LGRefrshView

+ (LGRefrshView *)refrshView{
    
    LGRefrshView *refView = [[[NSBundle mainBundle] loadNibNamed:@"LGRefreshGif" owner:self options:nil] firstObject];
    refView.refState = Normal;

    return refView;
}
- (void)setRefState:(LGRefrshType)refState{
    
//    Normal,
//    ///刷新状态
//    PullIng,
//    ///正在刷新状态
//    willRefresh
    _refState = refState;
    switch (refState) {
            //正常状态
        case Normal:{
            [_actuvitiView stopAnimating];
            _imageView.hidden = NO;
            self.titleLable.text = @"使劲拉";
            [UIView animateWithDuration:0.25 animations:^{
                _imageView.transform = CGAffineTransformIdentity;
            }];
            break;
            ///刷新状态
        }
        case PullIng:{
            self.titleLable.text = @"放开刷新";
            [UIView animateWithDuration:0.25 animations:^{
                _imageView.transform = CGAffineTransformMakeRotation(-M_PI-0.001);
            }];
            break;
        }
            
            ///正在刷新
        case willRefresh:
            _imageView.hidden = YES;
            _titleLable.text = @"正在刷新...";
            [_actuvitiView startAnimating];
            
            break;
    }
    
    
}

@end
