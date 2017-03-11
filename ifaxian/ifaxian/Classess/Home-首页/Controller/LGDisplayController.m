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
#import "LGUserController.h"
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
#pragma mark - 添加自定义导航条懒加载
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
    //隐藏当前导航条
    self.navigationController.navigationBar.hidden = NO;
    //设置当代理
    self.delegate = self;
    //禁止编辑
    [self stopEditing];
    self.mediaAdded = [NSMutableDictionary dictionary];
    self.videoPressCache = [[NSCache alloc] init];
    [self setNav];
    [self setupUI];
    self.navItem.title = @"文章详情";
    [self setupCommentView];
    //添加更多按钮
    self.navItem.rightBarButtonItem = [UIBarButtonItem lg_itemWithImage:@"more_icon" highImage:@"" target:self action:@selector(more)];
    //监听键盘弹起时间
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commentWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    
}
#pragma mark - 跟多按钮点击方法
- (void)more{
   
    UIAlertController *alerVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"您要？" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alerVc addAction:[UIAlertAction actionWithTitle:@"复制链接地址" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:[NSString stringWithFormat:@"%@ %@",self.model.title,self.model.url]];
        [SVProgressHUD showSuccessWithStatus:@"复制成功"];
        
    }]];
    [alerVc addAction:[UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    
        [LGJubaoView showView];
        
    }]];

    
    LGWeakSelf;
    if ([self.model.author.slug isEqualToString:[LGNetWorkingManager manager].account.user.username] || [[LGNetWorkingManager manager].account.user.ID isEqualToString:@"1"]) {
        [alerVc addAction:[UIAlertAction actionWithTitle:@"删除该文章" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
          UIAlertController *alerVc2 = [UIAlertController alertControllerWithTitle:@"提示" message:@"删除之后不可恢复您确定要删除吗？" preferredStyle:UIAlertControllerStyleAlert];
            [alerVc2 addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [alerVc2 addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [[LGNetWorkingManager manager] requestDeleteArticlePost_slug:_model.slug post_id:[NSString stringWithFormat:@"%zd",_model.ID] completion:^(BOOL isSuccess) {
                    if (isSuccess) {
                        [SVProgressHUD showSuccessWithStatus:@"删除成功"];
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    }else{
                        [SVProgressHUD showErrorWithStatus:@"删除失败"];
                    }
                    
                }];
            }]];
             [weakSelf presentViewController:alerVc2 animated:YES completion:nil];
        }]];
        
    }
    
    [alerVc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
    }]];
    [self presentViewController:alerVc animated:YES completion:nil];
    
}

#pragma mark - 监听键盘弹弹起事件
- (void)commentWillChange:(NSNotification *)noti{
    //对按钮进行判断
    //如果发送按钮隐藏，那么点击评论按钮显示，交换显示
    self.commentSendButton.hidden = self.commentButton.hidden;
    self.commentButton.hidden = !self.commentSendButton.hidden;
    //拿到键盘的尺寸
    CGRect rect = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //就按当前的偏移位置
    CGFloat offset = self.view.lg_height - rect.origin.y;
    __weak typeof(self) weakSelf = self;
    //更新评论框高度的约束
    [self.commentView mas_updateConstraints:^(MASConstraintMaker *make) {
       
       make.bottom.mas_equalTo(weakSelf.view.mas_bottom).offset(-offset);
        
    }];
    //添加动画
    [UIView animateWithDuration:[noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        [self.view layoutIfNeeded];
        
    }];
    
    
}

//移除通知
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
#pragma mark - 布局评论框
- (void)setupCommentView{
    
    UIView *commentView = [[UIView alloc] init];
    UIImageView *imageView = [[UIImageView alloc] init];
    commentView.backgroundColor = LGCommonColor;
    /**
     *  背景图片
     */
    UITextField *textField = [[UITextField alloc] init];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.placeholder = @"你有什么看法呢";
    textField.backgroundColor = [UIColor whiteColor];
    //按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.hidden = YES;
    [button setImage:[UIImage imageNamed:@"comment_home_con"] forState:UIControlStateNormal];
    [sendButton setImage:[UIImage imageNamed:@"send_icon"] forState:UIControlStateNormal];
    [self.view addSubview:commentView];
    [commentView addSubview:imageView];
    [commentView addSubview:textField];
    [commentView addSubview:button];
    [commentView addSubview:sendButton];
    //添加约束
     __weak typeof(self) weakSelf = self;
    [commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        //高度47
        make.height.equalTo(@47);
        //等于底部
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom);
        //↔️距离为0
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
#pragma mark - 点击评论按钮方法
- (void)didComments{
    LGCommentController *comVc = [[LGCommentController alloc] init];
    comVc.model = self.model;
    [self.navigationController pushViewController:comVc animated:YES];
    
}
#pragma 发送评论
- (void)sendComments{
    
    NSString *ID = [NSString stringWithFormat:@"%zd",self.model.ID];
    LGWeakSelf;
    [[LGNetWorkingManager manager] requestPostComment:self.commentTextField.text commentPostId:ID commentParent:nil completion:^(BOOL isSuccess){
       
        if (isSuccess) {
            [SVProgressHUD showSuccessWithStatus:@"评论成功"];
            [weakSelf.commentTextField resignFirstResponder];
            weakSelf.commentTextField.text = nil;
            

        }else{
            
            [SVProgressHUD showErrorWithStatus:@"评论失败"];
        }
        
    }];
    
}

#pragma mark - 布局头部作者信息框
- (void)setupUI{

    
    LGContenHeraderView *view = [LGContenHeraderView viewFromeNib];
    view.authorLable.text = self.model.author.name;
    [view.avatarImageView setHeader:[self.model.author.slug lg_getuserAvatar]];
    view.frame = CGRectMake(0, self.navBar.lg_height, self.view.lg_width, 50);
    self.editorView.lg_y = 114;
    self.editorView.lg_height = self.view.lg_height - 114 - 47;
    [self.view addSubview:view];
    //查找scroview
    [self findScrollViewsInView:self.editorView];
    //添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(go2userVc)];
    [view.avatarImageView addGestureRecognizer:tap];
 
}
#pragma mark - 点击用户头像跳转方法
- (void)go2userVc{
    
   UIStoryboard *story =  [UIStoryboard storyboardWithName:NSStringFromClass([LGUserController class]) bundle:nil];
   LGUserController *userVc = [story instantiateInitialViewController];
    userVc.author = self.model.author;
    [self.navigationController pushViewController:userVc  animated:YES];
    
}
#pragma mark - 查找scroview方法
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

#pragma mark - 设置nav方法
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
