//
//  LGComment.h
//  ifaxian
//
//  Created by Apple_Lzzy27 on 16/11/17.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LGAuthor.h"

@interface LGComment : NSObject
/**
 *  评论内容
 */
@property (nonatomic, copy) NSString *content;
/**
 *  评论时间
 */
@property (nonatomic, copy) NSString *date;
/**
 *  评论id
 */
@property (nonatomic, copy) NSString *ID;
/**
 *  评论的名称
 */
@property (nonatomic, copy) NSString *name;
/**
 *  父评论
 */
@property (nonatomic, copy) NSString *parent;
/**
 *评论者  
 */
@property (nonatomic, strong) LGAuthor *author;

@property(nonatomic, assign) CGFloat rowHeght;
@property(nonatomic, assign) CGFloat replyHeght;


@end
