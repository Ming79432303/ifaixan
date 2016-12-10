//
//  LGAttachment.h
//  ifaxian
//
//  Created by ming on 16/11/17.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LGImage.h"
@interface LGAttachment : NSObject
@property(nonatomic, assign) NSInteger parent;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *url;
@property(nonatomic, strong) LGImage *images;
@property(nonatomic, copy) NSString *mime_type;

@end
