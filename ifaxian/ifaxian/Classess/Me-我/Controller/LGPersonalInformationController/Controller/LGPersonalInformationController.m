//
//  LGPersonalInformationController.m
//  ifaxian
//
//  Created by ming on 16/11/21.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGPersonalInformationController.h"
#import "LGUserList.h"
#import "LGUserItem.h"
#import "UIImageView+LGUIimageView.h"
#import "LGUserInfoCell.h"
#import "LGAliYunOssUpload.h"
#import "LGEditorInfoView.h"


@interface LGPersonalInformationController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,LGAliYunOssUploadDelegate,LGEditorInfoViewDelegate>

@property(nonatomic, strong) NSArray *userList;
@property(nonatomic, strong) LGUserList *userItem;
@property(nonatomic, strong) LGEditorInfoView *editorInfoView;
@property(nonatomic, strong) LGHTTPSessionManager *manager;
@end

@implementation LGPersonalInformationController

static NSString *userCellID = @"userCellID";

- (LGHTTPSessionManager *)manager{
    
    if (_manager == nil) {
        _manager = [LGHTTPSessionManager manager];
    }
    
    return _manager;
}

- (LGEditorInfoView *)editorInfoView{
    if (_editorInfoView == nil) {
        _editorInfoView = [LGEditorInfoView viewFromeNib];
        _editorInfoView.delegate = self;
    }
    
    return _editorInfoView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupTableView];
    [self loadData];

    
    // Do any additional setup after loading the view.
}
- (void)setupTableView{
    
 
    self.tableView.backgroundColor = LGCommonColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 50;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LGUserInfoCell class])  bundle:nil] forCellReuseIdentifier:userCellID];
}

- (void)loadData{
    
    
    
    
    
    [self.manager requestUsercompletion:^(BOOL isSuccess, NSDictionary * responseObject) {
        if (isSuccess) {
            
            NSString *userInfo = @"userinfo.plist";
            NSString *filePath = [userInfo lg_appendDocumentDir];
            [responseObject writeToFile:filePath atomically:YES];
            
            [self configeList:responseObject];

            [self.tableView reloadData];
          

           [[NSNotificationCenter defaultCenter] postNotificationName:LGUserupdataImageNotification object:nil userInfo:@{@"filePath":filePath}];
#warning //写入到磁盘
            
//           
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                NSString *url = @"http://112.74.45.39/wp-admin/admin-ajax.php";
//                NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//                parameters[@"token"] = @"90430e0acababab5d01895bd0c1c0ad6917040d2";
//                parameters[@"action"] = @"rtmedia_api";
//                NSData *date = [NSData dataWithContentsOfFile:@"/Users/ming/Desktop/image/1.jpg"];
//               // parameters[@"rtmedia_file"] = date;
//                parameters[@"method"] = @"rtmedia_upload_media";
//                parameters[@"context"] = @"profile";
//                //parameters[@"image_type"] = @"jpeg/png";
//                parameters[@"title"] = @"12346";
//                //parameters[@"content"] = @"客户端发送";
////                [[LGHTTPSessionManager manager] request:LGRequeTypePOST urlString:url parameters:parameters completion:^(BOOL isSuccess, id responseObject) {
////                    NSLog(@"%@",responseObject);
////                }];
//                [[LGHTTPSessionManager manager] POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//                  return [formData appendPartWithFileData:date name:@"rtmedia_file" fileName:@"123.jpg" mimeType:@"jpeg/png"];
//                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//                    NSLog(@"%@",responseObject);
//                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                    
//                }];
//            });
//            
            

          
        }else{
            [SVProgressHUD showErrorWithStatus:@"获取信息失败"];
            
        }
        
    }];
}
- (void)configeList:(NSDictionary *)responseObject{
    //个人信息
    
    //**** 第一组 ***//
    
    NSArray *user_info = @[@"lg_user_avatar",@"bac",@"nickname",@"lg_capabilities",@"city",@"website",@"signature"];
    NSArray *user_infoTitle = @[@"更换头像",@"更换背景图",@"昵称",@"用户身份",@"居住地",@"我的站点",@"个人说明"];
    NSArray *groupUserInfo = [self userinfo:responseObject userinfoKeys:user_info userTitle:user_infoTitle];
       LGUserItem *item1 = [LGUserItem userGruopTitle:@"个人基本信息" userInfo:groupUserInfo];
    //**** 第二组 ***//
    NSArray *user_contact = @[@"user_email",@"user_phone_number"];
    //对应标题
    NSArray *user_contactTitle = @[@"邮箱",@"电话号码"];
    NSArray *groupUserContact = [self userinfo:responseObject userinfoKeys:user_contact userTitle:user_contactTitle];
       LGUserItem *item2 = [LGUserItem userGruopTitle:@"联系方式" userInfo:groupUserContact];
    //组合标题
    NSArray *userList = @[item1,item2];
    self.userList = userList;
}


- (NSArray *)userinfo:(NSDictionary *)userinfo userinfoKeys:(NSArray *)userKeys userTitle:(NSArray *)userTitle{
    
    NSMutableArray *arrayM = [NSMutableArray array];
    int index = 0;
    for (NSString *key in userKeys) {
        NSString *content = userinfo[key];
        NSString *title = userTitle[index];
      LGUserList *list = [LGUserList userTitle:title content:content parameter:key];
        [arrayM addObject:list];
        index += 1;
        
    }
    return arrayM;
    
}


-(void)setupNavBar{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.userList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
    LGUserItem *item = self.userList[section];
    
    return item.userInfos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    LGUserItem *item = self.userList[indexPath.section];
    LGUserList *model = item.userInfos[indexPath.row];
    
    LGUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:userCellID];
    [cell setModle:model section:indexPath.section];
   
    return cell;
    
    
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    LGUserItem *item = self.userList[section];
//    return item.title;
//    
//}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return LGCommonMargin;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}
//更改组标题
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    LGUserItem *item = self.userList[section];
    UITableViewHeaderFooterView *hfView = [[UITableViewHeaderFooterView alloc] init];
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(LGCommonSmallMargin,  LGCommonMargin, self.tableView.lg_width - 2 * LGCommonSmallMargin, 40 -1);
    view.backgroundColor = [UIColor whiteColor];
    UILabel *titleLable = [[UILabel alloc] init];
    titleLable.backgroundColor = [UIColor whiteColor];
    titleLable.font = [UIFont systemFontOfSize:13];
    titleLable.textColor = [UIColor lightGrayColor];
    titleLable.frame = CGRectMake(2 * LGCommonMargin,  0, view.lg_width/2, view.lg_height);
    titleLable.text = item.title;
    [view addSubview:titleLable];
    [hfView addSubview:view];
    return hfView;
    
}

#pragma mark - 表格代理方法，单击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LGUserItem *item = self.userList[indexPath.section];
    LGUserList *model = item.userInfos[indexPath.row];
    _userItem = model;
    if ([model.parameter isEqualToString:@"lg_user_avatar"]) {
        
        [self upadataAvatar:model];

    }else if ([model.parameter isEqualToString:@"bac"]) {
         [self upadataAvatar:model];
    }else if ([model.parameter isEqualToString:@"lg_capabilities"]){
        [SVProgressHUD showInfoWithStatus:@"您没有权限更改身份"];
        return;
    }else{
        self.editorInfoView.frame = [UIScreen mainScreen].bounds;
        self.editorInfoView.textField.text = model.content;
        self.editorInfoView.titleLable.text = model.title;
        
        [[UIApplication sharedApplication].keyWindow addSubview:self.editorInfoView];
        [self.editorInfoView.textField becomeFirstResponder];
    }
    
  
}
/**
 *  弹出提示框
 *
 *
 */
- (void)upadataAvatar:(LGUserList *)model{
    UIAlertController *alerView = [UIAlertController alertControllerWithTitle:model.title message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alerView addAction: [UIAlertAction actionWithTitle:model.title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self upadataImage];
        
    }]];
    [alerView addAction: [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alerView animated:YES completion:nil];
    
}
- (void)upadataImage{
    
    
    UIImagePickerController *picImage = [[UIImagePickerController alloc] init];
    picImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picImage.delegate = self;
    picImage.mediaTypes = [NSArray arrayWithObject:@"public.image"];
    picImage.allowsEditing = YES;
    
    [self presentViewController:picImage animated:YES completion:nil];
    
    
    
}
#pragma mark - 选择图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
   
//    NSDateFormatter *formater = [[NSDateFormatter alloc] init];//用时间给文件全名，以免重复，在测试的时候其实可以判断文件是否存在若存在，则删除，重新生成文件即可
//    [formater setDateFormat:@"yyyyMMddHHmmss"];
//    NSString *name = [formater stringFromDate:[NSDate date]];//这个是保存在app自己的沙盒路径里，
    
    
    UIImage *bacImage = info[UIImagePickerControllerEditedImage];
    NSData *imageDate = UIImageJPEGRepresentation(bacImage, 1);
    LGAliYunOssUpload *upload = [[LGAliYunOssUpload alloc] init];
    NSString *fileName = [NSString stringWithFormat:@"ifaxian/avatars/%@%@.jpg",[LGNetWorkingManager manager].account.user.username,self.userItem.parameter];
    upload.delegate = self;
    [picker dismissViewControllerAnimated:YES completion:nil];
    [upload uploadfileData:imageDate fileName:fileName bucketName:nil completion:^(BOOL isSuccess) {
        if (isSuccess) {
            NSString *url = [NSString stringWithFormat:@"%@%@",LGbuckeUrl,fileName];
            //更新个人信息
            [self updataUserImage:url];
            
        }
    }];
    
    
}
#pragma mark - 更改用户图片
-(void)updataUserImage:(NSString *)url{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[_userItem.parameter] = url;
    parameters[@"cookie"] = [LGNetWorkingManager manager].account.cookie;
    parameters[@"insecure"] = @"cool";
    LGWeakSelf;
    [self.manager request:LGRequeTypePOST urlString:@"https://ifaxian.cc/api/user/update_user_meta_vars" parameters:parameters completion:^(BOOL isSuccess, id responseObject) {
        
        if ([responseObject[@"status"] isEqualToString:@"ok"]) {
            [SVProgressHUD showSuccessWithStatus:@"更改成功"];
           
            
            [weakSelf loadData];
        }else{
            
            [SVProgressHUD showErrorWithStatus:@"更改失败"];
        }
        
    }];
    
    
    
}


#pragma mark - 更改用户信息
- (void)editoruserInfo:(LGEditorInfoView *)edtiorView{
    
    LGLog(@"跟新用户信息");
  


    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[_userItem.parameter] = edtiorView.textField.text;
    parameters[@"cookie"] = [LGNetWorkingManager manager].account.cookie;
    parameters[@"insecure"] = @"cool";
    LGWeakSelf;
    [self.manager request:LGRequeTypePOST urlString:@"https://ifaxian.cc/api/user/update_user_meta_vars" parameters:parameters completion:^(BOOL isSuccess, id responseObject) {
       
        if ([responseObject[@"status"] isEqualToString:@"ok"]) {
            [SVProgressHUD showSuccessWithStatus:@"更改成功"];
            [edtiorView.textField resignFirstResponder];
            [edtiorView removeFromSuperview];
            [weakSelf loadData];
        }else{
            
             [SVProgressHUD showErrorWithStatus:@"更改失败"];
        }
        
    }];
    
}

- (void)aliyunOssUploa:(LGAliYunOssUpload *)upload Progress:(CGFloat)progress{
    
    dispatch_async(dispatch_get_main_queue(), ^{
    
    });
    
    
}



@end
