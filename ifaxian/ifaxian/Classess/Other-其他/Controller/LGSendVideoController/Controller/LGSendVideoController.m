//
//  LGSendVideoController.m
//  ifaxian
//
//  Created by ming on 16/12/2.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGSendVideoController.h"
#import <Photos/Photos.h>
#import "LGAliYunOssUpload.h"
#import "DALabeledCircularProgressView.h"
@interface LGSendVideoController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,LGAliYunOssUploadDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *picVideoButton;
@property (weak, nonatomic) IBOutlet UIImageView *playVideo;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
@property (nonatomic, strong) LGAliYunOssUpload *upload;
@property (nonatomic,strong) UIButton *sendButton;
@property (weak, nonatomic) IBOutlet DALabeledCircularProgressView *progressView;
@property(nonatomic, strong) NSURL *outputURL;

@end

@implementation LGSendVideoController

- (LGAliYunOssUpload *)upload{
    
    if (_upload == nil) {
        _upload = [[LGAliYunOssUpload alloc] init];
    }
    
    return _upload;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.upload.delegate = self;
    //添加添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isSendButton) name:UITextViewTextDidChangeNotification object:self.textView];

    [self setupUI];
}

- (void)setupUI{
    
    
    //右边按钮
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sendButton = button;
    
    [button setBackgroundImage:[UIImage imageNamed:@"common_button_white_disable"] forState:UIControlStateNormal];
    //[button setBackgroundImage:[UIImage imageNamed:@"common_button_orange_highlighted"] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageNamed:@"common_button_white_disable"] forState:UIControlStateDisabled];
    
    button.frame = CGRectMake(0, 0, 45, 36);
    [button setTitle:@"发送" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(sendVideo) forControlEvents:UIControlEventTouchUpInside];
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
    [leftbutton addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
    [leftbutton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [leftbutton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    leftbutton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftbutton];



    
    
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)isSendButton {
    
    self.sendButton.enabled = self.textView.text.length ? YES : NO;
    
}


//上传的进度
- (void)aliyunOssUploa:(LGAliYunOssUpload *)upload Progress:(CGFloat)progress{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"%f",progress);
        self.progressView.progress = progress/100.0;
    });
    
}


- (IBAction)picVideo:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"视频" message:@"选择视频" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"拍摄上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"提示" message:@"该设备不支持视频拍摄" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:NULL];
            [alert show];
            return;
        }

        
        [self shootingVideo];
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"选择视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *filePicker = [[UIImagePickerController alloc] init];
        filePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        filePicker.delegate = self;
        filePicker.mediaTypes = [NSArray arrayWithObject:@"public.movie"];
        filePicker.allowsEditing = YES;
        filePicker.view.backgroundColor = [UIColor whiteColor];
        [self presentViewController:filePicker animated:YES completion:^{
            
            NSLog(@"%@",filePicker);
        }];
        
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
    }]];
    


    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)shootingVideo{
    
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypeCamera;//sourcetype有三种分别是camera，photoLibrary和photoAlbum
    NSArray *availableMedia = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];//Camera所支持的Media格式都有哪些,共有两个分别是@"public.image",@"public.movie"
    ipc.mediaTypes = [NSArray arrayWithObject:availableMedia[1]];//设置媒体类型为public.movie
    [self presentViewController:ipc animated:YES completion:nil];
    ipc.videoMaximumDuration = 30.0f;//30秒
    ipc.delegate = self;//设置委托
    
}

- (CGFloat)getFileSize:(NSString *)path
{
    NSLog(@"%@",path);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    float filesize = -1.0;
    if ([fileManager fileExistsAtPath:path]) {
        NSDictionary *fileDic = [fileManager attributesOfItemAtPath:path error:nil];//获取文件的属性
        unsigned long long size = [[fileDic objectForKey:NSFileSize] longLongValue];
        filesize = 1.0*size/1024;
    }else{
        NSLog(@"找不到文件");
    }
    return filesize;
}//此方法可以获取文件的大小，返回的是单位是KB。
- (CGFloat)getVideoLength:(NSURL *)URL
{
    
    AVURLAsset *avUrl = [AVURLAsset assetWithURL:URL];
    CMTime time = [avUrl duration];
    int second = ceil(time.value/time.timescale);
    return second;
}//此方法可以获取视频文件的时长。

//完成视频录制，并压缩后显示大小、时长
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
  
    
    NSURL *sourceURL = [info objectForKey:UIImagePickerControllerMediaURL];
    NSLog(@"%@",[NSString stringWithFormat:@"%f s", [self getVideoLength:sourceURL]]);
    NSLog(@"%@", [NSString stringWithFormat:@"%.2f kb", [self getFileSize:[sourceURL path]]]);
    NSURL *newVideoUrl ; //一般.mp4
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];//用时间给文件全名，以免重复，在测试的时候其实可以判断文件是否存在若存在，则删除，重新生成文件即可
    [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    newVideoUrl = [NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingFormat:@"/Documents/output-%@.mp4", [formater stringFromDate:[NSDate date]]]] ;//这个是保存在app自己的沙盒路径里，后面可以选择是否在上传后删除掉。我建议删除掉，免得占空间。
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self convertVideoQuailtyWithInputURL:sourceURL outputURL:newVideoUrl completeHandler:nil];
}
- (void)convertVideoQuailtyWithInputURL:(NSURL*)inputURL
                               outputURL:(NSURL*)outputURL
                         completeHandler:(void (^)(AVAssetExportSession*))handler
{
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
    //  NSLog(resultPath);
    exportSession.outputURL = outputURL;
    exportSession.outputFileType = AVFileTypeMPEG4;
    exportSession.shouldOptimizeForNetworkUse= YES;
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
     {
         
         
         
         
         switch (exportSession.status) {
             case AVAssetExportSessionStatusCancelled:
                 LGLog(@"AVAssetExportSessionStatusCancelled");
                 break;
             case AVAssetExportSessionStatusUnknown:
                 LGLog(@"AVAssetExportSessionStatusUnknown");
                 break;
             case AVAssetExportSessionStatusWaiting:
                 LGLog(@"AVAssetExportSessionStatusWaiting");
                 break;
             case AVAssetExportSessionStatusExporting:
                 LGLog(@"AVAssetExportSessionStatusExporting");
                 break;
             case AVAssetExportSessionStatusCompleted:
                 LGLog(@"AVAssetExportSessionStatusCompleted");
             {
                 LGLog(@"%@",[NSString stringWithFormat:@"%f s", [self getVideoLength:outputURL]]);
                 LGLog(@"%@", [NSString stringWithFormat:@"%.2f kb", [self getFileSize:[outputURL path]]]);
                 
                 //UISaveVideoAtPathToSavedPhotosAlbum([outputURL path], self, nil, NULL);//这个是保存到手机相册
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     self.outputURL = outputURL;
                     UIImage *image = [self thumbnailImageForVideo:outputURL atTime:1];
                     [self.picVideoButton setImage:image forState:UIControlStateNormal];
                     self.playVideo.hidden = NO;
                 });
                 break;
             }
             case AVAssetExportSessionStatusFailed:
                 LGLog(@"AVAssetExportSessionStatusFailed");
                 break;
         }
         
     }];
    
}
- (void)sendVideo{
        self.sendButton.enabled = NO;
     self.progressView.hidden = NO;
    [self uploadFilePath:self.outputURL];
    
}


- (void)uploadFilePath:(NSURL *)path{
   
    NSString *file = [path relativePath];
    if (!path.absoluteString.length) {
        [self sendVideo:nil path:nil];;
        
        return;
    }

    NSString *fileName = [NSString stringWithFormat:@"video/%@",path.lastPathComponent];
    [self.upload uploadfilePath:file fileName:fileName bucketName:nil completion:^(BOOL isSuccess) {
        if (isSuccess) {
            
            
            [SVProgressHUD showSuccessWithStatus:@"上传视频成功"];
            self.progressView.hidden = YES;
            [self sendVideo:fileName path:path];
            
        }else{
           
            [SVProgressHUD showErrorWithStatus:@"上传视频失败"];
             self.progressView.hidden = NO;
            self.sendButton.enabled = YES;
            [SVProgressHUD showErrorWithStatus:@"发送失败"];
        }
        
    }];
    
    
}
- (void)sendVideo:(NSString *)fileName path:(NSURL *)path{
    
    //发送json数据到服务器
    
    //判断对象是否能转换成json
  
    
    NSData *data = [path.lastPathComponent dataUsingEncoding:NSUTF8StringEncoding];
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [[LGNetWorkingManager manager] requestPostImageTitle:self.textView.text content:json :^(BOOL isSuccess) {
        if (isSuccess) {
            self.sendButton.enabled = YES;
            [SVProgressHUD showSuccessWithStatus:@"发送成功"];
            [self dismissView];
            
        }else{
            self.sendButton.enabled = YES;
            [SVProgressHUD showErrorWithStatus:@"发送失败"];
        }
    }];

}


- (void)dismissView{
    [self.textView resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (UIImage*)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    
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
    
    return thumbnailImage;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}
@end
