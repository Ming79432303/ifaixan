//
//  LGRefreshGif.m
//  下拉刷新oc
//
//  Created by ming on 16/10/31.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGRefreshGif.h"
@interface LGRefreshGif()
@property (weak, nonatomic) IBOutlet UIImageView *builDingIcon;
@property (weak, nonatomic) IBOutlet UIImageView *earIcon;

@property (weak, nonatomic) IBOutlet UIImageView *kangaroolIocn;

@end
@implementation LGRefreshGif

- (void)setParentViewHeight:(CGFloat)parentViewHeight{
    //改变袋鼠的大小
    CGFloat scanle;
 
    //计算变大系数
    scanle = parentViewHeight/self.bounds.size.height;
    if (parentViewHeight>self.bounds.size.height) {
        scanle = 1;
    }
   
    
    
    _kangaroolIocn.transform = CGAffineTransformMakeScale(scanle, scanle);
    
}
- (void)awakeFromNib{
    [super awakeFromNib];
 
    [self setupUI];
    
}
- (void)setupUI{
    
//    let image1 = UIImage(named: "icon_building_loading_1")
//    let image2 = UIImage(named: "icon_building_loading_2")
    //
    UIImage *image1 = [UIImage imageNamed:@"icon_building_loading_1"];
    UIImage *image2 = [UIImage imageNamed:@"icon_building_loading_2"];
    _builDingIcon.image = [UIImage animatedImageWithImages:@[image1,image2] duration:0.5];
    
    //袋鼠 let kimage1 = UIImage(named: "icon_small_kangaroo_loading_1")
//    let  = UIImage(named: "icon_small_kangaroo_loading_2")
    UIImage *kimage1 = [UIImage imageNamed:@"icon_small_kangaroo_loading_1"];
    UIImage *kimage2 = [UIImage imageNamed:@"icon_small_kangaroo_loading_2"];
    _kangaroolIocn.image = [UIImage animatedImageWithImages:@[kimage1,kimage2] duration:0.5];
    
    //地球旋转
    CABasicAnimation *animati = [CABasicAnimation animation];
    animati.toValue = @(-2*M_PI);
    animati.duration = 5;
    animati.repeatCount = MAXFLOAT;
    animati.removedOnCompletion = NO;
    
    [_earIcon.layer addAnimation:animati forKey:@"transform.rotation"];
    
    _kangaroolIocn.layer.anchorPoint = CGPointMake(0.5, 1);
    //让袋鼠变小
    _kangaroolIocn.transform = CGAffineTransformMakeScale(1, 1);
    CGFloat kangY = self.frame.size.height - 0;
    _kangaroolIocn.center = CGPointMake(_earIcon.center.x, kangY);
    
    
    
}
@end
