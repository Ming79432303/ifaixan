//
//  LGSenImageController.m
//  ifaxian
//
//  Created by ming on 16/11/29.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGSenImageController.h"
#import "LGAliYunOssUpload.h"
#import "LGTextView.h"
#import "LGPhotoImage.h"
#import "TZImagePickerController.h"
#import "UIView+Layout.h"
#import "LGSelectImageCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "LxGridViewFlowLayout.h"
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"
#import "TZPhotoPreviewController.h"
#import <UIKit/UIKit.h>
#import "LGPhoto.h"
#import "LGPhotoImage.h"
@interface LGSenImageController ()<LGAliYunOssUploadDelegate,TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate>{
    //选择的图片数组
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    //是否原图
    BOOL _isSelectOriginalPhoto;
    //选中图片的宽和间距
    CGFloat _itemWH;
    CGFloat _margin;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;

@property (weak, nonatomic) UIView *footView;
@property (strong ,nonatomic) LGAliYunOssUpload *upload;
@property (strong, nonatomic) NSMutableArray<LGPhotoImage *> *imagesArray;
@property (strong, nonatomic) NSMutableArray *imageUrls;
@property (weak, nonatomic) UITextView *textView;
@property (strong, nonatomic) LGPhotoImage *lastImage;
@property (nonatomic,strong) UIButton *sendButton;
@property (assign, nonatomic)  CGFloat maxCountTF;  ///< 照片最大可选张数，设置为1即为单选模式
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) CWStatusBarNotification *notification;
@property(nonatomic, strong) LGNetWorkingManager   *manager;
@end

@implementation LGSenImageController

- (NSMutableArray *)imagesArray{
    if (_imagesArray == nil) {
        _imagesArray = [NSMutableArray array];
    }
    
    return _imagesArray;
}


- (LGNetWorkingManager *)manager{
    
    if (_manager == nil) {
        _manager = [LGNetWorkingManager manager];
    }
    return _manager;
}


- (UIImagePickerController *)imagePickerVc{
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
            
            
        }
//        /Users/ming/Desktop/ifaxan/ifaixan/ifaxian/ifaxian/Classess/Other-其他/Controller/LGWriteController/Controller/LGSenImageController.m:84:42: 'appearanceWhenContainedIn:' is deprecated: first deprecated in iOS 9.0 - Use +appearanceWhenContainedInInstancesOfClasses: instead
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
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
    self.maxCountTF = 9;
    self.upload.delegate = self;
    _selectedPhotos = [NSMutableArray array];
    _selectedAssets = [NSMutableArray array];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isSendButton) name:UITextViewTextDidChangeNotification object:self.textView];
    [self setupUI];
}


- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)isSendButton {
    
    self.sendButton.enabled = self.textView.text.length ? YES : NO;
    
}

- (void)setupUI{
    self.view.frame = [UIScreen mainScreen].bounds;
    LGTextView *textField = [[LGTextView alloc] init];
    textField.backgroundColor = [UIColor whiteColor];
    textField.frame = CGRectMake(0, 0, 200, 100);
    self.textView = textField;
    self.tableView.tableHeaderView = textField;
    //选中图片展示
    UIView *footView = [[UIView alloc] init];
    
    footView.frame = CGRectMake(0, 0, 200, self.view.tz_height - 220);
    
    self.tableView.tableFooterView = footView;
    
    self.footView = footView;
    
    [self configCollectionView];
    
    [self setupNav];
    
 
}
- (void)configCollectionView {
    // 如不需要长按排序效果，将LxGridViewFlowLayout类改成UICollectionViewFlowLayout即可
    LxGridViewFlowLayout *layout = [[LxGridViewFlowLayout alloc] init];
    _margin = 4;
    _itemWH = (self.view.tz_width - 2 * _margin - 4) / 3 - _margin;
    layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    layout.minimumInteritemSpacing = _margin;
    layout.minimumLineSpacing = _margin;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 20, self.view.tz_width, self.view.tz_height - 180) collectionViewLayout:layout];
    CGFloat rgb = 244 / 255.0;
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];
    _collectionView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.footView addSubview:_collectionView];
    [_collectionView registerClass:[LGSelectImageCell class] forCellWithReuseIdentifier:@"TZTestCell"];
}

- (void)setupNav{
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



- (void)aliyunOssUploa:(LGAliYunOssUpload *)upload Progress:(CGFloat)progress{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
    });
    
    
    
    
}



#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _selectedPhotos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LGSelectImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    cell.videoImageView.hidden = YES;
    if (indexPath.row == _selectedPhotos.count) {
        cell.imageView.image = [UIImage imageNamed:@"AlbumAddBtn.png"];
        cell.deleteBtn.hidden = YES;
    } else {
        cell.imageView.image = _selectedPhotos[indexPath.row];
        cell.asset = _selectedAssets[indexPath.row];
        cell.deleteBtn.hidden = NO;
    }
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _selectedPhotos.count) {
        //外部显示拍照
        BOOL showSheet = NO;
        if (showSheet) {
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"去相册选择", nil];
            [sheet showInView:self.view];
        } else {
            [self pushImagePickerController];
        }
    } else { // preview photos or video / 预览照片或者视频
        id asset = _selectedAssets[indexPath.row];
        BOOL isVideo = NO;
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = asset;
            isVideo = phAsset.mediaType == PHAssetMediaTypeVideo;
        } else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = asset;
            isVideo = [[alAsset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo];
        }
        if (isVideo) { // perview video / 预览视频
            TZVideoPlayerController *vc = [[TZVideoPlayerController alloc] init];
            TZAssetModel *model = [TZAssetModel modelWithAsset:asset type:TZAssetModelMediaTypeVideo timeLength:@""];
            vc.model = model;
            [self presentViewController:vc animated:YES completion:nil];
        } else { // preview photos / 预览照片
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectedAssets selectedPhotos:_selectedPhotos index:indexPath.row];
            imagePickerVc.maxImagesCount = self.maxCountTF;
            //允许选择原图
            imagePickerVc.allowPickingOriginalPhoto = YES;
            imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                _selectedPhotos = [NSMutableArray arrayWithArray:photos];
                _selectedAssets = [NSMutableArray arrayWithArray:assets];
                _isSelectOriginalPhoto = isSelectOriginalPhoto;
                [_collectionView reloadData];
                _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
            }];
            [self presentViewController:imagePickerVc animated:YES completion:nil];
        }
    }
}

#pragma mark - LxGridViewDataSource

/// 以下三个方法为长按排序相关代码
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.item < _selectedPhotos.count;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath canMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    return (sourceIndexPath.item < _selectedPhotos.count && destinationIndexPath.item < _selectedPhotos.count);
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    UIImage *image = _selectedPhotos[sourceIndexPath.item];
    [_selectedPhotos removeObjectAtIndex:sourceIndexPath.item];
    [_selectedPhotos insertObject:image atIndex:destinationIndexPath.item];
    
    id asset = _selectedAssets[sourceIndexPath.item];
    [_selectedAssets removeObjectAtIndex:sourceIndexPath.item];
    [_selectedAssets insertObject:asset atIndex:destinationIndexPath.item];
    
    [_collectionView reloadData];
}

- (void)pushImagePickerController {
    
    CGFloat maxCount = self.maxCountTF;
    if (maxCount <= 0) {
        return;
    }
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:self.maxCountTF columnNumber:3 delegate:self pushPhotoPickerVc:YES];
    
    
#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    //当前为一张图片
    if (self.maxCountTF > 1) {
        // 1.设置目前已经选中的图片数组
        imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
    }
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    
    // 2. Set the appearance
    // 2. 在这里设置imagePickerVc的外观
    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    
    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = NO;
    
    // imagePickerVc.minImagesCount = 3;
    // imagePickerVc.alwaysEnableDoneBtn = YES;
    
    // imagePickerVc.minPhotoWidthSelectable = 3000;
    // imagePickerVc.minPhotoHeightSelectable = 2000;
    
    /// 5. Single selection mode, valid when maxImagesCount = 1
    /// 5. 单选模式,maxImagesCount为1时才生效
//    imagePickerVc.showSelectBtn = NO;
//    imagePickerVc.allowCrop = NO;
//    imagePickerVc.needCircleCrop = NO;
//    imagePickerVc.circleCropRadius = 100;
    
    /*
     [imagePickerVc setCropViewSettingBlock:^(UIView *cropView) {
     cropView.layer.borderColor = [UIColor redColor].CGColor;
     cropView.layer.borderWidth = 2.0;
     }];*/
    
    //imagePickerVc.allowPreview = NO;
#pragma mark - 到这里为止
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        //如果是原图
                 //对gif进行判断
            [self getImages:assets];
 
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}
#pragma mark - 对是否要拿gif判断
- (void)getImages:(NSArray *)assets{
    PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
    // 从asset中获得图片

    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    for (PHAsset *asset in assets) {
        
        
        
        LGWeakSelf;
        [imageManager requestImageDataForAsset:asset
                                       options:options
                                 resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                                     //gif 图片
                                     
                                     if ([dataUTI isEqualToString:(__bridge NSString *)kUTTypeGIF]) {
                                         //这里获取gif图片的NSData数据
                                         LGPhotoImage *image = [LGPhotoImage phototisGif:YES image:[UIImage imageWithData:imageData] imageData:imageData];
                                         [weakSelf.imagesArray addObject:image];
                                         
                                         
                                         
                                     } else {
                                         //这里获取其他图片的NSData数据
                                         LGPhotoImage *image = [LGPhotoImage phototisGif:NO image:[UIImage imageWithData:imageData] imageData:imageData];
                                         [weakSelf.imagesArray addObject:image];

                                     }
                                 }];
    }
    
}



// The picker should dismiss itself; when it dismissed these handle will be called.
// If isOriginalPhoto is YES, user picked the original photo.
// You can get original photo with asset, by the method [[TZImageManager manager] getOriginalPhotoWithAsset:completion:].
// The UIImage Object in photos default width is 828px, you can set it by photoWidth property.
// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    [_collectionView reloadData];
    // _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
    
    // 1.打印图片名字
    [self printAssetsName:assets];
}

- (void)deleteBtnClik:(UIButton *)sender {
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    [_selectedAssets removeObjectAtIndex:sender.tag];
    [_imagesArray removeObjectAtIndex:sender.tag];
    
    [_collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [_collectionView reloadData];
    }];
}


/// 打印图片名字
- (void)printAssetsName:(NSArray *)assets {
    NSString *fileName;
    for (id asset in assets) {
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = (PHAsset *)asset;
            fileName = [phAsset valueForKey:@"filename"];
        } else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = (ALAsset *)asset;
            fileName = alAsset.defaultRepresentation.filename;;
        }
        NSLog(@"图片名字:%@",fileName);
    }
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}






#pragma 发送图片

- (void)sendImage:(id)sender {
    
    CWStatusBarNotification *notification = [CWStatusBarNotification new];
    
    self.notification = notification;
    notification.notificationLabelBackgroundColor = [UIColor lightGrayColor];
    [self setupNotification];
    
    [notification displayNotificationWithMessage:@"正在发送..." forDuration:1.0];
    [self close:nil];
       LGWeakSelf;
    dispatch_group_t group = dispatch_group_create();
//    [SVProgressHUD showWithStatus:@"正在上传图片.."];
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
          
            [weakSelf.upload uploadfileData:data fileName:imageName bucketName:nil completion:^(BOOL isSuccess) {
                if (isSuccess) {
                    if (photoImage.isGif) {
                        
                        [weakSelf.imageUrls addObject:[NSString stringWithFormat:@"%@.gif",imageID]] ;
                    }else{
                        [weakSelf.imageUrls addObject:[NSString stringWithFormat:@"%@.jpg",imageID]] ;
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
//        NSData *data = [NSJSONSerialization dataWithJSONObject:self.imageUrls options:kNilOptions error:nil];
//        NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        for (NSString *url in self.imageUrls) {
            // <a href="https://79432303.oss-cn-shanghai.aliyuncs.com/images/1E53C48D-56A6-47CE-8ABD-B23D1FCE9819.jpg"><img src="http://79432303.oss-cn-shanghai.aliyuncs.com/images/1E53C48D-56A6-47CE-8ABD-B23D1FCE9819.jpg" alt="" /></a>
            //E9CA5808-051D-4B05-BEE3-392A11357BEF.gif
            
            NSString *htmlStr =  [NSString stringWithFormat:@"<a href=\"https://79432303.oss-cn-shanghai.aliyuncs.com/squareImages/%@\"><img src=\"https://79432303.oss-cn-shanghai.aliyuncs.com/squareImages/%@\" alt=\"\" /></a>",url,url];
            [htmstrM appendString:htmlStr];
        }
        
        
        
        LGWeakSelf;
        [[LGNetWorkingManager manager] requestPostImageTitle:self.textView.text content:htmstrM :^(BOOL isSuccess) {
            CWStatusBarNotification *notification = [CWStatusBarNotification new];
           
            notification.notificationLabelBackgroundColor = [UIColor lightGrayColor];
            [self setupNotification];

            if (isSuccess) {
                
                [notification displayNotificationWithMessage:@"发送成功" forDuration:1.0];
                [weakSelf close:nil];
            }else{
                
               [notification displayNotificationWithMessage:@"发送失败" forDuration:1.0];
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

- (void)setupNotification
{
    self.notification.notificationAnimationInStyle = CWNotificationAnimationStyleTop;
    self.notification.notificationAnimationOutStyle =CWNotificationAnimationStyleTop;
    self.notification.notificationStyle  = CWNotificationStyleStatusBarNotification;
}
- (void)tap:(UIGestureRecognizer *)tap{
    [tap.view endEditing:YES];
    
}

@end
