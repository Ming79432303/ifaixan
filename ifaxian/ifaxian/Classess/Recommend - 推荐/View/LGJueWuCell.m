//
//  LGJueWuCell.m
//  ifaxian
//
//  Created by ming on 16/12/30.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGJueWuCell.h"

@interface LGJueWuCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *dateLable;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet UILabel *describeLable;

@end


@implementation LGJueWuCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(LGRecommend *)model{
    if (model.imageUrl) {
         _picImageView.hidden = NO;
        [_picImageView lg_setImageWithurl:model.imageUrl placeholderImage:nil];
    }else{
        _picImageView.hidden = YES;
    }
    [_iconImageView setHeader:[model.author.slug lg_getuserAvatar]];
    _dateLable.text = model.date;
    _nameLable.text = model.author.nickname;
    _titleLable.text = model.title ;
    _describeLable.text = model.descriptions;
    
    
}
- (void)setFrame:(CGRect)frame{
    
    CGRect cellFrame = frame;
    cellFrame.size.height -= LGCommonMargin;
    cellFrame.size.width -= 2 * LGCommonSmallMargin;
    cellFrame.origin.x += LGCommonSmallMargin;
    cellFrame.origin.y += LGCommonMargin;
    
    
    [super setFrame:cellFrame];
    
}

@end
