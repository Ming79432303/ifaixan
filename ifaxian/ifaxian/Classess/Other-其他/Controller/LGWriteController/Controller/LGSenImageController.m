//
//  LGSenImageController.m
//  ifaxian
//
//  Created by ming on 16/11/29.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGSenImageController.h"
#import "LGPhotoNavigationController.h"
#import "LGAliYunOssUpload.h"
#import "LGTextView.h"
#import <YYImage.h>
#import "LGPhotoImage.h"
@interface LGSenImageController ()<LGAliYunOssUploadDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;

@property (weak, nonatomic) UIView *footView;
@property (strong ,nonatomic) LGAliYunOssUpload *upload;
@property (strong, nonatomic) NSMutableArray<LGPhotoImage *> *imagesArray;
@property (strong, nonatomic) NSMutableArray *imageUrls;
@property (weak, nonatomic) UITextView *textView;
@property (strong, nonatomic) LGPhotoImage *lastImage;
@property (nonatomic,strong) UIButton *sendButton;
@end

@implementation LGSenImageController

- (NSMutableArray *)imagesArray{
    if (_imagesArray == nil) {
        _imagesArray = [NSMutableArray array];
    }
    
    return _imagesArray;
}


- (LGAliYunOssUpload *)upload{
    if (_upload == nil) {
        _upload = [[LGAliYunOssUpload alloc] init];
    }
    
    return _upload;
}
- (NSMutableArray *)imageUrls{
    if (_imageUrls == nil) {
        _imageUrls = [NSMutableArray array];
    }
    
    return _imageUrls;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.upload.delegate = self;
    
    [self setupUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isSendButton) name:UITextViewTextDidChangeNotification object:self.textView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(images:) name:@"image" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeimage:) name:@"removeimage" object:nil];
    
    
    
}
//接收图片通知
- (void)images:(NSNotification *)noty{
    
    
    LGPhotoImage *photoImage = noty.userInfo[@"image"];
    if ([photoImage isKindOfClass:[LGPhotoImage class]]) {
        
        
        [self.imagesArray addObject:photoImage];
        
    }
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"n" object:self userInfo:@{@"count":@(self.imagesArray.count-1)}];
    
    
}
//移除图片通知
- (void)removeimage:(NSNotification *)noty{
    
    LGPhotoImage *photoImage = noty.userInfo[@"image"];
    if ([photoImage isKindOfClass:[LGPhotoImage class]]) {
        
        [self.imagesArray removeObject:photoImage];
        
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"n" object:self userInfo:@{@"count":@(self.imagesArray.count-1)}];
    
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)isSendButton {
    
    self.sendButton.enabled = self.textView.text.length ? YES : NO;
    
}

- (void)setupUI{
    
    LGTextView *textField = [[LGTextView alloc] init];
    textField.backgroundColor = [UIColor groupTableViewBackgroundColor];
    textField.frame = CGRectMake(0, 0, 200, 100);
    self.textView = textField;
    self.tableView.tableHeaderView = textField;
    
    
    
    UIView *footView = [[UIView alloc] init];
    
    footView.frame = CGRectMake(0, 0, 200, 200);
    
    self.tableView.tableFooterView = footView;
    
    self.footView = footView;
    
    UIImage *addImage = [UIImage imageNamed:@"添加图片"];
    LGPhotoImage *lastImage = [LGPhotoImage phototisGif:NO image:addImage imageData:nil];
    self.lastImage = lastImage;
    [self.imagesArray addObject:lastImage];
    [self setupImages:self.imagesArray];
    
    //添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    
    [self.tableView addGestureRecognizer:tap];
    
    
    //右边按钮
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sendButton = button;
    
    [button setBackgroundImage:[UIImage imageNamed:@"common_button_white_disable"] forState:UIControlStateNormal];
    //[button setBackgroundImage:[UIImage imageNamed:@"common_button_orange_highlighted"] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageNamed:@"common_button_white_disable"] forState:UIControlStateDisabled];
    
    button.frame = CGRectMake(0, 0, 45, 36);
    [button setTitle:@"发送" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(sendImage:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    
    self.navItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navItem.rightBarButtonItem.enabled = NO;
    
    
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"common_button_white_disable"] forState:UIControlStateNormal];
    //[button setBackgroundImage:[UIImage imageNamed:@"common_button_orange_highlighted"] forState:UIControlStateHighlighted];
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"common_button_white_disable"] forState:UIControlStateDisabled];
    
    leftbutton.frame = CGRectMake(0, 0, 45, 36);
    [leftbutton setTitle:@"关闭" forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    [leftbutton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [leftbutton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    leftbutton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftbutton];
    
    
    
    
    
}

- (void)picImages{
    
    LGPhotoNavigationController *photo = [LGPhotoNavigationController photoList:^(NSArray<UIImage *> *images) {
        [self.imagesArray removeObject:self.lastImage];
        
        [self.imagesArray addObject:self.lastImage];
        [self setupImages:self.imagesArray];
        
    }];
    
    [self presentViewController:photo animated:YES completion:^{
        [SVProgressHUD dismiss];
        
    }];
    
    
    
}

- (void)setupImages:(NSMutableArray<LGPhotoImage *> *)images{
    
    
    
    int count = (int)images.count;
    if (images.count) {
        UIView *view = [[UIView alloc] init] ;
        
        CGFloat margin = 5;
        
        view.frame = CGRectMake(2 * LGCommonMargin, LGImageItemWH, self.view.lg_width - 2 * LGCommonMargin,  (count/3 + 1) * LGImageItemWH + (count - 1) * margin);
        [self.footView addSubview:view];
        for (int i = 0; i < count; i++) {
            UIImageView *imageV = [[UIImageView alloc] init];
            CGFloat imageVH = LGImageItemWH;
            int lin = i / 3;
            int loc = i % 3;
            imageV.frame = CGRectMake(loc * imageVH + loc * margin + margin, lin * (imageVH + margin) + margin, imageVH, imageVH);
            imageV.image = images[i].image;
            [view addSubview:imageV];
            imageV.contentMode = UIViewContentModeScaleAspectFill;
            imageV.clipsToBounds = YES;
            if (i < count - 1) {
                imageV.userInteractionEnabled = YES;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteImage:)];
                [imageV addGestureRecognizer:tap];
            }
            
        }
        
        self.tableView.tableFooterView = view;
        [self.tableView reloadData];
        UIImageView *imageV = view.subviews.lastObject;
        imageV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(picImages)];
        [imageV addGestureRecognizer:tap];
        
    }
}

- (void)deleteImage:(UIGestureRecognizer *)tap{
    UIAlertController *aler = [UIAlertController alertControllerWithTitle:@"是否删除该图片" message:@"删除之后就不会上传到服务器" preferredStyle:UIAlertControllerStyleAlert];
    
    [aler addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        [tap.view removeFromSuperview];
        UIImageView *imageV = (UIImageView *)tap.view;
        
        [self.imagesArray removeObject:imageV.image];
        
#warning 动画BUG
        //        [UIView animateWithDuration:5 animations:^{
        
        [self setupImages:self.imagesArray];
        //        }];
        
        
        
        
    }]];
    [aler addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:aler animated:YES completion:nil];
    
    
}


- (void)aliyunOssUploa:(LGAliYunOssUpload *)upload Progress:(CGFloat)progress{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
    });
    
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)sendImage:(id)sender {
    
    
    
    dispatch_group_t group = dispatch_group_create();
    [self.imagesArray removeLastObject];
    [SVProgressHUD showWithStatus:@"正在上传图片.."];
    for (LGPhotoImage *photoImage in self.imagesArray) {
        
        NSString *imageID = [[NSUUID UUID] UUIDString];
        NSString *imageName;
        NSData *data;
        if (photoImage.isGif) {
            imageName = [NSString stringWithFormat:@"squareImages/%@.gif",imageID];
            data = photoImage.imageData;
        }else{
            
            data = UIImageJPEGRepresentation(photoImage.image, 0.9);
            imageName = [NSString stringWithFormat:@"squareImages/%@.jpg",imageID];
        }
        dispatch_group_enter(group);
        dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
            
            [self.upload uploadfileData:data fileName:imageName bucketName:nil completion:^(BOOL isSuccess) {
                if (isSuccess) {
                    if (photoImage.isGif) {
                        
                        [self.imageUrls addObject:[NSString stringWithFormat:@"%@.gif",imageID]] ;
                    }else{
                        [self.imageUrls addObject:[NSString stringWithFormat:@"%@.jpg",imageID]] ;
                    }
                    dispatch_group_leave(group);
                    
                }else{
                    
                    [SVProgressHUD showErrorWithStatus:@"发送失败"];
                    return ;
                }
            }];
            
        });
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        //发送json数据到服务器
        
        //判断对象是否能转换成json
        NSMutableString *htmstrM = [NSMutableString string];
        NSData *data = [NSJSONSerialization dataWithJSONObject:self.imageUrls options:kNilOptions error:nil];
        NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        for (NSString *url in self.imageUrls) {
            // <a href="http://79432303.oss-cn-shanghai.aliyuncs.com/images/1E53C48D-56A6-47CE-8ABD-B23D1FCE9819.jpg"><img src="http://79432303.oss-cn-shanghai.aliyuncs.com/images/1E53C48D-56A6-47CE-8ABD-B23D1FCE9819.jpg" alt="" /></a>
            //E9CA5808-051D-4B05-BEE3-392A11357BEF.gif
            
            NSString *htmlStr =  [NSString stringWithFormat:@"<a href=\"http://79432303.oss-cn-shanghai.aliyuncs.com/squareImages/%@\"><img src=\"http://79432303.oss-cn-shanghai.aliyuncs.com/squareImages/%@\" alt=\"\" /></a>",url,url];
            [htmstrM appendString:htmlStr];
        }
        
        
        
        
        [[LGNetWorkingManager manager] requestPostImageTitle:self.textView.text content:htmstrM :^(BOOL isSuccess) {
            if (isSuccess) {
                [SVProgressHUD showSuccessWithStatus:@"发送成功"];
                [self close:nil];
            }else{
                
                [SVProgressHUD showErrorWithStatus:@"发送失败"];
            }
        }];
        
        
    });
}



- (IBAction)close:(id)sender {
    [self.textView resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:^{
        
        [SVProgressHUD dismiss];
    }];
}


- (void)tap:(UIGestureRecognizer *)tap{
    [tap.view endEditing:YES];
    
}

@end
