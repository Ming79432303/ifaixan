//
//  LGDongmanCell.m
//  ifaxian
//
//  Created by ming on 16/12/7.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGDongmanCell.h"
#import "LWImageBrowser.h"
@interface LGDongmanCell()

@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picImageViewHeight;

@end;


@implementation LGDongmanCell

- (void)awakeFromNib {
    // Initialization code
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeImage:)];
    [self.picImageView addGestureRecognizer:tap];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(LGRecommend *)model{
    
    
    _model = model;
    
    self.titleLable.text = model.title;
    
    [self.picImageView lg_setImageWithurl:model.imageUrl placeholderImage:nil];
    
    if (model.imageSize.height > 0) {
        
        self.picImageViewHeight.constant = model.imageSize.height;
    }

}

- (void)setFrame:(CGRect)frame{
    
    CGRect cellFrame = frame;
    cellFrame.size.height -= LGCommonMargin;
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

@end
