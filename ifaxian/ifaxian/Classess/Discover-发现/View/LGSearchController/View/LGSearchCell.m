//
//  LGSearchCell.m
//  ifaxian
//
//  Created by ming on 16/11/26.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGSearchCell.h"

@interface LGSearchCell()
/**
 *  搜索的标题
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
/**
 *  时间
 */
@property (weak, nonatomic) IBOutlet UILabel *dataLable;
/**
 *  评论
 */
@property (weak, nonatomic) IBOutlet UILabel *commentCountLable;
/**
 *  浏览数
 */
@property (weak, nonatomic) IBOutlet UILabel *postViewsLable;
/**
 *  搜索的第一张图
 */
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;

@end

@implementation LGSearchCell

- (void)awakeFromNib {
    // Initialization code
}
#pragma mark - 模型赋值
- (void)setModel:(LGPostModel *)model{
    
    _model = model;
    
    self.titleLable.text = model.title;
    
    self.dataLable.text = model.date;
    
    self.commentCountLable.text = [NSString stringWithFormat:@"评论 %@",model.comment_count];
    [self.picImageView lg_setImageWithurl:model.imageUrl placeholderImage:nil];
    NSString *viewCount = model.views.length > 0 ? model.views:@"0";
    self.postViewsLable.text = [NSString stringWithFormat:@"浏览数 %@",viewCount];
   
    
    
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
