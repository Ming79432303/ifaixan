//
//  LGPhotoCell.m
//  自定义相册
//
//  Created by Apple_Lzzy27 on 16/11/16.
//  Copyright © 2016年 Apple_Lzzy27. All rights reserved.
//

#import "LGPhotoCell.h"

@interface LGPhotoCell ()


@property (nonatomic,strong) UIView *view;
@property (nonatomic,strong)  UIImageView *selectedImageView;
@end

@implementation LGPhotoCell
- (UIView *)view{
    if (_view == nil) {
        _view = [[UIView alloc] init];
    }
    
    
    return _view;
}

- (UIImageView *)selectedImageView{
    
    if (_selectedImageView == nil) {
        _selectedImageView = [[UIImageView  alloc] init];
    }
    
    return _selectedImageView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.contentView.frame];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [self.contentView addSubview:imageView];
        self.selectedImage = NO;
        self.imageView = imageView;
        
    }
    return self;
    
}
- (void)setSelectedImage:(BOOL)selectedImage{
    
    _selectedImage = selectedImage;
    
    self.view.frame = self.contentView.bounds;
    
    if (_selectedImage == YES) {
        
        self.view.backgroundColor = [UIColor whiteColor];
        self.view.alpha = 0.3;
        self.selectedImageView.image = [UIImage imageNamed:@"选中"];
        CGFloat imageW = 32;
        CGFloat imageH = 32;
        CGFloat imageX = self.contentView.bounds.size.width - imageW;
        CGFloat imageY = self.contentView.bounds.size.height - imageH;
        self.selectedImageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
        [self.contentView addSubview:self.view];
        [self.contentView addSubview:self.selectedImageView];
     
    }else{
  
        [self.view removeFromSuperview];
        [self.selectedImageView removeFromSuperview];
        
    }
    
    
    
    
}
//- (void)setSelected:(BOOL)selected{
//   
//    
//     UIView *view = [[UIView alloc] initWithFrame:self.contentView.bounds];
//    UIImageView *selectedImageView = [[UIImageView alloc] init];
//    if (selected == YES) {
//       
//        view.backgroundColor = [UIColor whiteColor];
//        view.alpha = 0.3;
//        
//        
//        
//        selectedImageView.image = [UIImage imageNamed:@"选中"];
//        CGFloat imageW = 32;
//        CGFloat imageH = 32;
//        CGFloat imageX = self.contentView.bounds.size.width - imageW;
//        CGFloat imageY = self.contentView.bounds.size.height - imageH;
//        
//        selectedImageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
//        
//        [self.contentView addSubview:view];
//        [self.contentView addSubview:selectedImageView];
//    }else{
//        
//        [view removeFromSuperview];
//        [selectedImageView removeFromSuperview];
//        
//    }
//    
//    
//
//    
//}


@end
