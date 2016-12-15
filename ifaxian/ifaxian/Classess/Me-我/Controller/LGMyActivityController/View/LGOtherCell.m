//
//  LGOtherCell.m
//  ifaxian
//
//  Created by ming on 16/12/14.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGOtherCell.h"
#import "LGOtherArrow.h"
#import "LGOtherNone.h"

@interface LGOtherCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *othertitleLable;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLable;

@end


@implementation LGOtherCell
- (void)awakeFromNib {
    // Initialization code

}

- (void)setModel:(LGOther *)model{
    self.iconImageView.image = [UIImage imageNamed:model.imageName];
    self.othertitleLable.text = model.title;
    if ([model isKindOfClass:[LGOtherArrow class]]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.subTitleLable.text = nil;
    }else{
        LGOtherNone *noneModel = (LGOtherNone *)model;
          self.accessoryType = UITableViewCellAccessoryNone;
        self.subTitleLable.text = noneModel.detailText;
        
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
