//
//  LGTextView.m
//  ifaxian
//
//  Created by ming on 16/12/4.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGTextView.h"
@interface LGTextView() <UITextViewDelegate>
@property(nonatomic, strong) UILabel *textLable;
@end
@implementation LGTextView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    [self setupUI];
    
}

- (void)setupUI{
    
    UILabel *textLable = [[UILabel alloc] init];
    self.textLable = textLable;
    self.font = [UIFont systemFontOfSize:14];
    textLable.font = self.font;
    textLable.text = @"说点什么吧..";
    textLable.frame = CGRectMake(7, 7, 200, self.font.lineHeight);
    textLable.textColor = [UIColor lightGrayColor];
    
    [self addSubview:textLable];
    
    self.delegate = self;
    
    
}

- (void)textViewDidChange:(UITextView *)textView{
    
    
    self.textLable.hidden = self.text.length != 0 ? YES:NO;
    NSLog(@"%f",textView.contentSize.height);
}



@end
