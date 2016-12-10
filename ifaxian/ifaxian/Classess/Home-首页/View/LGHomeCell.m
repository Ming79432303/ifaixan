//
//  LGVHomeCell.m
//  ifaxian
//
//  Created by ming on 16/11/17.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGHomeCell.h"
#import <UIImageView+WebCache.h>
#import "LGHomeCommentView.h"
#import "LGHomeTagsView.h"
#import "LGHomeImagesView.h"
@interface LGHomeCell()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLable;


@property (weak, nonatomic) IBOutlet LGHomeTagsView *tagView;

@property (weak, nonatomic) IBOutlet UILabel *excerptLable;

@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property (weak, nonatomic) IBOutlet UILabel *dateLable;
@property(nonatomic, strong) NSTimer *timer;
@property (weak, nonatomic) IBOutlet LGHomeImagesView *homeimagesView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *homeImagesViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imagesViewHeight;

@property (weak, nonatomic) IBOutlet UILabel *categoryLable;

@end


@implementation LGHomeCell



- (void)setModel:(LGHomeModel *)model{
    _model = model;
    
    self.nameLable.text = model.author.nickname;
    self.excerptLable.text = model.description;
    self.dateLable.text = model.date;
    self.titleLable.text = model.title;
    self.tagView.tags = model.tags;
    self.homeimagesView.images = model.images;
    if (self.constraints.count) {
        
        self.categoryLable.text = model.categories.firstObject.title;
    }
    if (model.images.count > 0) {
        self.homeimagesView.hidden = NO;
        if (model.images.count == 1) {
            self.imagesViewHeight.constant = 200;
        }else {
            self.imagesViewHeight.constant = ((model.images.count - 1)/3 +1) * LGHomeImageViewItemWH  + (((model.images.count - 1)/3)) * LGCommonMinMargin;
        }
    }else{
         self.homeimagesView.hidden = YES;
        self.imagesViewHeight.constant = 0;
    }

    

  
}


- (void)awakeFromNib {
    
   self.autoresizingMask = UIViewAutoresizingNone;
//  
//   UIImageView *bgImageView = [[UIImageView alloc] init];
//    
//    bgImageView.image = [UIImage imageNamed:@"mainCellBackground"];
//    bgImageView.frame = self.contentView.frame;
//    
//    
//    UIImage *image = [UIImage imageNamed:@"mainCellBackground"];
//    image = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
// 
//    
//    
//    self.backgroundView =[[UIImageView alloc] initWithImage:image];
    //等比例拉伸图片
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

   
}
- (void)setFrame:(CGRect)frame{
    
    CGRect cellFrame = frame;
    cellFrame.size.height -= 1;
//    cellFrame.size.width -= 4;
//    cellFrame.origin.y += LGCommonMargin;
//    cellFrame.origin.x += 2;
    [super setFrame:cellFrame];

}





@end
