//
//  LGImage.h
//  ifaxian
//
//  Created by ming on 16/11/17.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGImageSize.h"
@interface LGImage : NSObject

@property(nonatomic, strong) LGImageSize *full;
@property(nonatomic, strong) LGImageSize *large;
@property(nonatomic, strong) LGImageSize *medium;
@property(nonatomic, strong) LGImageSize *thumbnail;

@end
