//
//  LGEditorInfoView.m
//  ifaxian
//
//  Created by ming on 16/12/14.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGEditorInfoView.h"
@interface LGEditorInfoView()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewBottomMargin;

@end
@implementation LGEditorInfoView

- (void)awakeFromNib{
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
      self.viewBottomMargin.constant = -150;
    [self.textField becomeFirstResponder];
    
}

- (void)textViewFrameChange:(NSNotification *)noti{
    CGRect rect = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    
    CGFloat offset = self.lg_height - rect.origin.y;
   
    self.viewBottomMargin.constant = offset;
    
    [UIView animateWithDuration:[noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        [self layoutIfNeeded];
        
    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.textField resignFirstResponder];
    [self removeFromSuperview];
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (IBAction)updataUserInfo:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(editoruserInfo:)]) {
        [self.delegate editoruserInfo:self];
    }
    
}

@end
