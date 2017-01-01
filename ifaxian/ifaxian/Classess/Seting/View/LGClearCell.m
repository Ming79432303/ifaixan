//
//  LGClearCell.m
//  ifaxian
//
//  Created by ming on 16/12/10.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGClearCell.h"
#import "NSString+LGFileSize.h"

@interface LGClearCell()
@property(nonatomic, weak) UIActivityIndicatorView *activitiView;

@end
@implementation LGClearCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
         [self filesize];
    }
    
    return self;
}
- (void)filesize{
    
    ///存在问题celld何时销魂问题
    ///当我点返回的时候就不应该往下走了
    UIActivityIndicatorView *activitiView = [[UIActivityIndicatorView alloc] init];
    self.activitiView = activitiView;
    self.textLabel.text = [NSString stringWithFormat:@"正在计算缓存"];
    self.userInteractionEnabled = NO;
    
    [activitiView setColor:[UIColor redColor]];
    self.accessoryView = activitiView;
    [activitiView startAnimating];
    
    __weak typeof(self) weakself = self;
    
    __block NSString *fileSize ;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        
        //计算大小
        fileSize = [weakself getSizeStr:LGfilePath];
        //在计算之后判断是够往下走
        // 如果cell已经销毁了, 就直接返回
        
        if (weakself == nil) {
            return ;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [activitiView stopAnimating];
            weakself.activitiView = nil;
            weakself.userInteractionEnabled = YES;
            NSString *sizeStr = fileSize ? fileSize:@"";
            weakself.textLabel.text = [NSString stringWithFormat:@"清除缓存%@",sizeStr];
            
            //[tableView reloadData];
            //添加手势
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:weakself action:@selector(clearDisk)];
            [weakself addGestureRecognizer:tap];
        });
        
    });
    
}

- (void)clearDisk{
    [self.activitiView startAnimating];
    self.textLabel.text = @"正在清除";
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    [SVProgressHUD showWithStatus:@"正在清除缓存.."];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        //删除文件
        NSFileManager *mnager = [NSFileManager defaultManager];
        dispatch_async(dispatch_get_main_queue(), ^{
            [NSThread sleepForTimeInterval:2];
            [mnager removeItemAtPath:LGfilePath error:nil];
            
            [mnager createDirectoryAtPath:LGfilePath withIntermediateDirectories:YES attributes:nil error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.activitiView stopAnimating];
                self.textLabel.text = [NSString stringWithFormat:@"清除缓存%@",[self getSizeStr:LGfilePath]];
                 [SVProgressHUD dismiss];
                [SVProgressHUD showSuccessWithStatus:@"清除缓存成功"];
                
               
                
                
            });
            
        });
        
    }];
    
}

-(NSString *)getSizeStr:(NSString *)path{
    
    NSString *fileSize ;
    unsigned long long size = path.lg_fileSize;
    [NSThread sleepForTimeInterval:2];
    
    //加上sd_image的缓存
    size += [SDImageCache sharedImageCache].getSize;
    if (size > pow(10, 9)) {//GB
        fileSize = [NSString stringWithFormat:@"%.2fG",size/pow(10, 9)];
    }else if (size > pow(10, 6)){
        fileSize = [NSString stringWithFormat:@"%.2fM",size/pow(10, 6)];
        
    }else if (size > pow(10, 3)){
        
        fileSize = [NSString stringWithFormat:@"%.2fk",size/pow(10, 3)];
    }else{
        fileSize = [NSString stringWithFormat:@"%zdB",size];
    }
    
    return fileSize;
}

- (void)setFrame:(CGRect)frame{
    
    CGRect cellFrame = frame;


   cellFrame.origin.y += LGCommonMargin;

    [super setFrame:cellFrame];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.activitiView startAnimating];
    
    
}



@end
