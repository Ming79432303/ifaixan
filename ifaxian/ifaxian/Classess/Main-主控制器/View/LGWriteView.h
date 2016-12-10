//
//  LGWriteView.h
//  ifaxian
//
//  Created by ming on 16/11/29.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LGWriteView;
@protocol LGWriteViewDelegate <NSObject>

- (void)removerConverViewWriteView:(LGWriteView *)writeView;

@end

@interface LGWriteView : UIView
@property(nonatomic, weak) id<LGWriteViewDelegate> delegate;
@end
