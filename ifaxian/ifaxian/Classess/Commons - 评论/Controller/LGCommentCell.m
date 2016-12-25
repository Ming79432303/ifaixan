//
//  LGCommentCell.m
//  ifaxian
//
//  Created by ming on 16/11/18.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGCommentCell.h"
#import "LGReplyView.h"
#import "LGUserController.h"
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
    UITapGestureRecognizer *avatarTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(go2userVc:)];
   
    [_avatarImageView addGestureRecognizer:avatarTap];
     UITapGestureRecognizer *nameLableTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(go2userVc:)];
    
     [_nameLable  addGestureRecognizer:nameLableTap];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)go2userVc:(id)sender {
    
 
    UIStoryboard *story = [UIStoryboard storyboardWithName:NSStringFromClass([LGUserController class]) bundle:nil];
    LGUserController *userVc = [story instantiateInitialViewController];
    userVc.author =_comment.author;
    UITabBarController *tab = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = tab.selectedViewController;
    [nav pushViewController:userVc animated:YES];

    
    
}

- (void)comment:(LGComment *)comment parentComment:(LGComment *)parent{
    _comment = comment;
    if (comment.parent.length) {
       
        self.replyView.titleLable.text = [NSString stringWithFormat:@"@%@ 发表于 %@", parent.author.nickname,parent.date];
        self.replyView.contentText.text = parent.content;
        
        
    }
    self.contenLable.text = comment.content;
    [self.avatarImageView setHeader:[comment.author.slug lg_getuserAvatar]];
    self.nameLable.text = comment.author.nickname;
    self.timeLable.text = comment.date;
 
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
