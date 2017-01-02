//
//  LGSquareCell.h
//  ifaxian
//
//  Created by ming on 16/11/30.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGShare.h"
/**
 *  用户分享界面的cell
 */
@interface LGSquareCell : UITableViewCell
/**
 *  单篇文章模型
 */
@property(nonatomic, strong) LGShare *model;
/**
 *  工具条
 */
@property (weak, nonatomic) IBOutlet UIView *toolView;
/**
 *  用来展示的视频播放
 */
@property(nonatomic, strong) UIView *playerView;
@end
