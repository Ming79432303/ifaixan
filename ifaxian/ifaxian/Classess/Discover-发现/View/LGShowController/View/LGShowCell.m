//
//  LGShowCell.m
//  ifaxian
//
//  Created by ming on 16/11/27.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGShowCell.h"
#import "LGShowController.h"
@interface LGShowCell()
@property(nonatomic, strong) LGShowController *showVc;

@end;


@implementation LGShowCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupUI];
      
    }
    
    return self;
}
- (void)setupUI{
    
    LGShowController *showVc = [[LGShowController alloc] init];
    self.showVc = showVc;
    showVc.view.frame = self.contentView.frame;
  
    [self addSubview:showVc.view];
    
    
}
@end
