//
//  LGMyarticleController.h
//  ifaxian
//
//  Created by ming on 16/11/21.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGBasiController.h"
#import "LGArticleModel.h"
#import "LGArticleCell.h"
#import "LGEditorController.h"
#import "LGSquareCell.h"
#import "LGShare.h"
#import "LGActivityViewModel.h"
#import "LGShareController.h"
@interface LGMyArticleController : UITableViewController
@property (nonatomic, strong) NSArray<LGShare *> *postsArrayM;
@property (nonatomic, strong) LGActivityViewModel *postList;
@property(nonatomic, copy) NSString *userName;
- (void)setupTableView;
@end
