//
//  LGUserInfoCell.h
//  ifaxian
//
//  Created by ming on 16/12/13.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGUserList.h"
@interface LGUserInfoCell : UITableViewCell
@property(nonatomic, strong) LGUserList *model;

- (void)setModle:(LGUserList *)model section:(NSInteger)section;

@end
