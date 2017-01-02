//
//  LGEditorController.h
//  ifaxian
//
//  Created by ming on 16/11/22.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <WPEditorViewController.h>
#import "LGArticleModel.h"
#import "WPEditorField.h"
#import "WPEditorView.h"
/**
 *  强大的富文本编辑器用户编辑用户的文章
 */
@interface LGEditorController : WPEditorViewController<WPEditorViewControllerDelegate>
@property(nonatomic, strong) LGPostModel *model;
@property(nonatomic, strong) NSMutableDictionary *mediaAdded;
@property(nonatomic, strong) NSString *selectedMediaID;
@property(nonatomic, strong) NSCache *videoPressCache;
@property(nonatomic, strong) UINavigationBar *navBar;
@property(nonatomic, strong)  UINavigationItem *navItem;
- (void)setupNav;
@end
