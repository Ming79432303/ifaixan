//
//  NSURL+LGGetVideoImage.m
//  ifaxian
//
//  Created by ming on 16/12/3.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "NSURL+LGGetVideoImage.h"

@implementation NSURL (LGGetVideoImage)
+ (void)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time completion:(void(^)(UIImage *thumbnailImage))completion{
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
    
    if(!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
    
    UIImage*thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage: thumbnailImageRef] : nil;
    
    completion(thumbnailImage);
     CGImageRelease(thumbnailImageRef);
}

@end
