//
//  LGImagesView.m
//  ifaxian
//
//  Created by ming on 16/11/30.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGImagesView.h"
#import "UIImageView+LGUIimageView.h"
#import "LWImageBrowser.h"
#import "LWImageBrowserModel.h"
#import "NSString+LGImageStyle.h"
@interface LGImagesView()
@property(nonatomic, strong) NSMutableArray *imageModels;

@end


@implementation LGImagesView

- (NSMutableArray *)imageModels{
    
    if (_imageModels == nil) {
        _imageModels = [NSMutableArray array];
    }
    return _imageModels;
    
}

- (void)awakeFromNib{

    [super awakeFromNib];
    [self setupUI];
   
}


- (void)setImages:(NSArray *)images{
    

}

- (void)setModel:(LGShare *)model{
    _model = model;
        if (model.images.count > 9 || !model.images.count) {
        return;
    }
    for (UIView *imageView in self.subviews) {
        imageView.hidden = YES;
    }
    
    if (model.images.count == 1) {
        //更改第一张图片的位置
        UIImageView *imageV = self.subviews[0];
        imageV.hidden = NO;
        
        
        imageV.frame = CGRectMake(0, 0, model.oneImageSize.width,  model.oneImageSize.height);
        [imageV lg_setImageWithurl:[self isGifUrl:self.model.images.firstObject imageView:imageV] placeholderImage:nil];
        
    }else if (model.images.count == 2) {
        for (int i =0; i< model.images.count; i++) {
            UIImageView *v = self.subviews[i];
            int lin = i % 3;
            int loc = i / 3;
            //当个的宽高度
            v.frame = CGRectMake(LGCommonSmallMargin * lin + lin * (LGTowImageItemWH), LGCommonSmallMargin * loc + loc * (LGTowImageItemWH), LGTowImageItemWH, LGTowImageItemWH);
            v.hidden = NO;
            NSString *url =  model.images[i];
            [v lg_setImageWithurl:[self isGifUrl:url imageView:v] placeholderImage:nil];
            
        }
    }else if (model.images.count == 4){
        int index = 0;
        for (int i =0; i<= model.images.count; i++) {
            UIImageView *v = self.subviews[i];
            if (i == 2) {
                continue;
            }
            int lin = i % 3;
            int loc = i / 3;
            //当个的宽高度
            v.frame = CGRectMake(LGCommonSmallMargin * (lin - 1) + lin * (LGTowImageItemWH), LGCommonSmallMargin * (loc - 1) + loc * (LGTowImageItemWH), LGTowImageItemWH, LGTowImageItemWH);
            v.hidden = NO;
            NSString *url =  model.images[index];
            
            [v lg_setImageWithurl:[self isGifUrl:url imageView:v] placeholderImage:nil];
            
            index ++;
        }
    }else{
        
        for (int i = 0;i < self.model.images.count; i++) {
            UIImageView *v = self.subviews[i];
            int lin = i % 3;
            int loc = i / 3;
            v.frame = CGRectMake(LGCommonSmallMargin * (lin) + lin * (LGImageItemWH), LGCommonSmallMargin * (loc) + loc * (LGImageItemWH), LGImageItemWH, LGImageItemWH);
            v.hidden = NO;
            [v lg_setImageWithurl:[self isGifUrl:self.model.images[i] imageView:v] placeholderImage:nil];
            
        }
    }
}

//9宫格布局

-(void)setupUI{
    // 设置一些常数
    //图片距离两边的距离
    self.contentMode = UIViewContentModeScaleToFill;
    //图片的间距
    //让数从1开始计算
    self.clipsToBounds = YES;
      for (int i = 0; i< 9; i++) {
        //根据图片内容添加布局
        UIImageView *imageView = [[UIImageView alloc] init];
        int lin = i % 3;
        int loc = i / 3;
         imageView.hidden = YES;
        imageView.frame = CGRectMake(LGCommonSmallMargin * (lin) + lin * (LGImageItemWH), LGCommonSmallMargin * (loc) + loc * (LGImageItemWH), LGImageItemWH, LGImageItemWH);
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        [self addSubview:imageView];
          [self addGifImageViewIn:imageView];
        imageView.clipsToBounds = YES;
        imageView.userInteractionEnabled = YES;
  
          UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
          [imageView addGestureRecognizer:tap];
        
    }
    
    
}
- (void)tap:(UIGestureRecognizer *)tap{
    

    
    [self.imageModels removeAllObjects];

    int index = 0;
    int page = 0;
    for (NSString *url in self.model.images) {

        //创建图片浏览模型
         NSURL *thumbnaiUrl = [NSURL URLWithString:[url lg_thumbnailImageSizeImageW:200]];
        if ([url hasSuffix:@".gif"]) {
            thumbnaiUrl = [NSURL URLWithString:[url lg_jpgReplaceGif]];
        }
        
        if (self.model.images.count == 4) {
            if (index == 2) {
                index += 1;
            }
        }
        NSURL *hdUrl = [NSURL URLWithString:[url lg_largeImage]];
        UIImageView *imageV = self.subviews[index];
        imageV.tag = page;
       // CGRect imageFrame =  [imageV convertRect:imageV.bounds toView:nil];
       // NSLog(@"%@",NSStringFromCGRect(imageFrame));
        LWImageBrowserModel *imageModel = [[LWImageBrowserModel alloc] initWithplaceholder:[UIImage imageNamed:@"5"] thumbnailURL:thumbnaiUrl HDURL:hdUrl containerView:self positionInContainer:imageV.frame index:imageV.tag];
        [self.imageModels addObject:imageModel];
        index ++;
        page ++;

    }
    
    
    if (self.imageModels.count) {
        LWImageBrowser *imageBrowser = [[LWImageBrowser alloc] initWithImageBrowserModels:self.imageModels currentIndex:tap.view.tag];
        //imageBrowser.isScalingToHide = NO ;
 
        [imageBrowser show];
    }
    
    
}
//添加gif图标

- (void)addGifImageViewIn:(UIImageView *)imageView{
    
    UIImageView *gifImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gif_icon"]];
    gifImageV.hidden = YES;
    [imageView addSubview:gifImageV];
    [gifImageV mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_equalTo(imageView.mas_right).offset(-LGCommonSmallMargin);
        make.top.mas_equalTo(imageView.mas_top).offset(LGCommonSmallMargin);
    
    }];
    
    
}
//判断是否是gif
- (NSString *)isGifUrl:(NSString *)url imageView:(UIImageView *)imageView{
    
    if ([url hasSuffix:@".gif"]) {
        //进行图片转换展示一张图片给用户
        UIImageView *gifImage = imageView.subviews.firstObject;
        gifImage.hidden = NO;
   
        return [url lg_jpgReplaceGif];
    }else{
        UIImageView *gifImage = imageView.subviews.firstObject;
        gifImage.hidden = YES;
        
        
        return [url lg_thumbnailImageSizeImageW:0];
    }
    
    
}

@end
