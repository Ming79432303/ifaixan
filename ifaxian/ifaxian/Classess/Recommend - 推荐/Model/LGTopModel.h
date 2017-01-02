//
//  LGTopModel.h
//  ifaxian
//
//  Created by ming on 16/12/25.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGPostModel.h"

@interface LGTopModel : LGPostModel
/**
 *  图片原始的size
 */
@property(nonatomic, assign) CGSize originalImageSize;
/**
 *  图片的size
 */
@property(nonatomic, assign) CGSize imageSize;
/**
 *  内容
 */
@property(nonatomic, copy) NSString *contentText;
/**
 *  图片的url
 */
@property(nonatomic, copy) NSString *videoUrl;
/**
 *  笑话界面的行高
 */
@property(nonatomic, assign) CGFloat xhCellHeght;
/**
 *  动漫界面的行高
 */
@property(nonatomic, assign) CGFloat dmCellHeght;
/**
 *  视频界面的行高
 */
@property(nonatomic, assign) CGFloat VideoCellHeght;
@end
