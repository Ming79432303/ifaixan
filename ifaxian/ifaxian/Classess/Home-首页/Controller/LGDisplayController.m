//
//  LGDisplayController.m
//  ifaxian
//
//  Created by ming on 16/11/18.
//  Copyright © 2016年 ming. All rights reserved.
//
#define comHeight 47
#import "LGDisplayController.h"
@import Photos;
@import AVFoundation;
@import MobileCoreServices;
#import "LWImageBrowser.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "WPEditorField.h"
#import "WPEditorView.h"
#import <WordPressShared/WPFontManager.h>
#import "LGCommentController.h"
#import "LGContenHeraderView.h"
@interface LGDisplayController ()<LWHTMLDisplayViewDelegate>
@property (nonatomic,strong) LWHTMLDisplayView* htmlView;
@property (nonatomic,strong) UILabel* coverTitleLabel;
@property (nonatomic,strong) UILabel* coverDesLabel;
@property (nonatomic,assign) BOOL isNeedRefresh;
@property(nonatomic, strong) UINavigationBar *navBar;
@property(nonatomic, strong)  UINavigationItem *navItem;
@property(nonatomic, weak) UIView *commentView;
@property(nonatomic, weak) UIButton *commentButton;
@property(nonatomic, weak) UIButton *commentSendButton;
@property(nonatomic, weak) UITextField *commentTextField;


@end
#define kImageDisplayIdentifier @"imageDisplayIdentifier"
#define kContentDisplayIdentifier @"contentDisplayIdentifier"

@implementation LGDisplayController

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
    self.navigationController.navigationBar.hidden = NO;
    self.delegate = self;
    [self stopEditing];
    self.mediaAdded = [NSMutableDictionary dictionary];
    self.videoPressCache = [[NSCache alloc] init];
    [self setNav];
    [self setupUI];
   [self setupCommentView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commentWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    
    
}
- (void)commentWillChange:(NSNotification *)noti{
    
#warning 按钮状态有问题
    
    self.commentSendButton.hidden = self.commentButton.hidden;
    self.commentButton.hidden = !self.commentSendButton.hidden;
    
    CGRect rect = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    
    CGFloat offset = self.view.lg_height - rect.origin.y;
    __weak typeof(self) weakSelf = self;
    [self.commentView mas_updateConstraints:^(MASConstraintMaker *make) {
       
       make.bottom.mas_equalTo(weakSelf.view.mas_bottom).offset(-offset);
        
    }];
    [UIView animateWithDuration:[noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        [self.view layoutIfNeeded];
        
    }];
    
    
}


- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)setupCommentView{
    
    UIView *commentView = [[UIView alloc] init];
    UIImageView *imageView = [[UIImageView alloc] init];
    /**
     *  背景图片
     */
    imageView.image = [UIImage imageNamed:@"comment-bar-bg"];
    UITextField *textField = [[UITextField alloc] init];
    textField.placeholder = @"你有什么看法呢";
    textField.backgroundColor = [UIColor whiteColor];
    //按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.hidden = YES;
    
    [button setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
    
    [sendButton setImage:[UIImage imageNamed:@"发送"] forState:UIControlStateNormal];
    
    [self.view addSubview:commentView];
    [commentView addSubview:imageView];
    [commentView addSubview:textField];
    [commentView addSubview:button];
    [commentView addSubview:sendButton];
    
     __weak typeof(self) weakSelf = self;
    [commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@47);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom);
        make.left.right.mas_equalTo(weakSelf.view).offset(0);
    }];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.bottom.mas_equalTo(commentView);
    }];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.height.equalTo(@(comHeight - 2 * LGCommonSmallMargin));
       
        make.right.mas_equalTo(button.mas_left).offset(-10);
        make.top.mas_equalTo(commentView.mas_top).offset(LGCommonSmallMargin);
        make.left.mas_equalTo(commentView.mas_left).offset(LGCommonMargin);
    }];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.size.mas_equalTo(CGSizeMake(comHeight, comHeight));
        make.bottom.mas_equalTo(commentView).offset(0);
        make.right.mas_equalTo(commentView).offset(-LGCommonMargin); 
    }];
    
    [sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(comHeight, comHeight));
        make.bottom.mas_equalTo(commentView).offset(0);
        make.right.mas_equalTo(commentView).offset(-LGCommonMargin);
    }];

    
    [button addTarget:self action:@selector(didComments) forControlEvents:UIControlEventTouchUpInside];
    [sendButton addTarget:self action:@selector(sendComments) forControlEvents:UIControlEventTouchUpInside];
    self.commentView = commentView;
    self.commentButton = button;
    self.commentSendButton = sendButton;
    self.commentTextField = textField;
    
}
- (void)didComments{
    LGCommentController *comVc = [[LGCommentController alloc] init];
    comVc.model = self.model;
    [self.navigationController pushViewController:comVc animated:YES];
    
}
#pragma 发送评论
- (void)sendComments{
    
    NSString *ID = [NSString stringWithFormat:@"%zd",self.model.ID];
    
    [[LGNetWorkingManager manager] requestPostComment:self.commentTextField.text commentPostId:ID commentParent:nil completion:^(BOOL isSuccess){
       
        if (isSuccess) {
            [SVProgressHUD showSuccessWithStatus:@"评论成功"];
            [self.commentTextField resignFirstResponder];
            self.commentTextField.text = nil;
            

        }else{
            
            [SVProgressHUD showErrorWithStatus:@"评论失败"];
        }
        
    }];
    
}


- (void)setupUI{
#warning 设置头像调整数据待做
    LGContenHeraderView *view = [LGContenHeraderView viewFromeNib];
    
    view.authorLable.text = self.model.author.name;
    
    view.frame = CGRectMake(0, self.navBar.lg_height, self.view.lg_width, 50);
   
    self.editorView.lg_y = 114;
    self.editorView.lg_height = self.view.lg_height - 114 - 47;

    [self.view addSubview:view];
    
   

    [self findScrollViewsInView:self.editorView];

   
 
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
    //inset.top = LGnavBarH + 50;
    inset.bottom = 47;
   
    
    scrollView.contentInset = inset;
    
    
    
    // [scrollView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}


- (void)setNav{
    self.navItem.leftBarButtonItem = [UIBarButtonItem lg_barButtonCustButton:@"返回" fontSize:14 addTarget:self action:@selector(editTouchedUpInside) isBack:YES];
    
    self.navigationController.navigationBar.hidden = YES;
    
    self.navBar.frame = self.navigationController.navigationBar.bounds;
    self.navBar.lg_height += 20;
    self.navBar.items = @[self.navItem];
    self.navBar.barTintColor = [UIColor lg_colorWithHex:0xF6F6F6];
    self.navBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor lg_colorWithRed:37 green:37 blue:37]};
    
    [self.view addSubview:self.navBar];

    
    
}
#pragma mark - Navigation Bar

- (void)editTouchedUpInside
{
    
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - WPEditorViewControllerDelegate


- (void)editorDidFinishLoadingDOM:(WPEditorViewController *)editorController
{
   
    NSString *htmlParam = self.model.content;
    [self setTitleText:self.model.title];
    [self setBodyText:htmlParam];
}


- (void)editorViewController:(WPEditorViewController*)editorViewController
                 imageTapped:(NSString *)imageId
                         url:(NSURL *)url
                   imageMeta:(WPImageMeta *)imageMeta{
    
   
}


@end
