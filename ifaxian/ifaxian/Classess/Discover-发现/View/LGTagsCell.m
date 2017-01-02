//
//  LGTagsCell.m
//  ifaxian
//
//  Created by ming on 16/11/28.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGTagsCell.h"
#import "LGTagView.h"
@interface LGTagsCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) LGTagView *tagView;
@end


@implementation LGTagsCell
#pragma mark - nib加载完毕添加标签View
- (void)awakeFromNib {
    [super awakeFromNib];
    LGTagView *tagView = [[LGTagView alloc] init];
    tagView.backgroundColor = [UIColor whiteColor];
    tagView.frame = self.contentView.bounds;
    [self.contentView addSubview:tagView];
    self.tagView = tagView;
    
    
}
#pragma mark - 布局tagView的frame
- (void)layoutSubviews{
    [super layoutSubviews];
    self.tagView.lg_y = LGCommonMargin;
    self.tagView.lg_x = LGCommonMargin;
    self.tagView.lg_width = [UIScreen lg_screenWidth] - 2*LGCommonMargin;
    self.tagView.lg_height = self.lg_height - LGCommonMargin;
    
    
}
#pragma mark - 模型复制
- (void)setTags:(NSArray *)tags{
    if (_tags.count) {
        return;
    }
    _tags = tags;
    if (tags.count > 20) {
        self.tagView.tags = [tags subarrayWithRange:NSMakeRange(0, 20)];
    }else{
        
        self.tagView.tags = tags;
    }
    
    
}

@end
