//
//  UIImage+LGSaveImage.m
//  test
//
//  Created by ming on 16/11/9.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "UIImage+LGSaveImage.h"
#import <Photos/Photos.h>
#import <objc/runtime.h>
typedef void(^imageBlock)(bool isSuccess ,NSString * info);
static NSString *name = @"爱发现";

@interface UIImage (_LGSaveImage)
@property(nonatomic, strong) imageBlock finish;
@end
@implementation UIImage (_LGSaveImage)
@dynamic finish;

- (void)lg_saveImage:(void(^)(bool isSuccess ,NSString * info))completion{
    

    self.finish = completion;

    //1.判断用户是否授权
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    
    if (status == PHAuthorizationStatusRestricted){// 因为家长控制, 导致应用无法方法相册(跟用户的选择没有关系)
        
        
    }else if (status == PHAuthorizationStatusDenied) { //用户拒绝当前应用访问相册(用户当初点击了"不允许")
        //1.1用户拒绝
        LGLog(@"用户拒绝");
        
    }else if (status == PHAuthorizationStatusAuthorized){//用户允许当前应用访问相册(用户当初点击了"好")
        //1.2用户已经授权
        [self saveImage];
        
        
        
    }else if (status == PHAuthorizationStatusNotDetermined){//用户还没有做出选择
        //1.3用户未决定
        //1.3.1请求用户授权
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {//用户授权
                
                LGLog(@"授权成功");
                [self saveImage];
                
                
            }else{
                
                LGLog(@"授权失败");
                
            }
        }];
        
        
    }
}






- (void)saveImage
{
    // PHAsset : 一个资源, 比如一张图片\一段视频
    // PHAssetCollection : 一个相簿
    
    // PHAsset的标识, 利用这个标识可以找到对应的PHAsset对象(图片对象)
    __block NSString *assetLocalIdentifier = nil;
    
    // 如果想对"相册"进行修改(增删改), 那么修改代码必须放在[PHPhotoLibrary sharedPhotoLibrary]的performChanges方法的block中
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        // 1.保存图片A到"相机胶卷"中
        // 创建图片的请求
        //这样设计的好处因为这短代码是在子线程中运行的如果就在这里返回结果那么就会卡主主线程
        assetLocalIdentifier = [PHAssetCreationRequest creationRequestForAssetFromImage:self].placeholderForCreatedAsset.localIdentifier;
            //PHAssetResourceCreationOptions *options = [[PHAssetResourceCreationOptions alloc] init];
        //options.shouldMoveFile = YES;
        //[[PHAssetCreationRequest creationRequestForAsset] addResourceWithType:PHAssetResourceTypePhoto data:nil options:options];
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (success == NO) {
            [self showError:@"保存图片失败!"];
            return;
        }
        
        // 2.获得相簿
        PHAssetCollection *createdAssetCollection = [self createdAssetCollection];
        if (createdAssetCollection == nil) {
            [self showError:@"创建相簿失败!"];
            return;
        }
        
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            // 3.添加"相机胶卷"中的图片A到"相簿"D中
            
            // 获得图片
            PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetLocalIdentifier] options:nil].lastObject;
            
            // 添加图片到相簿中的请求
            PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:createdAssetCollection];
            
            // 添加图片到相簿
            [request addAssets:@[asset]];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            if (success == NO) {
                [self showError:@"保存图片失败!"];;
            } else {
                [self showSuccess:@"保存图片成功!"];;
            }
        }];
    }];
}

/**
 *  获得相簿
 */
- (PHAssetCollection *)createdAssetCollection
{
    // 从已存在相簿中查找这个应用对应的相簿
    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *assetCollection in assetCollections) {
        if ([assetCollection.localizedTitle isEqualToString:name]) {
            return assetCollection;
        }
    }
    
    // 没有找到对应的相簿, 得创建新的相簿
    
    // 错误信息
    NSError *error = nil;
    
    // PHAssetCollection的标识, 利用这个标识可以找到对应的PHAssetCollection对象(相簿对象)
    __block NSString *assetCollectionLocalIdentifier = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        // 创建相簿的请求
        assetCollectionLocalIdentifier = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:name].placeholderForCreatedAssetCollection.localIdentifier;
    } error:&error];
    
    // 如果有错误信息
    if (error) return nil;
    
    // 获得刚才创建的相簿
    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[assetCollectionLocalIdentifier] options:nil].lastObject;
}
//在主线程中显示UI界面
- (void)showSuccess:(NSString *)text
{
    
 dispatch_async(dispatch_get_main_queue(), ^{
      self.finish(YES,text);
    });
}

- (void)showError:(NSString *)text
{
    dispatch_async(dispatch_get_main_queue(), ^{
         self.finish(YES,text);
    });
}
- (imageBlock)finish{
    
    return objc_getAssociatedObject(self, @selector(finish));
 
}

- (void)setFinish:(imageBlock)finish{
    objc_setAssociatedObject(self, @selector(finish), finish, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
