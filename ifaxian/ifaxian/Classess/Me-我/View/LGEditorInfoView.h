//
//  LGEditorInfoView.h
//  ifaxian
//
//  Created by ming on 16/12/14.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LGEditorInfoView;
@protocol LGEditorInfoViewDelegate <NSObject>

- (void)editoruserInfo:(LGEditorInfoView *)edtiorView;

@end

@interface LGEditorInfoView : UIView
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property(nonatomic, weak) id <LGEditorInfoViewDelegate> delegate;
@end
