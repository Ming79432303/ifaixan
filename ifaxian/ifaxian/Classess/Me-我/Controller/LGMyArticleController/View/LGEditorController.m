//
//  LGEditorController.m
//  ifaxian
//
//  Created by ming on 16/11/22.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGEditorController.h"

@import Photos;
@import AVFoundation;
@import MobileCoreServices;
#import "LWImageBrowser.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
#import <AliyunOSSiOS/OSSService.h>

#import <WordPressShared/WPFontManager.h>
#import "LGCommentController.h"
#import "LGAliAccessToken.h"
#import "LGAliYunOssUpload.h"
#import "WPImageMetaViewController.h"
#define URL @"https://79432303.oss-cn-shanghai.aliyuncs.com"

@interface LGEditorController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,LGAliYunOssUploadDelegate,WPImageMetaViewControllerDelegate>
@property(nonatomic, strong) NSProgress *progress;

@property(nonatomic, strong) UIButton *rightButton;

@end

@implementation LGEditorController


- (UIButton *)rightButton{
    
    if (_rightButton == nil) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    
    return _rightButton;
}


- (UINavigationBar *)navBar{
    if (_navBar == nil) {
        _navBar = [[UINavigationBar alloc] init];
        
    }
    
    return _navBar;
}
- (UINavigationItem *)navItem{
    
    if (_navItem == nil) {
        _navItem = [[UINavigationItem alloc] init];
    }
    
    return _navItem;
}



- (void)viewDidLoad
{
     [super viewDidLoad];
    [self setupNav];
    [self setTitlePlaceholderText:@"标题"];
    [self setBodyPlaceholderText:@"在这里来分享你的故事..."];
    [self setEditing:YES animated:YES];
    self.delegate = self;
}

- (void)findScrollViewsInView:(UIView *)view
{
    // 利用递归查找所有的子控件
    for (UIView *subview in view.subviews) {
        [self findScrollViewsInView:subview];
    }
    
    
    if (![view isKindOfClass:[UIScrollView class]]) return;
    
    // 判断是否跟window有重叠

    if (![view lg_intersectWithView:[UIApplication sharedApplication].keyWindow]) return;
    //    CGRect windowRect = [UIApplication sharedApplication].keyWindow.bounds;
    //    CGRect viewRect = [view convertRect:view.bounds toView:nil];
    //    // 跟window不重叠
    //    if (!CGRectIntersectsRect(windowRect, viewRect)) return;
    
    // 如果是scrollView
    UIScrollView *scrollView = (UIScrollView *)view;
    
    // 修改offset
    UIEdgeInsets inset = scrollView.contentInset;
    inset.top = LGnavBarH;
    inset.bottom = LGtabBarH;
    scrollView.contentInset = inset;
    

    
    // [scrollView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}


- (void)setupNav{
     [self findScrollViewsInView:self.editorView];
    self.navigationController.navigationBar.hidden = YES;
    self.navBar.frame = self.navigationController.navigationBar.bounds;
    self.navItem.title = @"编辑文章";
    self.navBar.lg_height += 20;
    self.navBar.items = @[self.navItem];
    self.navBar.barTintColor = [UIColor lg_colorWithHex:0xF6F6F6];
    self.navBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor lg_colorWithRed:37 green:37 blue:37]};
    [self.view addSubview:self.navBar];
    [self.rightButton setTitle:@"编辑" forState:UIControlStateNormal];
    [self.rightButton sizeToFit];
    [self.rightButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(editTouchedUpInside) forControlEvents:UIControlEventTouchUpInside];
    self.navItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    self.navItem.leftBarButtonItem = [UIBarButtonItem lg_barButtonCustButton:@"" fontSize:14 addTarget:self action:@selector(back) isBack:YES];
    self.mediaAdded = [NSMutableDictionary dictionary];
    self.videoPressCache = [[NSCache alloc] init];
    [self stopEditing];
    self.titlePlaceholderText = NSLocalizedString(@"Post title",  @"Placeholder for the post title.");
    self.bodyPlaceholderText = NSLocalizedString(@"Share your story here...", @"Placeholder for the post body.");

}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
     
    
}
- (void)back{
    self.navigationController.navigationBar.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark - Navigation Bar

- (void)editTouchedUpInside
{
    if (self.isEditing) {
        
        [self.rightButton setTitle:@"编辑" forState:UIControlStateNormal];
     
        //点击保存后更新文章
        NSString *ID = [NSString stringWithFormat:@"%zd",self.model.ID];
        
        LGWeakSelf;
    
        [[LGNetWorkingManager manager] requestUpdateArticleTitle:self.titleText content:self.bodyText post_slug:self.model.slug post_id:ID contentText:^(BOOL isSuccess) {
            
            if (isSuccess) {
                [SVProgressHUD showSuccessWithStatus:@"保存成功"];
                //保存到内存中
                weakSelf.model.title = self.titleText;
                 weakSelf.model.content = self.bodyText;
            }else{
                
                 [SVProgressHUD showErrorWithStatus:@"保存失败"];
            }
            
        }];

       
        [self stopEditing];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            self.editorView.lg_y = self.navBar.lg_height;
        }];
        [self.rightButton setTitle:@"保存" forState:UIControlStateNormal];
        [self startEditing];
    }
}

#pragma mark - IBActions

- (IBAction)exit:(UIStoryboardSegue*)segue
{
}

#pragma mark - WPEditorViewControllerDelegate

/**
 *  开始编辑调用方法
 *
 *
 */

- (void)editorDidBeginEditing:(WPEditorViewController *)editorController
{
   
}
/**
 *  结束编辑
 *
 *  @param editorController <#editorController description#>
 */
- (void)editorDidEndEditing:(WPEditorViewController *)editorController
{
    
}
/**
 *  加载档完毕
 *
 *  @param editorController
 */
- (void)editorDidFinishLoadingDOM:(WPEditorViewController *)editorController
{
    LGLog(@"加载文档");
    NSString *htmlParam = self.model.content;
    [self setTitleText:self.model.title];
    [self setBodyText:htmlParam];}

- (BOOL)editorShouldDisplaySourceView:(WPEditorViewController *)editorController
{
    [self.editorView pauseAllVideos];
    return YES;
}

- (void)editorDidPressMedia:(WPEditorViewController *)editorController
{
    // LGLog(@"媒体PressMedia");
   
    [self showPhotoPicker];
}

- (void)editorTitleDidChange:(WPEditorViewController *)editorController
{
   // LGLog(@"标题改变:%@",self.titleText);
    DDLogInfo(@"Editor title did change: %@", self.titleText);
}

- (void)editorTextDidChange:(WPEditorViewController *)editorController
{
//    LGLog(@"内容改变:%@",self.bodyText);
   
}

- (void)editorViewController:(WPEditorViewController *)editorViewController fieldCreated:(WPEditorField*)field
{
    LGLog(@"文件:%@",field.nodeId);

    DDLogInfo(@"Editor field created: %@", field.nodeId);
}

- (void)editorViewController:(WPEditorViewController*)editorViewController
                 imageTapped:(NSString *)imageId
                         url:(NSURL *)url{
    
   
    
}

- (void)editorViewController:(WPEditorViewController*)editorViewController
                 imageTapped:(NSString *)imageId
                         url:(NSURL *)url
                   imageMeta:(WPImageMeta *)imageMeta
{
    if (imageId.length == 0) {
        [self showImageDetailsForImageMeta:imageMeta];
    } else {
        [self showPromptForImageWithID:imageId];
    }
}

- (void)editorViewController:(WPEditorViewController*)editorViewController
                 videoTapped:(NSString *)videoId
                         url:(NSURL *)url
{
    [self showPromptForVideoWithID:videoId];
}

- (void)editorViewController:(WPEditorViewController *)editorViewController imageReplaced:(NSString *)imageId
{
    [self.mediaAdded removeObjectForKey:imageId];
}

- (void)editorViewController:(WPEditorViewController *)editorViewController imagePasted:(UIImage *)image
{
    NSData *imageData = UIImageJPEGRepresentation(image, 0.9);
    
    [self addImageDataToContent:imageData];
}

- (void)editorViewController:(WPEditorViewController *)editorViewController videoReplaced:(NSString *)videoId
{
    [self.mediaAdded removeObjectForKey:videoId];
}

- (void)editorViewController:(WPEditorViewController *)editorViewController videoPressInfoRequest:(NSString *)videoID
{
    NSDictionary * videoPressInfo = [self.videoPressCache objectForKey:videoID];
    NSString * videoURL = videoPressInfo[@"source"];
    NSString * posterURL = videoPressInfo[@"poster"];
    if (videoURL) {
        [self.editorView setVideoPress:videoID source:videoURL poster:posterURL];
    }
}

- (void)editorViewController:(WPEditorViewController *)editorViewController mediaRemoved:(NSString *)mediaID
{
    NSProgress * progress = self.mediaAdded[mediaID];
    [progress cancel];
    LGLog(@"移除媒体%@",mediaID);
    DDLogInfo(@"Media Removed: %@", mediaID);
}

- (void)editorFormatBarStatusChanged:(WPEditorViewController *)editorController
                             enabled:(BOOL)isEnabled
{
    DDLogInfo(@"Editor format bar status is now %@.", (isEnabled ? @"enabled" : @"disabled"));
}

#pragma mark - Media actions



- (void)showImageDetailsForImageMeta:(WPImageMeta *)imageMeta
{
    UIStoryboard *stor = [UIStoryboard storyboardWithName:@"WPImageMetaViewController" bundle:nil];
    WPImageMetaViewController *controller = [stor instantiateInitialViewController];
    controller.imageMeta = imageMeta;
    controller.delegate = self;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self.navigationController presentViewController:navController animated:YES completion:nil];
}
//点击图片显示是否取消上传
- (void)showPromptForImageWithID:(NSString *)imageId
{
    if (imageId.length == 0){
        return;
    }
    
    __weak __typeof(self)weakSelf = self;
    UITraitCollection *traits = self.navigationController.traitCollection;
    NSProgress *progress = self.mediaAdded[imageId];
    UIAlertController *alertController;
    if (traits.userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        alertController = [UIAlertController alertControllerWithTitle:nil
                                                              message:nil
                                                       preferredStyle:UIAlertControllerStyleAlert];
    } else {
        alertController = [UIAlertController alertControllerWithTitle:nil
                                                              message:nil
                                                       preferredStyle:UIAlertControllerStyleActionSheet];
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *action){}];
    [alertController addAction:cancelAction];
    
    if (!progress.cancelled){
        UIAlertAction *stopAction = [UIAlertAction actionWithTitle:@"Stop Upload"
                                                             style:UIAlertActionStyleDestructive
                                                           handler:^(UIAlertAction *action){
                                                               [weakSelf.editorView removeImage:weakSelf.selectedMediaID];
                                                           }];
        [alertController addAction:stopAction];
    } else {
        UIAlertAction *removeAction = [UIAlertAction actionWithTitle:@"Remove Image"
                                                               style:UIAlertActionStyleDestructive
                                                             handler:^(UIAlertAction *action){
                                                                 [weakSelf.editorView removeImage:weakSelf.selectedMediaID];
                                                             }];
        
        UIAlertAction *retryAction = [UIAlertAction actionWithTitle:@"Retry Upload"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction *action){
                                                                NSProgress * progress = [[NSProgress alloc] initWithParent:nil userInfo:@{@"imageID":self.selectedMediaID}];
                                                                progress.totalUnitCount = 100;
//                                                                [NSTimer scheduledTimerWithTimeInterval:0.1
//                                                                                                 target:self
//                                                                                               selector:@selector(timerFireMethod:)
//                                                                                               userInfo:progress
//                                                                                                repeats:YES];
//                                                                weakSelf.mediaAdded[weakSelf.selectedMediaID] = progress;
//                                                                [weakSelf.editorView unmarkImageFailedUpload:weakSelf.selectedMediaID];
                                                            }];
        [alertController addAction:removeAction];
        [alertController addAction:retryAction];
    }
    
    self.selectedMediaID = imageId;
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
}

- (void)showPromptForVideoWithID:(NSString *)videoId
{
    if (videoId.length == 0){
        return;
    }
    __weak __typeof(self)weakSelf = self;
    UITraitCollection *traits = self.navigationController.traitCollection;
    NSProgress *progress = self.mediaAdded[videoId];
    UIAlertController *alertController;
    if (traits.userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        alertController = [UIAlertController alertControllerWithTitle:nil
                                                              message:nil
                                                       preferredStyle:UIAlertControllerStyleAlert];
    } else {
        alertController = [UIAlertController alertControllerWithTitle:nil
                                                              message:nil
                                                       preferredStyle:UIAlertControllerStyleActionSheet];
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *action){}];
    [alertController addAction:cancelAction];
    
    if (!progress.cancelled){
        UIAlertAction *stopAction = [UIAlertAction actionWithTitle:@"Stop Upload"
                                                             style:UIAlertActionStyleDestructive
                                                           handler:^(UIAlertAction *action){
                                                               [weakSelf.editorView removeVideo:weakSelf.selectedMediaID];
                                                           }];
        [alertController addAction:stopAction];
    } else {
        UIAlertAction *removeAction = [UIAlertAction actionWithTitle:@"Remove Video"
                                                               style:UIAlertActionStyleDestructive
                                                             handler:^(UIAlertAction *action){
                                                                 [weakSelf.editorView removeVideo:weakSelf.selectedMediaID];
                                                             }];
        
//        UIAlertAction *retryAction = [UIAlertAction actionWithTitle:@"Retry Upload"
//                                                              style:UIAlertActionStyleDefault
//                                                            handler:^(UIAlertAction *action){
//                                                                NSProgress * progress = [[NSProgress alloc] initWithParent:nil userInfo:@{@"videoID":weakSelf.selectedMediaID}];
//                                                                progress.totalUnitCount = 100;
//                                                                [NSTimer scheduledTimerWithTimeInterval:0.1
//                                                                                                 target:self
//                                                                                               selector:@selector(timerFireMethod:)
//                                                                                               userInfo:progress
//                                                                                                repeats:YES];
//                                                                weakSelf.mediaAdded[self.selectedMediaID] = progress;
//                                                                [weakSelf.editorView unmarkVideoFailedUpload:weakSelf.selectedMediaID];
//                                                            }];
        [alertController addAction:removeAction];
        //[alertController addAction:retryAction];
    }
    self.selectedMediaID = videoId;
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
}
//选着一张图片
- (void)showPhotoPicker
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.navigationBar.translucent = NO;
    picker.modalPresentationStyle = UIModalPresentationCurrentContext;
    picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
    [self.navigationController presentViewController:picker animated:YES completion:nil];
}
/**
 *  拼接图片名称
 *
 *  @param imageData 图片的数据
 */
- (void)addImageDataToContent:(NSData *)imageData
{
    LGAliYunOssUpload *upload = [[LGAliYunOssUpload alloc] init];
    upload.delegate = self;
    
    /**
     *  生成唯一ID
     */
    NSString *imageID = [[NSUUID UUID] UUIDString];
    //拼接字符串，写入文件
    NSString *path = [NSString stringWithFormat:@"%@/%@.jpg", NSTemporaryDirectory(), imageID];
    [imageData writeToFile:path atomically:YES];
#pragma mark - aliyunyunjsnd
    dispatch_async(dispatch_get_main_queue(), ^{
        //上传的文件夹文images
        [upload uploadfilePath:path fileName:[NSString stringWithFormat:@"images/%@.jpg",imageID] bucketName:nil completion:^(BOOL isSuccess) {
            if (isSuccess) {
                LGLog(@"上传成功");
           
                //[self.editorView updateCurrentImageMeta:<#(WPImageMeta *)#>]

            }else{
                
                LGLog(@"上传失败");
            }
        }];
        //拼接路径
         NSString *url = [NSString stringWithFormat:@"%@/images/%@.jpg", URL, imageID];
        [self.editorView insertLocalImage:path uniqueId:imageID];
            NSProgress *progress = [[NSProgress alloc] initWithParent:nil userInfo:@{ @"imageID": imageID, @"url": url}];
            progress.cancellable = YES;
            progress.totalUnitCount = 100;
            self.mediaAdded[imageID] = progress;
            self.progress = progress;
            
        });
    //通知保存图片的ID
}
/**
 *  上传图片
 *
 *  @param upload   <#upload description#>
 *  @param progress 上传图片的进度
 */
- (void)aliyunOssUploa:(LGAliYunOssUpload *)upload Progress:(CGFloat)progress{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSProgress *progres =self.progress;
      NSString *imageID = progres.userInfo[@"imageID"];
        progres.completedUnitCount = progress;
      
        [self.editorView setProgress:progres.fractionCompleted onImage:imageID];
        // Uncomment this code if you need to test a failed image upload
        
  
        if (progres.fractionCompleted >=1) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [self.editorView replaceLocalImageWithRemoteImage:[[NSURL URLWithString:progres.userInfo[@"url"]] absoluteString]uniqueId:imageID];
            });
           
            
        }
    });
    

    
}


- (void)addImageAssetToContent:(PHAsset *)asset
{
    
    PHImageRequestOptions *options = [PHImageRequestOptions new];
    //异步拿去图片
    options.synchronous = NO;
    options.networkAccessAllowed = YES;
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    options.version = PHImageRequestOptionsVersionCurrent;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    
    [[PHImageManager defaultManager] requestImageDataForAsset:asset
                                                      options:options
                                                resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                                                    /**
                                                     *  添加图片到内容中
                                                     */
                                                    [self addImageDataToContent:imageData];
                                                }];
}

- (void)addVideoAssetToContent:(PHAsset *)originalAsset
{
    PHImageRequestOptions *options = [PHImageRequestOptions new];
    options.synchronous = NO;
    options.networkAccessAllowed = YES;
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    options.version = PHImageRequestOptionsVersionCurrent;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    NSString *videoID = [[NSUUID UUID] UUIDString];
    NSString *videoPath = [NSString stringWithFormat:@"%@%@.mov", NSTemporaryDirectory(), videoID];
    [[PHImageManager defaultManager] requestImageForAsset:originalAsset
                                               targetSize:[UIScreen mainScreen].bounds.size
                                              contentMode:PHImageContentModeAspectFit
                                                  options:options
                                            resultHandler:^(UIImage *image, NSDictionary * _Nullable info) {
                                                NSData *data = UIImageJPEGRepresentation(image, 0.7);
                                                NSString *posterImagePath = [NSString stringWithFormat:@"%@/%@.jpg", NSTemporaryDirectory(), [[NSUUID UUID] UUIDString]];
                                                [data writeToFile:posterImagePath atomically:YES];
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    [self.editorView insertInProgressVideoWithID:videoID
                                                                                usingPosterImage:[[NSURL fileURLWithPath:posterImagePath] absoluteString]];
                                                });
                                                PHVideoRequestOptions *videoOptions = [PHVideoRequestOptions new];
                                                videoOptions.networkAccessAllowed = YES;
                                                [[PHImageManager defaultManager] requestExportSessionForVideo:originalAsset
                                                                                                      options:videoOptions
                                                                                                 exportPreset:AVAssetExportPresetPassthrough
                                                                                                resultHandler:^(AVAssetExportSession * _Nullable exportSession, NSDictionary * _Nullable info) {
                                                                                                    exportSession.outputFileType = (__bridge NSString*)kUTTypeQuickTimeMovie;
                                                                                                    exportSession.shouldOptimizeForNetworkUse = YES;
                                                                                                    exportSession.outputURL = [NSURL fileURLWithPath:videoPath];
                                                                                                    [exportSession exportAsynchronouslyWithCompletionHandler:^{
                                                                                                        if (exportSession.status != AVAssetExportSessionStatusCompleted) {
                                                                                                            return;
                                                                                                        }
                                                                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                            NSProgress *progress = [[NSProgress alloc] initWithParent:nil
                                                                                                                                                             userInfo:@{@"videoID": videoID, @"url": videoPath, @"poster": posterImagePath }];
                                                                                                            progress.cancellable = YES;
                                                                                                            progress.totalUnitCount = 100;
//                                                                                                            [NSTimer scheduledTimerWithTimeInterval:0.1
//                                                                                                                                             target:self
//                                                                                                                                           selector:@selector(timerFireMethod:)
//                                                                                                                                           userInfo:progress
//                                                                                                                                            repeats:YES];
                                                                                                            self.mediaAdded[videoID] = progress;
                                                                                                        });
                                                                                                    }];
                                                                                                    
                                                                                                }];
                                            }];
}

- (void)addAssetToContent:(NSURL *)assetURL
{
    /**
     *  根据地址查找图片呢
     */
    PHFetchResult *assets = [PHAsset fetchAssetsWithALAssetURLs:@[assetURL] options:nil];
    /**
     *  如果地址为空折返回
     */
    if (assets.count < 1) {
        return;
    }
    //拿到相册中的第一个图片
    PHAsset *asset = [assets firstObject];
    /**
     *  判断是图片还是视频
     */
    if (asset.mediaType == PHAssetMediaTypeVideo) {
        //是视频
        [SVProgressHUD showInfoWithStatus:@"本栏目不支持视频上传"];
        return;
        //[self addVideoAssetToContent:asset];
    } if (asset.mediaType == PHAssetMediaTypeImage) {
        //是图片
        [self addImageAssetToContent:asset];
    }
}


#pragma mark - UIImagePickerControllerDelegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        /**
         *  拿到图片的地址
         */
        NSURL *assetURL = info[UIImagePickerControllerReferenceURL];
        [self addAssetToContent:assetURL];
    }];
    
}


#pragma mark - WPImageMetaViewControllerDelegate

- (void)imageMetaViewController:(WPImageMetaViewController *)controller didFinishEditingImageMeta:(WPImageMeta *)imageMeta
{
    [self.editorView updateCurrentImageMeta:imageMeta];
}








@end
