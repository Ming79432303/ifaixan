//
//  LGSearchCell.m
//  ifaxian
//
//  Created by ming on 16/11/26.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGSearchCell.h"

@interface LGSearchCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *dataLable;


@property (weak, nonatomic) IBOutlet UILabel *commentCountLable;
@property (weak, nonatomic) IBOutlet UILabel *postViewsLable;
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;

@end

@implementation LGSearchCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(LGPostModel *)model{
    
    _model = model;
    
    self.titleLable.text = model.title;
    
    self.dataLable.text = model.date;
    
    self.commentCountLable.text = [NSString stringWithFormat:@"评论 %@",model.comment_count];
    [self.picImageView lg_setImageWithurl:model.imageUrl placeholderImage:nil];
    NSString *viewCount = model.views.length > 0 ? model.views:@"0";
    self.postViewsLable.text = [NSString stringWithFormat:@"评论 %@",viewCount];
   
    
    
}


- (void)setFrame:(CGRect)frame{
    
    CGRect cellFrame = frame;
    cellFrame.size.height -= 1;
    cellFrame.size.width -= 2 * LGCommonSmallMargin;
    cellFrame.origin.x += LGCommonSmallMargin;
    cellFrame.origin.y += LGCommonMargin;
    
    
    [super setFrame:cellFrame];
    
}


@end
