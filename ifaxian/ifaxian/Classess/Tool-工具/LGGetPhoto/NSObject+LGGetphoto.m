//
//  NSObject+LGGetphoto.m
//  获得相册中的图片
//
//  Created by ming on 16/11/10.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "NSObject+LGGetphoto.h"
#import <Photos/Photos.h>
#import "UIImage+LGSaveImage.h"



@implementation NSObject (LGGetphoto)

/**
 *  遍历相簿中的缩略图
 *
 *  @param assetCollection 相簿
 *  @param original        是否要原图
 */
+ (void)lg_getThumbnailImage:(void(^)(NSArray<LGPhoto *> *photos))completion{
       NSMutableArray *photos = [NSMutableArray array];
    PHAssetCollection * collection = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].firstObject;
     [photos addObject:[self enumerateAssetsInAssetCollection:collection original:NO]];
    // 获得所有的自定义相簿
    PHFetchResult<PHAssetCollection *>  * assetColetion= [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *col in assetColetion) {
       
        [photos addObject: [self enumerateAssetsInAssetCollection:col original:NO]];
    }
    
    //获取相机卷
       completion(photos);
}
/**
 *  遍历相簿中的原图
 *
 *  @param assetCollection 相簿
 *  @param original        是否要原图
 */
+ (void)lg_getOriginalImage:(void(^)(NSArray<LGPhoto *> *photos))completion{
    // 获得所有的自定义相簿
    PHFetchResult<PHAssetCollection *>  * assetColetion= [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    NSMutableArray *photos = [NSMutableArray array];
    
    //获取相机卷
    PHAssetCollection * collection = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].firstObject;
    [photos addObject:[self enumerateAssetsInAssetCollection:collection original:YES]];

    
    for (PHAssetCollection *col in assetColetion) {
        NSLog(@"%@",col);
        [photos addObject: [self enumerateAssetsInAssetCollection:col original:YES]];
    }
        completion(photos);
}
/**
 *  遍历相簿中的所有图片
 *
 *  @param assetCollection 相簿
 *  @param original        是否要原图
 */
- (LGPhoto *)enumerateAssetsInAssetCollection:(PHAssetCollection *)assetCollection original:(BOOL)original
{
        
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        // 同步获得图片, 只会返回1张图片
        options.synchronous = YES;
        
        // 获得某个相簿中的所有PHAsset对象
        PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
        NSMutableArray *arrayM = [NSMutableArray array];
        for (PHAsset *asset in assets) {
            // 是否要原图
            CGSize size = original ? CGSizeMake(asset.pixelWidth, asset.pixelHeight) : CGSizeZero;
            PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
            // 从asset中获得图片
            
            [imageManager requestImageDataForAsset:asset
                                           options:options
                                     resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                                         
                                         
                                         
                                         //gif 图片
                                         if ([dataUTI isEqualToString:(__bridge NSString *)kUTTypeGIF]) {
                                             //这里获取gif图片的NSData数据
                                             LGPhotoImage *image = [LGPhotoImage phototisGif:YES image:[UIImage imageWithData:imageData] imageData:imageData];
                                             [arrayM addObject:image];
                                             
                                         } else {
                                             //其他格式的图片
                                             
                                             [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                 
                                                 LGPhotoImage *image = [LGPhotoImage phototisGif:NO image:result imageData:nil];
                                                 
                                                 [arrayM addObject:image];
                                             }];
                                         }
                                         
                                     }];
            
        }
        LGPhoto *photo = [LGPhoto phototTitle:assetCollection.localizedTitle images:arrayM];
        
        
        return photo;

    
}
/**
 *  获得相机胶卷中的所有图片
 */
+ (NSArray *)lg_getImagesFromCameraRoll
{
    // 获得相机胶卷中的所有图片
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsWithOptions:nil];
    
    
    NSMutableArray *arrayM = [NSMutableArray array];
    for (PHAsset *asset in assets) {
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(asset.pixelWidth, asset.pixelHeight) contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            
            [arrayM addObject:result];
        }];
    }
    return arrayM;
}
//获得相簿的名字
+ (void)lg_getPhotoName:(void(^)(NSArray<NSString *> *names))completion{
    // 获得所有的自定义相簿
    NSMutableArray *arrayM = [NSMutableArray array];
    
    //获取相机卷
    PHAssetCollection * collection = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].firstObject;
    [arrayM addObject:collection.localizedTitle];
    
    PHFetchResult<PHAssetCollection *>  * assetColetion= [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *col in assetColetion) {
        [arrayM addObject:col.localizedTitle];
    }
    completion(arrayM);
   
}



@end
