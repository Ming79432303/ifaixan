//
//  LGreplyView.h
//  ifaxian
//
//  Created by Apple_Lzzy27 on 16/11/19.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LGReplyView : UIView
/**
 *  回复评论的昵称+时间
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
/**
 *  回复评论的内容
 */
@property (weak, nonatomic) IBOutlet UILabel *contentText;

@end
