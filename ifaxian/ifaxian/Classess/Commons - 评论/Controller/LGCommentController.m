//
//  LGCommentController.m
//  ifaxian
//
//  Created by ming on 16/11/18.
//  Copyright © 2016年 ming. All rights reserved.
//
#define comHeight 47
#import "LGCommentController.h"
#import "LGCommentCell.h"
#import "LGComment.h"
#import "LGCommentHeaderFooterView.h"
@interface LGCommentController()
@property (nonatomic, strong) NSMutableArray<LGComment *> *comments;
@property(nonatomic, weak) UIView *commentView;
@property(nonatomic, weak) UIButton *commentSendButton;
@property(nonatomic, weak) UITextField *commentTextField;
@property(nonatomic, strong) LGHTTPSessionManager *manager;
@end
@implementation LGCommentController
- (NSMutableArray<LGComment *> *)comments{
    
    if (_comments == nil) {
        
        _comments = [NSMutableArray array];
    }
    return _comments;
}

- (LGHTTPSessionManager *)manager{
    
    if (_manager == nil) {
        _manager = [LGHTTPSessionManager manager];
    }
    return _manager;
}

static NSString *cellID = @"commentID";
static NSString *replyCellID = @"replyCellID";
static NSString *commentHFViewID = @"replyCellID";
- (void)viewDidLoad{
    
    [super viewDidLoad];
    [self setupUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commentWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
     [self loadNewData];
}

-(void)setupTableView{
    [super setupTableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LGCommentCell class]) bundle:nil] forCellReuseIdentifier:cellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"LGReplyCell" bundle:nil]forCellReuseIdentifier:replyCellID];
       [self.tableView registerClass:[LGCommentHeaderFooterView class] forHeaderFooterViewReuseIdentifier:commentHFViewID];
    self.tableView.sectionFooterHeight = 40;
    self.tableView.sectionHeaderHeight = 40;
    
    
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)commentWillChange:(NSNotification *)noti{
    
   
    
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
#pragma mark - 布局UI
- (void)setupUI{
    
    self.navItem.title = @"评论";
    
    UIView *commentView = [[UIView alloc] init];
    UIImageView *imageView = [[UIImageView alloc] init];
    /**
     *  背景图片
     */
    imageView.image = [UIImage imageNamed:@"comment-bar-bg"];
    UITextField *textField = [[UITextField alloc] init];
    textField.placeholder = @"我来说两句";
    textField.backgroundColor = [UIColor whiteColor];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    
    //按钮
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton setImage:[UIImage imageNamed:@"comment_send_icon"] forState:UIControlStateNormal];
    
    [self.view addSubview:commentView];
    [commentView addSubview:imageView];
    [commentView addSubview:textField];
  
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
        
        make.right.mas_equalTo(sendButton.mas_left).offset(-10);
        make.top.mas_equalTo(commentView.mas_top).offset(LGCommonSmallMargin);
        make.left.mas_equalTo(commentView.mas_left).offset(LGCommonMargin);
    }];
    
    [sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(comHeight, comHeight));
        make.bottom.mas_equalTo(commentView).offset(0);
        make.right.mas_equalTo(commentView).offset(-LGCommonMargin);
    }];
    
    
    [sendButton addTarget:self action:@selector(sendComments:) forControlEvents:UIControlEventTouchUpInside];
    self.commentView = commentView;
    self.commentSendButton = sendButton;
    self.commentTextField = textField;
    
}
#pragma mark - 发评论
- (void)sendComments:(UIButton *)butn{
    
    if (!self.commentTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"评论不能为空"];
        return;
    }
    
    NSString *parentID = [NSString stringWithFormat:@"%zd",butn.tag];
        [[LGNetWorkingManager manager] requestPostComment:self.commentTextField.text commentPostId:[NSString stringWithFormat:@"%zd",self.model.ID] commentParent:parentID completion:^(BOOL isSuccess) {
            if (isSuccess) {
                [SVProgressHUD showSuccessWithStatus:@"评论成功"];
                [self.commentTextField resignFirstResponder];
                self.commentTextField.text = nil;
                [self loadNewData];
                
            }else{
                
                [SVProgressHUD showErrorWithStatus:@"评论失败"];
            }
            
        }];
    
   
}
- (void)loadNewData{

    NSString *url = [NSString stringWithFormat:@"%@?json=1",self.model.url];

    LGWeakSelf;
    [self.manager requsetCommentUrl:url completion:^(BOOL isSuccess, NSArray *json) {
        if (isSuccess) {
            
          
            //[self.comments addObjectsFromArray: [[[LGComment mj_objectArrayWithKeyValuesArray:json context:nil] reverseObjectEnumerator] allObjects]];
            weakSelf.comments = [LGComment mj_objectArrayWithKeyValuesArray:json context:nil];
            
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView reloadData];
            
            if (weakSelf.comments.count == [weakSelf.model.comment_count integerValue]) {
                 weakSelf.tableView.mj_footer.hidden = YES;
            }
            
        }else{
            
            
            
        }
    }];
    
    
}
- (void)loadOldData{
    
    
        self.tableView.mj_footer.hidden = YES;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *ID;
    //当前评论
    LGComment *comment = self.comments[indexPath.row];
    //父评论
    LGComment *parentCommt;
    //判断当前是否存在父评论
    ID = [comment.parent integerValue] > 0 ? replyCellID:cellID;
    NSUInteger index = 0;
    if (comment.parent.length > 0 && [comment.parent integerValue] > 0) {
        //存在父评论从当前数组重寻找父评论
        for (LGComment *subComment in self.comments) {
            if ([subComment.ID isEqualToString:comment.parent]) {
                 index = [self.comments indexOfObject:subComment];
            }
        }
        //得到父评论
        parentCommt = self.comments[index];
        
       
        
    }
     LGCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    //传递当前评论和父评论
    [cell comment:comment parentComment:parentCommt];
   
    
    return cell;
    
    
}
//计算行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LGComment *comment = self.comments[indexPath.row];
    NSUInteger index = 0;
    //CGFloat parentHeight = 0;
     LGComment *parentCommt;
    //判断是否有父评论
    if (comment.parent.length > 0 && [comment.parent integerValue] > 0) {
        for (LGComment *subComment in self.comments) {
            if ([subComment.ID isEqualToString:comment.parent]) {
                //拿到父评论的索引
                index = [self.comments indexOfObject:subComment];
               
                //parentHeight = comment.replyHeght;
            }
        }
        //根据索引拿到父评论
        parentCommt = self.comments[index];
    }
    //返回计算的行高
    return comment.rowHeght + parentCommt.replyHeght;
}
//点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LGComment *comment = self.comments[indexPath.row];
    self.commentSendButton.tag = [comment.ID integerValue];
    self.commentTextField.placeholder = [NSString stringWithFormat:@"回复%@",comment.name];
    
    [self.commentTextField becomeFirstResponder];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [self.commentTextField resignFirstResponder];
    self.commentSendButton.tag = 0;
    self.commentTextField.placeholder = @"我来说两句";
}
//显示组标题，显示有无评论
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //从循环池中出去HeaderFooterView
    UITableViewHeaderFooterView *hfView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:commentHFViewID];
    //创建一个view
    UIView *view = [[UIView alloc] init];
    //计算view的frame
    view.frame = CGRectMake(LGCommonSmallMargin,  LGCommonMargin, self.tableView.lg_width - 2 * LGCommonSmallMargin, 40 -1);
    view.backgroundColor = [UIColor whiteColor];
    //创建一个用来显示文字的lable
    UILabel *titleLable = [[UILabel alloc] init];
    titleLable.backgroundColor = [UIColor whiteColor];
    titleLable.font = [UIFont systemFontOfSize:13];
    titleLable.textColor = [UIColor lightGrayColor];
    titleLable.frame = CGRectMake(2 * LGCommonMargin,  0, view.lg_width/2, view.lg_height);
    //对当前评论进行判断是否有无
    if ([self.model.comment_count integerValue] <=  0 && !self.comments.count) {
        titleLable.text = @"暂无评论";
    }else{
        titleLable.text = @"最新评论";
    }
    [view addSubview:titleLable];
    [hfView addSubview:view];
    return hfView;

    
    
}



@end
