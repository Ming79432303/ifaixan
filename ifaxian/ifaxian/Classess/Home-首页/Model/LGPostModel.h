//
//  LGPostModel.h
//  ifaxian
//
//  Created by Apple_Lzzy27 on 16/11/17.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LGAuthor.h"
#import "LGCategories.h"
#import "LGComment.h"
#import "LGCustomFields.h"
#import "LGAttachment.h"
#import "LGCategories.h"
@interface LGPostModel : NSObject
///附件
///日期
@property (nonatomic, strong) NSString *date;
///作者
@property (nonatomic, strong) LGAuthor *author;
/**
 *  描述
 */
@property (nonatomic, strong) NSString *excerpt;
/**
 *  文章地址
 */
@property (nonatomic, strong) NSString *url;
@property (nonatomic, assign) NSInteger ID;
/**
 *  评论数
 */
@property (nonatomic, copy) NSString * comment_count;
/**
 *  标题
 */
@property (nonatomic, strong) NSString *title;

/**
 *  评论
 */
@property (nonatomic, strong) NSArray<LGComment *> *comments;
/**
 *  内容
 */
@property (nonatomic,strong)  NSString *content;
/**
 *  顶和与看数
 */
@property(nonatomic, strong) LGCustomFields *custom_fields;
/**
 *  点赞数
 */
@property(nonatomic, copy) NSString *ding;
/**
 *  浏览数
 */
@property(nonatomic, copy) NSString *views;
/**
 *  分类
 */
@property(nonatomic, strong) NSArray<LGCategories *> *categories;
/**
 *  附件
 */
@property(nonatomic, strong)  LGAttachment *attachment;
/**
 *  缩略图
 */
@property(nonatomic, strong) LGImage *thumbnail_images;
/**
 *  文章的路径
 */
@property(nonatomic, copy) NSString *slug;
/**
 *  文章中的第一张图片地址
 */
@property(nonatomic, copy) NSString *imageUrl;

@end
