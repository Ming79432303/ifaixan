//
//  LGSquareCell.h
//  ifaxian
//
//  Created by ming on 16/11/30.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGShare.h"
@interface LGSquareCell : UITableViewCell
@property(nonatomic, strong) LGShare *model;
@property (weak, nonatomic) IBOutlet UIView *toolView;
@property(nonatomic, strong) UIView *playerView;
@end
