//
//  LGPhotoListCell.m
//  自定义相册
//
//  Created by Apple_Lzzy27 on 16/11/16.
//  Copyright © 2016年 Apple_Lzzy27. All rights reserved.
//

#import "LGPhotoListCell.h"
@interface LGPhotoListCell()
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *numbersLable;

@end
@implementation LGPhotoListCell



- (void)setPhoto:(LGPhoto *)photo{
    
    _photo = photo;
    self.photoImageView.image = photo.images.firstObject.image;
    
    self.nameLable.text = photo.albumName;
    
    self.numbersLable.text = [NSString stringWithFormat:@"%zd",photo.images.count];
    
}


@end
