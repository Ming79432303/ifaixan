//
//  LGArticleCell.m
//  ifaxian
//
//  Created by ming on 16/11/22.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGArticleCell.h"

@interface LGArticleCell()
@property (weak, nonatomic) IBOutlet UIButton *authorButton;

@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *viewsLable;
@property (weak, nonatomic) IBOutlet UILabel *commentsLable;
@property (weak, nonatomic) IBOutlet UILabel *zanLabel;

@property (weak, nonatomic) IBOutlet UIImageView *picImageView;


@end;


@implementation LGArticleCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
        self.autoresizingMask = UIViewAutoresizingNone;
        UIImageView *bgImageView = [[UIImageView alloc] init];
        bgImageView.image = [UIImage imageNamed:@"mainCellBackground"];
        bgImageView.frame = self.contentView.frame;
        UIImage *image = [UIImage imageNamed:@"mainCellBackground"];
        image = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
    self.backgroundView =[[UIImageView alloc] initWithImage:image];

}

- (void)setPostModel:(LGShareImage *)postModel{
    
    _postModel = postModel;
    [self.authorButton setTitle:postModel.author.nickname forState:UIControlStateNormal];
    self.titleLable.text = postModel.title;
    self.viewsLable.text = [NSString stringWithFormat:@"%zd次阅读",[postModel.views integerValue]];
    self.commentsLable.text = [NSString stringWithFormat:@"%zd评论",[postModel.comment_count integerValue]];
    self.zanLabel.text = [NSString stringWithFormat:@"%zd点赞",[postModel.ding integerValue]];

    if (postModel.imageUrl.length) {
        [self.picImageView lg_setImageWithurl:postModel.imageUrl placeholderImage:nil];
        self.timeLable.text = postModel.date;
    }
    
 
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
