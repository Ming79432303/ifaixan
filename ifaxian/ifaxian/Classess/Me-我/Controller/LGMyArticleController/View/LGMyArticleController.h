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
/**
 *  用来显示用户已经发布的数据的数据
 */
@interface LGMyArticleController : UITableViewController
/**
 *  用户的数据
 */
@property (nonatomic, strong) NSArray<LGShare *> *postsArrayM;
/**
 *  viewModel
 */
@property (nonatomic, strong) LGActivityViewModel *postList;
/**
 *  用户的名字
 */
@property(nonatomic, copy) NSString *userName;
- (void)setupTableView;
@end
