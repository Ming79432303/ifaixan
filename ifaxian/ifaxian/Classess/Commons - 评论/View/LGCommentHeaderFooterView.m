//
//  LGCommentHeaderFooterView.m
//  ifaxian
//
//  Created by ming on 16/12/16.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGCommentHeaderFooterView.h"

@implementation LGCommentHeaderFooterView


- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = LGCommonColor;
    }
     return self;
}

@end
