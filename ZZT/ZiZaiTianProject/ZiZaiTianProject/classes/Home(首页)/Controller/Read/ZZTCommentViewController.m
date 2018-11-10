//
//  ZZTCommentViewController.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/11/5.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTCommentViewController.h"
#import "ZZTNavBarTitleView.h"

#import "ZZTNewestCommentView.h"
#import "ZZTCircleModel.h"
#import "customer.h"
#import "ZZTUserReplyModel.h"

@interface ZZTCommentViewController ()<UITextViewDelegate,ZZTNewestCommentViewDelegate>

@property (nonatomic,strong) ZXDNavBar *navbar;

@property (nonatomic,weak) UIScrollView *mainView;

@property (nonatomic, strong) UIView *kInputView;

@property (nonatomic, strong) UITextView *kTextView;

@property (nonatomic,strong) UIButton *publishBtn;

@property (nonatomic,strong) UIButton *kLikeBtn;

@property (nonatomic,strong) UITableView *nowTableView;

@property (nonatomic,strong) ZZTNewestCommentView *newestVC;

@property (nonatomic,strong) ZZTNewestCommentView *hotestVC;

@property (nonatomic, assign) CGFloat kInputHeight;
//判断恢复状态
@property (nonatomic,assign) BOOL isReply;

@property (nonatomic,strong) NSString *commentId;
//判断是评论还是回复
@property (nonatomic,strong) NSString *isCommentOrReply;

//当前回复
@property (nonatomic,strong) ZZTCircleModel *nowReplyModel;
//回复人（cell上的）
@property (nonatomic,strong) customer *replyer;

@end

@implementation ZZTCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNavigationBar];
    
    //加入中间一个swich
    
    //设置滚动两页
    [self setupMainView];
    
    [self addInputView];

    self.kInputHeight = 50;

    //初始化 没有对人回复
    self.isReply = NO;
}

-(void)setupMainView{
    CGFloat mainViewHeight = self.view.height - navHeight;
    
    UIScrollView *mainView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,navHeight, self.view.width,mainViewHeight)];
    mainView.scrollEnabled = NO;
    mainView.contentSize   = CGSizeMake(mainView.width * 2, 0);
    mainView.pagingEnabled = YES;
    mainView.showsHorizontalScrollIndicator = NO;
    mainView.showsVerticalScrollIndicator = NO;
    
    [mainView setContentOffset:CGPointMake(0, 0)];
    
    self.mainView = mainView;
    
    //2个子页
    ZZTNewestCommentView *newestVC = [[ZZTNewestCommentView alloc] initWithFrame:CGRectMake(0, 0, mainView.width, mainView.height - 50)];
    newestVC.chapterId = self.chapterId;//章节id
    newestVC.dataNum = 1;//最新 最热
    newestVC.backgroundColor = [UIColor whiteColor];
    newestVC.adelegate = self;
    self.nowTableView = newestVC;
    _newestVC = newestVC;
    
    ZZTNewestCommentView *hotestVC = [[ZZTNewestCommentView alloc] initWithFrame:CGRectMake(mainView.width, 0, mainView.width, mainView.height - 50)];
    hotestVC.chapterId = self.chapterId;
    hotestVC.dataNum = 2;
    _hotestVC = hotestVC;
    hotestVC.backgroundColor = [UIColor whiteColor];

    [mainView addSubview:newestVC];
    [mainView addSubview:hotestVC];
    [self.view addSubview:mainView];
}

-(void)commentView:(UITableView *)tableView sendReply:(ZZTCircleModel *)model{
    
    self.commentId = model.id;
    
    self.isReply = YES;

    self.isCommentOrReply = @"1";

    self.nowReplyModel = model;
    
    UserInfo *user = [Utilities GetNSUserDefaults];
    
    if([model.customer.id isEqualToString:[NSString stringWithFormat:@"%ld",user.id]]){
        model.customer.id = @"0";
    }
    
    self.replyer = model.customer;
    
    //弹出键盘
    [self startComment];
}

-(void)commentView:(UITableView *)tableView sendCellReply:(ZZTCircleModel *)model indexRow:(NSInteger)indexRow{
    //第几条回复
    ZZTUserReplyModel *item = model.replyComment[indexRow];
    //回复人
    customer *replyer = item.replyCustomer;
    
    UserInfo *user = [Utilities GetNSUserDefaults];
    //点击自己的回复
    if([replyer.id isEqualToString:[NSString stringWithFormat:@"%ld",user.id]]){
        
        //删除
        [self deleteReplyActionView:@"2" comentId:item.id];
        
    }else{
        self.replyer = replyer;
        self.commentId = item.id;
        self.nowReplyModel = model;
        self.isCommentOrReply = @"2";
        
        self.isReply = YES;
        //设置输入回复信息
        [self startComment];
    }
}

-(void)deleteReplyActionView:(NSString *)type comentId:(NSString *)commentId{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"是否删除回复" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //发送删除请求
        [self deleteReplyWithType:type commentId:commentId];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了取消");
    }];
    
    [actionSheet addAction:action1];
    [actionSheet addAction:action2];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}

-(void)deleteReplyWithType:(NSString *)type commentId:(NSString *)commentId{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *dict = @{
                           @"type":type,//节是1 cell是2
                           @"commentId":commentId
                           };
    [manager POST:[ZZTAPI stringByAppendingString:@"circle/deleteComment"] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self sendSuccess];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(void)setupNavigationBar{
    
    ZZTNavBarTitleView *titleView = [[ZZTNavBarTitleView alloc] init];
    
    //样式
    titleView.selBtnTextColor = [UIColor whiteColor];
    titleView.selBtnBackgroundColor = [UIColor orangeColor];
    titleView.btnTextColor = [UIColor blackColor];
    titleView.btnBackgroundColor = [UIColor whiteColor];
    
    weakself(self);
    [titleView.leftBtn setTitle:@"最新" forState:UIControlStateNormal];
    [titleView.rightBtn setTitle:@"最热" forState:UIControlStateNormal];
    
    titleView.leftBtnOnClick = ^(UIButton *btn){
        [weakSelf.mainView setContentOffset:CGPointZero animated:YES];
        weakSelf.nowTableView = weakSelf.newestVC;
        [weakSelf.newestVC beginHeaderUpdate];
    };
    
    titleView.rightBtnOnClick = ^(UIButton *btn){
        [weakSelf.mainView setContentOffset:CGPointMake(self.mainView.width, 0) animated:YES];
        weakSelf.nowTableView = weakSelf.hotestVC;
        [weakSelf.hotestVC beginHeaderUpdate];
    };
    
    //nav
    ZXDNavBar *navbar = [[ZXDNavBar alloc]init];
    self.navbar = navbar;
    navbar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navbar];
    
    [self.navbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.equalTo(@(navHeight));
    }];
    
    //返回
    [navbar.leftButton setImage:[UIImage imageNamed:@"navigationbar_close"] forState:UIControlStateNormal];
    navbar.leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 17);
    [navbar.leftButton addTarget:self action:@selector(dismissVC) forControlEvents:UIControlEventTouchUpInside];
    
    //中间
    [navbar.mainView addSubview:titleView];
    
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(navbar.mainView);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.42);
        make.height.mas_equalTo(30);
        make.bottom.equalTo(navbar.mainView).offset(-10);
    }];

    navbar.showBottomLabel = YES;
}
-(void)dismissVC{
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)addInputView {
    //创建输入View
    self.kInputView = [UIView new];
    _kInputView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    [self.view addSubview:self.kInputView];
    
    [_kInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@50);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(@(0));
    }];
    //输入View
    self.kTextView = [UITextView new];
    _kTextView.backgroundColor = [UIColor whiteColor];
    _kTextView.layer.cornerRadius = 5;
    _kTextView.text = @"请输入评论";
    _kTextView.textColor = [UIColor grayColor];
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = 5;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:16], NSParagraphStyleAttributeName:paragraphStyle
                                 };
    _kTextView.typingAttributes = attributes;
    _kTextView.returnKeyType = UIReturnKeySend;
    _kTextView.delegate = self;
    [_kInputView addSubview:_kTextView];
    [_kTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@7);
        make.bottom.equalTo(@(-7));
        make.left.equalTo(@14);
        make.right.equalTo(@(-90));
    }];
    
    //发布按钮
    UIButton *publishBtn = [[UIButton alloc] init];
    [publishBtn setTitle:@"发布" forState:UIControlStateNormal];
    [publishBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_kInputView addSubview:publishBtn];
    [publishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@7);
        make.bottom.equalTo(@(-7));
        make.left.equalTo(self.kTextView.mas_right).offset(4);
        make.width.mas_equalTo(50);
    }];
    _publishBtn = publishBtn;
    [publishBtn addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    
    //改
    //点赞按钮
    UIButton *kLikeBtn = [[UIButton alloc] init];
    [kLikeBtn setImage:[UIImage imageNamed:@"正文-点赞-已点赞"] forState:UIControlStateNormal];
    [_kInputView addSubview:kLikeBtn];
    [kLikeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.bottom.equalTo(@-10);
        make.left.equalTo(self.publishBtn.mas_right).offset(4);
        make.width.mas_equalTo(30);
    }];
//    [kLikeBtn addTarget:self action:@selector(likeBtnTaget) forControlEvents:UIControlEventTouchUpInside];
    self.kLikeBtn = kLikeBtn;
}

-(void)sendMessage{
    if (_kTextView.text.length == 0 || [_kTextView.text isEqualToString:@"请输入评论"]) {
        [MBProgressHUD showError:@"请输入评论再发布"];
        return;
    }

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    UserInfo *user = [Utilities GetNSUserDefaults];
    
    if(self.isReply){
        NSDictionary *dict = @{
                               @"userId":[NSString stringWithFormat:@"%ld",user.id],
                               @"toUser":self.replyer.id,
                               @"commentId":self.nowReplyModel.id,//节id
                               @"replyId":self.commentId,//回复id
                               @"replyType":self.isCommentOrReply,
                               @"content":self.kTextView.text
                               };
        [manager POST:[ZZTAPI stringByAppendingString:@"cartoon/insertReply"] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            self.commentId = @"0";
            [self sendSuccess];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        }];
    }else{
        [MBProgressHUD showMessage:@"正在发布..." toView:self.view];
        NSDictionary *dic = @{
                              @"userId":[NSString stringWithFormat:@"%ld",user.id],
                              @"chapterId":self.chapterId,
                              @"type":self.cartoonType,
                              @"content":self.kTextView.text
                              };
        [manager POST:[ZZTAPI stringByAppendingString:@"cartoon/insertComment"] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self sendSuccess];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
}

-(void)longPressDeleteComment:(ZZTCircleModel *)circleItem{
    UserInfo *user = [Utilities GetNSUserDefaults];
    if([circleItem.customer.id isEqualToString:[NSString stringWithFormat:@"%ld",user.id]]){
        [self deleteReplyActionView:@"1" comentId:circleItem.id];
    }
}

-(void)sendSuccess{
    ZZTNewestCommentView *newestView = (ZZTNewestCommentView *)self.nowTableView;
    [newestView update];
    
    [self.kInputView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@50);
    }];
    
    [self.kTextView setText:@""];
    
    self.kInputHeight = 50;
    
    [self hideKeyBoard];
}

-(void)hideKeyBoard{
    [self.kTextView resignFirstResponder];
}

- (void)startComment {
    [self.kTextView becomeFirstResponder];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 5000) { // 限制5000字内
        textView.text = [textView.text substringToIndex:5000];
    }
    static CGFloat maxHeight = 36 + 24 * 2;//初始高度为36，每增加一行，高度增加24
    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    if (size.height >= maxHeight) {
        size.height = maxHeight;
        textView.scrollEnabled = YES;   // 允许滚动
    } else {
        textView.scrollEnabled = NO;    // 不允许滚动
    }
    
    if ((ceil(size.height) + 14) != self.kInputHeight) {
        CGPoint offset = self.nowTableView.contentOffset;
        CGFloat delta = ceil(size.height) + 14 - self.kInputHeight;
        offset.y += delta;
        if (offset.y < 0) {
            offset.y = 0;
        }
        [self.nowTableView setContentOffset:offset animated:NO];
        self.kInputHeight = ceil(size.height) + 14;
        [self.kInputView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(ceil(size.height) + 14));
        }];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        //大于0 才能发送信息
        if (self.kTextView.text.length > 0) {     // send Text
            //            [self sendMessage:self.kTextView.text];
        }
        [self.kInputView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@50);
        }];
        [self.kTextView setText:@""];
        self.kInputHeight = 50;
        return NO;
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    if([textView.text isEqualToString:@"请输入评论"]){
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    if(self.isReply == NO){
        self.commentId = @"0";
    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView {
    self.isReply = NO;
    if(textView.text.length < 1){
        textView.text = @"请输入评论";
        textView.textColor = [UIColor grayColor];
    }
}

-(void)setChapterId:(NSString *)chapterId{
    _chapterId = chapterId;
}

-(void)setCartoonType:(NSString *)cartoonType{
    _cartoonType = cartoonType;
}

@end
