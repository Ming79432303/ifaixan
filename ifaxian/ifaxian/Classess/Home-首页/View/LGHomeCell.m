//
//  LGVHomeCell.m
//  ifaxian
//
//  Created by ming on 16/11/17.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGHomeCell.h"
#import <UIImageView+WebCache.h>
#import "LGHomeImagesView.h"
@interface LGHomeCell()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLable;



@property (weak, nonatomic) IBOutlet UILabel *excerptLable;

@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property (weak, nonatomic) IBOutlet UILabel *dateLable;
@property(nonatomic, strong) NSTimer *timer;
@property (weak, nonatomic) IBOutlet LGHomeImagesView *homeimagesView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *homeImagesViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imagesViewHeight;

@property (weak, nonatomic) IBOutlet UILabel *categoryLable;
@property (weak, nonatomic) IBOutlet UILabel *tagLable;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;

@end


@implementation LGHomeCell



- (void)setModel:(LGHomeModel *)model{
    _model = model;
    
    self.nameLable.text = model.author.nickname;
    self.excerptLable.text = model.description;
    self.dateLable.text = model.date;
    self.titleLable.text = model.title;
   
    self.homeimagesView.images = model.images;
    if (model.comments.count > 0) {
        
        [self.commentButton setTitle:[NSString stringWithFormat:@"%zd",model.comments.count] forState:UIControlStateNormal];
    }else{
        
        [self.commentButton setTitle:@"评论" forState:UIControlStateNormal];
    }

    if (model.tags.firstObject.title.length) {
    
        self.tagLable.text = [NSString stringWithFormat:@"#%@",model.tags.firstObject.title];
    }else{
        self.tagLable.text = nil;
    }
    [self.avatarImageView setHeader:[model.author.slug lg_getuserAvatar]];
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
    [super awakeFromNib];
    
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
/**
 *  拦击系统的frame修改cell的大小
 *
 *  @param frame 系统的frame
 */
- (void)setFrame:(CGRect)frame{
    
    CGRect cellFrame = frame;
    cellFrame.size.height -= LGCommonMargin;
    cellFrame.size.width -= 2 * LGCommonSmallMargin;
    cellFrame.origin.x += LGCommonSmallMargin;
    cellFrame.origin.y += LGCommonMargin;
    [super setFrame:cellFrame];
    
}



@end
