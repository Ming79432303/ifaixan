//
//  LGActivityCell.m
//  ifaxian
//
//  Created by ming on 16/12/17.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGActivityCell.h"
#import "LGActivityUser.h"
#import "LGUserController.h"
#import "LGAuthor.h"
#import "LGUserActivityDisplayController.h"
#import "LWImageBrowser.h"
@interface LGActivityCell()
/**
 *  头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
/**
 *  昵称
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
/**
 *  活动的方式
 */
@property (weak, nonatomic) IBOutlet UILabel *actionLable;
/**
 *  时间
 */
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
/**
 *  文章的标题如果评论则是评论的标题
 */
@property (weak, nonatomic) IBOutlet UILabel *contenLable;
/**
 *  图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *picIImageView;
/**
 *  评论的内容
 */
@property (weak, nonatomic) IBOutlet UILabel *commentText;

@end

@implementation LGActivityCell
#pragma mark - nib加载完毕 添加手势
- (void)awakeFromNib{
    [super awakeFromNib];
    self.contentView.backgroundColor = LGCommonColor;
    //头像点击手势跳转用户界面
    UITapGestureRecognizer *avatarTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(go2userVc)];
    [_iconImageView addGestureRecognizer:avatarTap];
    
     //昵称点击手势跳转用户界面
    UITapGestureRecognizer *nameLableTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(go2userVc)];
    [_nameLable  addGestureRecognizer:nameLableTap];

      //昵称点击手势跳转展示文章界面
    UITapGestureRecognizer *titleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(go2display)];
    [_contenLable  addGestureRecognizer:titleTap];
    
     //图片点击查看手势
    UITapGestureRecognizer *picTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeImage)];
    [_picIImageView  addGestureRecognizer:picTap];
    
}
#pragma mark - 跳转用户界面
- (void)go2userVc{
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:NSStringFromClass([LGUserController class]) bundle:nil];
    LGUserController *userVc = [story instantiateInitialViewController];
    LGAuthor *author = [[LGAuthor alloc] init];
    author.nickname = _model.user.display_name;
    author.name = _model.user.username;
    author.slug = _model.user.username;
    userVc.author = author;
    UITabBarController *tab = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = tab.selectedViewController;
    [nav pushViewController:userVc animated:YES];

    
}
#pragma mark - 跳转文章展示界面
- (void)go2display{
    
    NSString *url = _model.linkAndText.firstObject;
    LGUserActivityDisplayController *displayVc = [[LGUserActivityDisplayController alloc] init];
    displayVc.postUrl = url;
    UITabBarController *tab = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = tab.selectedViewController;
    [nav pushViewController:displayVc animated:YES];
}
#pragma mark - 点击图片
- (void)seeImage{
    
    NSURL *url = [NSURL URLWithString:self.model.imageUrl];
    
    LWImageBrowserModel *model = [[LWImageBrowserModel alloc] initWithplaceholder:nil thumbnailURL:url HDURL:url containerView:self positionInContainer:self.picIImageView.frame index:0];
    LWImageBrowser *imageBrow = [[LWImageBrowser alloc] initWithImageBrowserModels:@[model] currentIndex:0];
    imageBrow.isShowPageControl = NO;
    [imageBrow show];

    
}
#pragma mark - 模型赋值
- (void)setModel:(LGActivitie *)model{
    
    _model = model;
    
    //发布了一条评论
    NSString *actionStr;
    if ([model.type isEqualToString:@"new_blog_comment"]) {
     actionStr =  @"发布了一条评论";
        _contenLable.text = [NSString stringWithFormat:@"#%@",model.linkAndText.lastObject];
        _commentText.text = model.contenText;
    }else if([model.type isEqualToString:@"new_blog_post"]){
        //发布了一条动态
        actionStr = @"发布了一条动态";
        _contenLable.text = [NSString stringWithFormat:@"#%@",model.linkAndText.lastObject];
        _commentText.text = nil;
    }
    _nameLable.text = model.user.display_name;
    _timeLable.text = model.time;
    _actionLable.text = actionStr;
   
    [_picIImageView lg_setImageWithurl:model.imageUrl placeholderImage:nil];
    [_iconImageView setHeader:[model.user.username lg_getuserAvatar]];
}
- (void)setFrame:(CGRect)frame{
    
    CGRect cellFrame = frame;

    cellFrame.origin.y += LGCommonMargin;
    
    
    [super setFrame:cellFrame];
    
}

@end
