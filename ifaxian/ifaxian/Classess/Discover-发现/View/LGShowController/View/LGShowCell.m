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

- (LGShowController *)showVc{
    
    if (_showVc == nil) {
        _showVc = [[LGShowController alloc] init];
        
    }
    
    return _showVc;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupUI];

      
    }
    
    return self;
}
//添加首页分类的展示
- (void)setupUI{
    
    self.showVc = _showVc;
    
    self.showVc.view.frame = self.contentView.frame;
  
    [self addSubview:self.showVc.view];
    
    
}

@end
