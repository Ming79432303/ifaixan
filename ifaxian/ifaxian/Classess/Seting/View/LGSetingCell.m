//
//  LGSetingCell.m
//  ifaxian
//
//  Created by ming on 16/12/10.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGSetingCell.h"

@implementation LGSetingCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)setFrame:(CGRect)frame{
    
    CGRect cellFrame = frame;
    
    
    cellFrame.origin.y += LGCommonMargin;
    
    [super setFrame:cellFrame];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
