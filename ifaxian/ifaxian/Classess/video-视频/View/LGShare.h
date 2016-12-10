//
//  LGShare.h
//  ifaxian
//
//  Created by ming on 16/11/30.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LGShareImage.h"
@interface LGShare : NSObject
@property(nonatomic, strong) LGShareImage *share;
@property(nonatomic, strong) NSArray *images;
@property(nonatomic, assign) CGFloat rowHeight;
@property(nonatomic,assign) CGSize oneImageSize;
@property(nonatomic, copy) NSString *VideoUrl;
@property(nonatomic, assign) CGRect videoViewFrame;
@property(nonatomic, strong) UIImage *videoImage;

typedef NS_ENUM(NSInteger , LGPictures) {
    LGOnePictures = 1,
    LGTwoPictures = 2,
    LGFourpictures = 4
};

-(instancetype)initWithModel:(LGShareImage *)share;
- (void)calculateOneHeight:(CGSize)imageSize;
@end
