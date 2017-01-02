//
//  LGRecommend.h
//  ifaxian
//
//  Created by ming on 16/12/7.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGPostModel.h"

@interface LGRecommend : LGPostModel
/**
 *  图片原始的size
 */
@property(nonatomic, assign) CGSize originalImageSize;
/**
 *  等比例缩放后的图片尺寸
 */
@property(nonatomic, assign) CGSize imageSize;
/**
 *  内容
 */
@property(nonatomic, copy) NSString *contentText;
/**
 *  视频的url
 */
@property(nonatomic, copy) NSString *videoUrl;
/**
 *  笑话界面的高度
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
/**
 *  倔物界面的行高
 */
@property(nonatomic, assign) CGFloat jueWuHeight;
/**
 *  描述
 */
@property(nonatomic, copy) NSString *descriptions;
@end
