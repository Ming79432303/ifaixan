//
//  LGTagView.m
//  标签
//
//  Created by ming on 16/11/29.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGTagView.h"
#import "UIView+Frame.h"

@interface LGTagView()
@property(nonatomic, strong) NSMutableArray *arrayM;
#define btnW 41.43
#define butnH 28.8
@end;

@implementation LGTagView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
    }
    
    return self;
}
- (NSMutableArray *)arrayM{
    
    if (_arrayM == nil) {
        _arrayM = [NSMutableArray array];
    }
    
    return _arrayM;
}


- (void)setupUI{
    
//    NSArray *tags = @[@"Hack Your life",@"动漫",@"发现",@"知乎",@"知道",@"加德纳",@"黑贼王",@"sda",@"发现",@"Hack Your life",@"动漫",@"发现",@"知乎",@"知道",@"加德纳",@"黑贼王",@"sda",@"发现"];
    //计算出最小高宽度
    
    
    
}
- (void)layoutButn{

    int index = 0;
    CGFloat sum = 0;
    int j = 0;
    for (UIButton *butn in self.subviews) {
        butn.lg_height = butnH;
        if ([self.arrayM[index] doubleValue] + sum > self.lg_width) {
            butn.lg_x = 0;
            sum = 0;
            j++;
        }
        butn.lg_y = j * (butn.lg_height + 10);
        butn.lg_width = [self.arrayM[index] doubleValue];
        butn.lg_x = sum;
        butn.backgroundColor = [UIColor redColor];
        sum += butn.lg_width  + 10;
        index += 1;
    }
   
}
- (void)setTags:(NSArray<LGTag *> *)tags{
    _tags = tags;
    int i = 0;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (LGTag *tag in tags){
#warning 按钮重复添加
        //计算出文字的大小
        CGSize titleSize = [tag.title boundingRectWithSize:CGSizeMake(self.frame.size.width - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
        UIButton *butn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.arrayM addObject:@(titleSize.width + 25)];
        [butn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [butn setTitle:tag.title forState:UIControlStateNormal];
        butn.titleLabel.font = [UIFont systemFontOfSize:13];
        UIImage *image = [UIImage imageNamed:@"mainCellBackground"];
        image = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
        [butn setBackgroundImage:image forState:UIControlStateNormal];

        
        [self addSubview:butn];
        i ++;
    }
    [self layoutButn];

    
}




@end
