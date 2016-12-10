//
//  LGHomeCommntContentView.m
//  ifaxian
//
//  Created by ming on 16/12/6.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGHomeCommntContentView.h"

@interface LGHomeCommntContentView()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *contenLable;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;

@end

@implementation LGHomeCommntContentView




- (void)setComment:(LGComment *)comment{
    
    _comment = comment;
    
//    self.contenLable.text = comment.content;
//    self.nameLable.text = [NSString stringWithFormat:@"%@:",comment.name];

    
}



@end
