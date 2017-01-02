//
//  LGShare.h
//  ifaxian
//
//  Created by ming on 16/11/30.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LGShareImage.h"
/**
 *  单个分享界面cell的模型
 */
@interface LGShare : NSObject
/**
 *  单条数据模型
 */
@property(nonatomic, strong) LGPostModel *share;
/**
 *  用户发送的图片数组
 */
@property(nonatomic, strong) NSArray *images;
/**
 *  行高
 */
@property(nonatomic, assign) CGFloat rowHeight;
/**
 *  单张图的frame
 */
@property(nonatomic,assign) CGSize oneImageSize;
/**
 *  视频的URl
 */
@property(nonatomic, copy) NSString *VideoUrl;
/**
 *  视频的frame
 */
@property(nonatomic, assign) CGRect videoViewFrame;
/**
 *  视频的图片
 */
@property(nonatomic, strong) UIImage *videoImage;
/**
 *  用户的头像
 */
@property(nonatomic, copy) NSString *userAvatar;
/**
 *  图片类型
 */
typedef NS_ENUM(NSInteger , LGPictures) {
    /**
     *  一张图
     */
    LGOnePictures = 1,
    /**
     *  张图
     */
    LGTwoPictures = 2,
    /**
     *  三张图
     */
    LGFourpictures = 4
};
/**
 *  模型转换
 *
 *  @param share 单挑文章数据模型
 *
 *  @return 单条分享模型
 */
-(instancetype)initWithModel:(LGPostModel *)share;
/**
 *  一张图片的时候从新计算frame
 *
 */
- (void)calculateOneHeight:(CGSize)imageSize;
@end
