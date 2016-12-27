//
//  LGTopModel.h
//  ifaxian
//
//  Created by ming on 16/12/25.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGPostModel.h"

@interface LGTopModel : LGPostModel
@property(nonatomic, assign) CGSize originalImageSize;
@property(nonatomic, assign) CGSize imageSize;
@property(nonatomic, copy) NSString *contentText;
@property(nonatomic, copy) NSString *videoUrl;
@property(nonatomic, assign) CGFloat xhCellHeght;
@property(nonatomic, assign) CGFloat dmCellHeght;
@property(nonatomic, assign) CGFloat VideoCellHeght;
@end
