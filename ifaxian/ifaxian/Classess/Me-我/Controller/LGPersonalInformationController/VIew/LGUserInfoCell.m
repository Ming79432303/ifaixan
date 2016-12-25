//
//  LGUserInfoCell.m
//  ifaxian
//
//  Created by ming on 16/12/13.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGUserInfoCell.h"
#import "UIImageView+LGUIimageView.h"
#import "UIImage+lg_image.h"
@interface LGUserInfoCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *userTitleLable;
@property (weak, nonatomic) IBOutlet UILabel *rightTitle;

@end
@implementation LGUserInfoCell

- (void)awakeFromNib {
    // Initialization code
    self.autoresizingMask = UIViewAutoresizingNone;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}


- (void)setModle:(LGUserList *)model section:(NSInteger)section;{
    
    
    
    if ([model.parameter isEqualToString:@"lg_user_avatar"] || [model.parameter isEqualToString:@"bac"]) {
        _userTitleLable.hidden = YES;
        self.iconImageView.hidden = NO;
                self.rightTitle.text = model.title;
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSString *urlstr = [NSString stringWithFormat:@"%@ifaxian/avatars/%@%@.jpg",LGbuckeUrl,[LGNetWorkingManager manager].account.user.username,model.parameter];
                NSLog(@"%@",urlstr);
                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlstr]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIImage *image = [UIImage imageWithData:imageData];
                 _iconImageView.image = [image lg_avatarImagesize:_iconImageView.bounds.size backColor:[UIColor whiteColor] lineColor:[UIColor whiteColor]];
                });
                
            });
    
        
    }else if (section == 0){
         self.iconImageView.hidden = YES;
        self.userTitleLable.text = model.title;
        if ([model.title isEqualToString:@"用户身份"]) {
            if ([model.content containsString:@"administrator"]) {
                self.rightTitle.text = @"超级管理员";
            }else{
                self.rightTitle.text = @"普通用户";
            }
        }else{
            
           
            self.rightTitle.text = model.content;
        
        }

        
    }else{
        self.iconImageView.hidden = YES;
        self.userTitleLable.text = model.title;
        self.rightTitle.text = model.content;
  
    }

    
}

- (void)setFrame:(CGRect)frame{
    
    CGRect cellFrame = frame;
    cellFrame.size.height -= 1;
    cellFrame.size.width -= 2 * LGCommonSmallMargin;
    cellFrame.origin.x += LGCommonSmallMargin;
    cellFrame.origin.y += LGCommonMargin;
    
    [super setFrame:cellFrame];
    
}
@end
