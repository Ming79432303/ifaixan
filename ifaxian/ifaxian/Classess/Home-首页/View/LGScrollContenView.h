//
//  LGScrollContenView.h
//  ifaxian
//
//  Created by ming on 16/11/25.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGHomeModel.h"
@interface LGScrollContenView : UIView
/**
 *  轮播器显示的图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
/**
 *  标题
 */
@property (weak, nonatomic) IBOutlet UILabel *titileLable;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
/**
 *  分类
 */
@property (weak, nonatomic) IBOutlet UIButton *categoryButton;
/**
 *  模型
 */
@property(nonatomic, strong) LGHomeModel *model;

@end
