//
//  LGUserInfoCell.m
//  ifaxian
//
//  Created by ming on 16/12/13.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGUserInfoCell.h"
#import "UIImageView+LGUIimageView.h"
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
    
    
    if ([model.parameter isEqualToString:@"basic_user_avatar"] || [model.parameter isEqualToString:@"bac"]) {
        self.iconImageView.hidden = NO;
        if ([model.title isEqualToString:@"bac"]) {
            
            [self.iconImageView lg_setImageWithurl:model.content placeholderImage:nil];
            self.rightTitle.text = model.title;
            _userTitleLable.text = nil;
            return;
        }
        [self.iconImageView lg_setCircularImageWithurl:model.content placeholderImage:nil];
        self.rightTitle.text = model.title;
        _userTitleLable.text = nil;
        
   
        
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
