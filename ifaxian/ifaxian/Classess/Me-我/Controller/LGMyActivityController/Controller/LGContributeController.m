//
//  LGContributeController.m
//  ifaxian
//
//  Created by ming on 16/12/14.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGContributeController.h"
#import "LGContributeSuccessView.h"
@interface LGContributeController ()
@property (weak, nonatomic) IBOutlet UITextField *nikNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *webUrlTextField;

@property (weak, nonatomic) IBOutlet UITextField *titlelTextField;
@property (weak, nonatomic) IBOutlet UITextView *contentlTextField;

@end

@implementation LGContributeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.showsVerticalScrollIndicator = NO;
    _contentlTextField.layer.backgroundColor = [[UIColor clearColor] CGColor];
    
    
    _contentlTextField.layer.borderColor = [[UIColor blackColor]CGColor];
    
    
    _contentlTextField.layer.borderWidth = 1.0;
    
    
    _contentlTextField.layer.cornerRadius = 8.0f;
    
    
    [_contentlTextField.layer setMasksToBounds:YES];

  
}
- (IBAction)send:(id)sender {
    
    if (_nikNameTextField.text.length && _emailTextField.text.length && _titlelTextField.text.length && _contentlTextField.text.length) {
        
        if (_titlelTextField.text.length < 10 && _titlelTextField.text.length > 100) {
            [SVProgressHUD showErrorWithStatus:@"标题字数要在10~100之内"];
            return;
        }
        if (_contentlTextField.text.length < 100 ) {
            [SVProgressHUD showErrorWithStatus:@"内容字数字数要大于100"];
            return;
        }
 
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"submitName"] = self.nikNameTextField.text;
    
    parameters[@"submitEmail"] = self.emailTextField.text;
     parameters[@"submitTitle"] = self.titlelTextField.text;
     parameters[@"submitBlog"] = self.webUrlTextField.text;
     parameters[@"submitContent"] = self.contentlTextField.text;
    
    [[LGHTTPSessionManager manager] request:LGRequeTypePOST urlString:@"http://ifaxian.cc/%e6%8f%90%e4%ba%a4" parameters:parameters completion:^(BOOL isSuccess, id responseObject) {
        if (isSuccess) {
            
     
            LGContributeSuccessView *successView = [LGContributeSuccessView viewFromeNib];
            successView.frame = self.view.frame;
            [self.view addSubview:successView];
        }else{
           
        }
    }];
    }else{
        
         [SVProgressHUD showErrorWithStatus:@"打*号的不能留空"];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [self.view endEditing:YES];
}
@end
