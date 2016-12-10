//
//  LGShareController.h
//  ifaxian
//
//  Created by ming on 16/12/1.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGBasiController.h"
#import "LGShare.h"
#import "LGPostModel.h"
#import "LGCommentController.h"
@interface LGShareController :LGCommentController
@property(nonatomic, strong) LGShare *share;
@end
