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
