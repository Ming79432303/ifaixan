//
//  NSURL+LGImageSave.h
//  ifaxian
//
//  Created by ming on 16/12/6.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (LGImageSave)
- (void)lg_saveImage:(void(^)(bool isSuccess ,NSString * info))completion;
@end
