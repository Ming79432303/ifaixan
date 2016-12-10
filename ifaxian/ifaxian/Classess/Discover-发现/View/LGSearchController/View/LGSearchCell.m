//
//  LGSearchCell.m
//  ifaxian
//
//  Created by ming on 16/11/26.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGSearchCell.h"

@interface LGSearchCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *describeLable;

@property (weak, nonatomic) IBOutlet UILabel *timeLable;

@end

@implementation LGSearchCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(LGPostModel *)model{
    
    _model = model;
    
    self.titleLable.text = model.title;
    
    self.describeLable.text = model.excerpt;
    
    self.timeLable.text = model.date;
    
    
}

@end
