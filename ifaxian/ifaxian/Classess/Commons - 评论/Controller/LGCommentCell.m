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
/**
 *  用户头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
/**
 *  用户昵称
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
/**
 *  回复评论按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
/**
 *  评论内容
 */
@property (weak, nonatomic) IBOutlet UILabel *contenLable;
/**
 *  回复的评论
 */
@property (weak, nonatomic) IBOutlet  LGReplyView *replyView;
/**
 *  评论的时间
 */
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@end


@implementation LGCommentCell

#pragma mark - nib加载完毕方法
- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    //取消autoresizing    self.autoresizingMask = UIViewAutoresizingNone;
    //添加头像名字手势跳转到用户界面
    UITapGestureRecognizer *avatarTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(go2userVc:)];
    [_avatarImageView addGestureRecognizer:avatarTap];
     UITapGestureRecognizer *nameLableTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(go2userVc:)];
     [_nameLable  addGestureRecognizer:nameLableTap];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - 跳转用户界面
- (IBAction)go2userVc:(id)sender {
    
 
    UIStoryboard *story = [UIStoryboard storyboardWithName:NSStringFromClass([LGUserController class]) bundle:nil];
    LGUserController *userVc = [story instantiateInitialViewController];
    userVc.author =_comment.author;
    UITabBarController *tab = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = tab.selectedViewController;
    [nav pushViewController:userVc animated:YES];

    
    
}
#pragma mark - 评论和父评论逻辑处理
- (void)comment:(LGComment *)comment parentComment:(LGComment *)parent{
    _comment = comment;
    //如果存在父评论
    if (comment.parent.length) {
        self.replyView.titleLable.text = [NSString stringWithFormat:@"@%@ 发表于 %@", parent.author.nickname,parent.date];
        self.replyView.contentText.text = parent.content;
    }else{
        self.replyView.titleLable.text = nil;
        self.replyView.contentText.text = nil;
    }
    //内容
    self.contenLable.text = comment.content;
    //头像
    [self.avatarImageView setHeader:[comment.author.slug lg_getuserAvatar]];
    //昵称
    self.nameLable.text = comment.author.nickname;
    //时间
    self.timeLable.text = comment.date;
 
}
#pragma mark - 修改cell的大小
- (void)setFrame:(CGRect)frame{
    
    CGRect cellFrame = frame;
    cellFrame.size.height -= 1;
    cellFrame.size.width -= 2 * LGCommonSmallMargin;
    cellFrame.origin.x += LGCommonSmallMargin;
    cellFrame.origin.y += LGCommonMargin;
    
    
    [super setFrame:cellFrame];
    
}

- (IBAction)jubao:(id)sender {
    [LGJubaoView showView];
}


@end
