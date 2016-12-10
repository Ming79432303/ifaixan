//
//  LGTextField.m
//  ifaxian
//
//  Created by ming on 16/11/20.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGTextField.h"
#import "UITextField+LGTextField.h"
@implementation LGTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.leftView.lg_x = 5;
    
    
}
- (void)awakeFromNib{
    
    [super awakeFromNib];
    // 设置光标颜色
    self.tintColor = [UIColor lg_colorWithRed:153 green:51 blue:102];
    // 设置默认的占位文字颜色
    
    self.textColor = [UIColor darkGrayColor];
    //
   
    
}
- (BOOL)becomeFirstResponder{
    
    self.lg_placeholderColor = [UIColor lg_colorWithRed:153 green:51 blue:102];
    
      
    
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder{
    
    
    self.lg_placeholderColor = nil;
    
    return [super resignFirstResponder];
}



@end
