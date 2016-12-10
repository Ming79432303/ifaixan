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
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titileLable;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UIButton *categoryButton;
@property(nonatomic, strong) LGHomeModel *model;

@end
