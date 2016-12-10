//
//  LGDisplayController.h
//  ifaxian
//
//  Created by ming on 16/11/18.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Gallop.h"
#import "LGPostModel.h"
#import "LGEditorController.h"
#import <WPEditorViewController.h>
@interface LGDisplayController :  WPEditorViewController <WPEditorViewControllerDelegate>
@property(nonatomic, strong) LGPostModel *model;
@property(nonatomic, strong) NSMutableDictionary *mediaAdded;
@property(nonatomic, strong) NSString *selectedMediaID;
@property(nonatomic, strong) NSCache *videoPressCache;
@end
