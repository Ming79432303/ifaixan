//
//  LGHomeCommentView.h
//  ifaxian
//
//  Created by ming on 16/12/6.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGComment.h"

@class LGHomeCommentView;
@protocol LGHomeCommentViewDelegate <NSObject>



@end
@interface LGHomeCommentView : UIScrollView

@property(nonatomic,strong) NSArray *comments;

-(void)commentViewSetOffset;
@end
