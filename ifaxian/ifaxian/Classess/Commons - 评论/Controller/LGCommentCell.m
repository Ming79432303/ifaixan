//
//  LGCommentCell.m
//  ifaxian
//
//  Created by ming on 16/11/18.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGCommentCell.h"
#import "LGReplyView.h"
@interface LGCommentCell()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLable;

@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UILabel *contenLable;

@property (weak, nonatomic) IBOutlet  LGReplyView *replyView;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@end


@implementation LGCommentCell

- (void)awakeFromNib {
    // Initialization code
    self.autoresizingMask = UIViewAutoresizingNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)comment:(LGComment *)comment parentComment:(LGComment *)parent{
    _comment = comment;
    if (comment.parent.length) {
        
        self.replyView.titleLable.text = [NSString stringWithFormat:@"@%@ 发表于 %@",parent.name,parent.date];
        self.replyView.contentText.text = parent.content;
        
        
    }
    self.contenLable.text = comment.content;
    
    self.nameLable.text = comment.name;
    self.timeLable.text = comment.date;
 
}
- (void)setFrame:(CGRect)frame{
    
    CGRect cellFrame = frame;
   
    cellFrame.size.width -= 2 * LGCommonMargin;
    cellFrame.origin.x += LGCommonMargin;

    
    
    
    [super setFrame:cellFrame];
    
}



@end
