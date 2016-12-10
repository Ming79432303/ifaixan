//
//  LGHomeTagsView.m
//  ifaxian
//
//  Created by ming on 16/12/6.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGHomeTagsView.h"

@implementation LGHomeTagsView

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    [self setupUI];
    
}

- (void)setupUI{
    
    
    //计算出文字的大小
    for (int i = 0; i < 3; i++) {
        
        UIButton *butn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [butn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        butn.titleLabel.font = [UIFont systemFontOfSize:13];
        [butn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
       [butn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [self addSubview:butn];
    }
    
    

    
}

- (void)setTags:(NSArray<LGHomeTage *> *)tags{
    _tags = tags;
#warning 多标签分页
    int index = 0;
    if (tags.count>0) {
        
        for (LGHomeTage *tag in tags) {
            
            CGSize titleSize = [tag.title boundingRectWithSize:CGSizeMake(self.frame.size.width - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
            UIButton *tagButton = self.subviews[index];
            NSLog(@"%@",tag.title);
            tagButton.hidden = NO;
            tagButton.frame = CGRectMake(index * (titleSize.width + LGCommonMargin), 2.5,titleSize.width +  LGCommonMargin, 20);
            [tagButton setTitle:[NSString stringWithFormat:@"#%@",tag.title] forState:UIControlStateNormal];
            
            
            index += 1;
            
        }
    }else{
        
        for (UIButton *butn in self.subviews) {
            butn.hidden = YES;
        }
    }
    
    
}

@end
