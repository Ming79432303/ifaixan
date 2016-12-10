//
//  LGVideoCell.h
//  ifaxian
//
//  Created by ming on 16/12/8.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGRecommend.h"
@interface LGVideoCell : UITableViewCell
@property(nonatomic, strong) LGRecommend *model;
@property (strong, nonatomic)  UIView *playerView;
@property (weak, nonatomic) IBOutlet UIImageView *starVideoButton;
@end
