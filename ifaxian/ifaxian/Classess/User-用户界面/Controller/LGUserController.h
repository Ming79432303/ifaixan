//
//  ViewController.h
//  06-微博个人详情页
//
//  Created by xiaomage on 15/9/7.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGAuthor.h"
@interface LGUserController : UIViewController
/**
 *  传入一个用户信息
 */
@property(nonatomic, strong) LGAuthor *author;
@end

