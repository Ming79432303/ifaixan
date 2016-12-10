//
//  LGRecommend.h
//  ifaxian
//
//  Created by ming on 16/12/7.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGPostModel.h"

@interface LGRecommend : LGPostModel
@property(nonatomic, copy) NSString *imageUrl;
@property(nonatomic, assign) CGSize originalImageSize;
@property(nonatomic, assign) CGSize imageSize;
@property(nonatomic, copy) NSString *contentText;
@property(nonatomic, copy) NSString *videoUrl;
@property(nonatomic, assign) CGFloat xhCellHeght;
@property(nonatomic, assign) CGFloat dmCellHeght;
@property(nonatomic, assign) CGFloat VideoCellHeght;
@end
