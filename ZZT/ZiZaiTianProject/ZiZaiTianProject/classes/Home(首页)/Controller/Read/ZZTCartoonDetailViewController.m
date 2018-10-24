//
//  ZZTCartoonDetailViewController.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/8/23.
//  Copyright © 2018年 zxd. All rights reserved.
//
#import "ZZTCartoonDetailViewController.h"
#import "ZZTCartoonContentCell.h"
#import "ZZTCartoonModel.h"
#import "ZZTAuthorHeadView.h"
#import "ZZTContinueToDrawHeadView.h"
#import "ZZTCommentHeadView.h"
#import "ZZTCommentCell.h"
#import "ZZTCircleModel.h"
#import "ZZTStoryDetailCell.h"
#import "ZZTStoryModel.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "ZZTJiXuYueDuModel.h"
#import "ZZTCreationCartoonTypeViewController.h"
#import "ZZTChapterlistModel.h"
#import "ZZTCarttonDetailModel.h"
#include <sys/time.h>
#import "CircleCell.h"
#import "ZZTUserReplyModel.h"
#import "FriendCircleViewModel.h"
#import "ZZTChapterModel.h"
#import "ZZTNextWordHeaderView.h"
#import "UITableView+ZFTableViewSnapshot.h"


@interface ZZTCartoonDetailViewController ()<UITableViewDelegate,UITableViewDataSource,CircleCellDelegate,ZZTCommentHeaderViewDelegate,UITextViewDelegate,NSURLSessionDataDelegate,ZZTCartoonContentCellDelegate>

@property (nonatomic,strong) NSMutableArray *cartoonDetailArray;

@property (nonatomic,strong) NSArray *commentArray;

@property (nonatomic,strong) NSArray *userLikeArray;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,assign) BOOL isNavHide;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,assign) BOOL isOnce;

@property (nonatomic,assign) BOOL isJXYD;

@property (nonatomic,strong) ZZTJiXuYueDuModel *model;

@property (nonatomic,strong) UserInfo *author;
//剧本
@property (nonatomic,strong) ZZTStoryModel *stroyModel;

@property (nonatomic,assign) CGPoint readPoint;

@property (nonatomic, assign) CGFloat kInputHeight;

@property (nonatomic, strong) UIView *kInputView;

@property (nonatomic, strong) UITextView *kTextView;

@property (nonatomic, assign) NSInteger selectedSection;

@property (nonatomic, strong) NSDictionary *toPeople;

@property (nonatomic, strong) IQKeyboardManager *keyboardManager;

@property (nonatomic,strong) NSMutableArray *imageCellHeightCache;

@property (nonatomic,strong) ZXDNavBar *navbar;

@property (nonatomic,strong) ZZTChapterModel *chapterModel;

@property (nonatomic,strong) NSMutableArray *headerMuArr;

@property (nonatomic,strong) NSString *commentId;

@property (nonatomic,strong) UIButton *publishBtn;

//判断恢复状态
@property (nonatomic,assign) BOOL isReply;
//回复者ID(节上的)
@property (nonatomic,strong) NSString *replyId;

@property (nonatomic,assign) NSInteger replySection;
//回复人（cell上的）
@property (nonatomic,strong) customer *replyer;

@property (nonatomic,strong) dispatch_group_t group;

@property (nonatomic,assign) dispatch_queue_t q;
//点赞模型
@property (nonatomic,strong) ZZTStoryModel *likeModel;
//上一章下一章视图
@property (nonatomic,strong) ZZTNextWordHeaderView *nextWordView;
//电池条
@property (nonatomic,strong) UIView *statusBar;

@property (nonatomic,strong) UIButton *kLikeBtn;

@end

NSString *CartoonContentCellIdentifier = @"CartoonContentCellIdentifier";

NSString *Comment = @"Comment";

NSString *story = @"story";

NSString *storyDe = @"storyDe";

static NSString *const kCellId = @"CircleCell";

static const CGFloat imageCellHeight = 500.0f;

static bool needHide = false;

@implementation ZZTCartoonDetailViewController

-(dispatch_group_t)group{
    if(!_group){
        _group = dispatch_group_create();
    }
    return _group;
}

-(dispatch_queue_t)q{
    if(!_q){
        _q = dispatch_get_global_queue(0, 0);
    }
    return _q;
}
#pragma mark Lazy load
-(ZZTChapterModel *)chapterModel{
    if(!_chapterModel){
        _chapterModel = [[ZZTChapterModel alloc] init];
    }
    return _chapterModel;
}

-(customer *)replyer{
    if(!_replyer){
        _replyer = [[customer alloc] init];
    }
    return _replyer;
}

- (NSMutableArray *)imageCellHeightCache {
    if (!_imageCellHeightCache && self.cartoonDetailArray) {
        
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        
        for (NSInteger index = 0; index < self.cartoonDetailArray.count; index++) {
            [arr addObject:@(imageCellHeight)];
        }
        _imageCellHeightCache = arr;
    }
    return _imageCellHeightCache;
}

-(ZZTStoryModel *)stroyModel{
    if(!_stroyModel){
        _stroyModel = [[ZZTStoryModel alloc] init];
    }
    return _stroyModel;
}

-(UserInfo *)author{
    if(!_author){
        _author = [[UserInfo alloc] init];
    }
    return _author;
}

-(NSArray *)userLikeArray{
    if (!_userLikeArray) {
        _userLikeArray = [NSArray array];
    }
    return _userLikeArray;
}

-(NSMutableArray *)cartoonDetailArray{
    if (!_cartoonDetailArray) {
        _cartoonDetailArray = [NSMutableArray array];
    }
    return _cartoonDetailArray;
}

-(NSArray *)commentArray{
    if (!_commentArray) {
        _commentArray = [NSArray array];
    }
    return _commentArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //内容页
    [self setupContentView];
    //自定义导航栏
    [self setupNavigationBar];

    self.commentId = @"0";
    
    self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //显示
    self.isNavHide = NO;
    
#warning 待改
    [self setupTitleView];
    
    self.isOnce = NO;
    if(self.model){
        self.isOnce = YES;
    }
    
    [self loadData];
    
    //键盘输入框
    [self addInputView];
    
    self.kInputHeight = 50;
    
    //初始化 没有人回复
    self.isReply = NO;
    
    UIImage *image = [self generateSnapshot];
}

-(void)setupNavigationBar{
    ZXDNavBar *navbar = [[ZXDNavBar alloc]init];
    self.navbar = navbar;
//    navbar.backgroundColor = [UIColor blackColor];
    [navbar setBackgroundColor:[UIColor colorWithRed:0.0 green:0 blue:0 alpha:0.5]];
    //    navbar.mainView.backgroundColor = [UIColor blackColor];
//    [navbar.mainView.backgroundColor colorWithAlphaComponent:0.5];
//    navbar.mainView.alpha = 0.5;
    [self.view addSubview:navbar];
    
    [self.navbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.equalTo(@(navHeight));
    }];
    
    //返回
    [navbar.leftButton setImage:[UIImage imageNamed:@"navigationbarBack"] forState:UIControlStateNormal];
    navbar.leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 17);
    
    //中间
    [navbar.centerButton setTitle:self.dataModel.chapterName forState:UIControlStateNormal];
    [navbar.centerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [navbar.mainView setBackgroundColor:[UIColor colorWithRGB:@"121,105,212"]];
    
    [navbar.rightButton setTitle:@"分享" forState:UIControlStateNormal];
    [navbar.rightButton addTarget:self action:@selector(shareWithSharePanel) forControlEvents:UIControlEventTouchUpInside];
    navbar.showBottomLabel = NO;
}


-(void)setupContentView{
    //先把漫画显示出来
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.contentInset = UIEdgeInsetsMake(0,0,50,0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.tableFooterView = [UIView new];
    [tableView registerClass:[ZZTCartoonContentCell class] forCellReuseIdentifier:CartoonContentCellIdentifier];
    tableView.showsVerticalScrollIndicator = YES;
    _tableView = tableView;
    [self.view addSubview:tableView];
    
    [self loadViewIfNeeded];

    tableView.pagingEnabled = NO;
    //评论
    //注册cell
    [self.tableView registerClass:[CircleCell class] forCellReuseIdentifier:kCellId];
    [self.tableView registerClass:[ZZTStoryDetailCell class] forCellReuseIdentifier:story];
    
    self.tableView.tableFooterView = [UIView new];
}
//取消多余字符
- (NSString *)getZZwithString:(NSString *)string{
    
    NSRegularExpression *regularExpretion = [NSRegularExpression regularExpressionWithPattern:@"<[^>]*>|\n" options:0 error:nil];
    
    string = [regularExpretion stringByReplacingMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length) withTemplate:@""];
    
    return string;
}

- (void)addInputView {
    //创建底部View
    self.kInputView = [UIView new];
    _kInputView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    
    [self.view addSubview:self.kInputView];
    
    [_kInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@50);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(@(0));
    }];

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
    [kLikeBtn addTarget:self action:@selector(likeBtnTaget) forControlEvents:UIControlEventTouchUpInside];
    self.kLikeBtn = kLikeBtn;
}

-(void)likeBtnTaget{
    [MBProgressHUD showSuccess:@"点赞成功" toView:self.view];
    dispatch_group_async(self.group, self.q, ^{
        dispatch_group_enter(self.group);
        [self headerViewLike];
    });

    //点赞完了以后 重新请求一次获取点赞的接口  刷新点赞图标
    dispatch_group_async(self.group, self.q, ^{
        dispatch_group_enter(self.group);
        [self loadLikeData];
    });
    
    dispatch_group_notify(self.group, dispatch_get_main_queue(), ^{
//        [self.tableView reloadData];
       
//        [self reloadCellWithIndex];
    });
}

-(void)loadData{
    [self loadContent];
}

#pragma mark - navigationItem
- (void)setupTitleView{
    UIView *textView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH * 0.8, 40)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:textView.frame];
    
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:18];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = self.cartoonModel.bookName;
    label.textColor = [UIColor whiteColor];
    [textView addSubview:label];
    
    self.titleLabel = label;
    
    self.navigationItem.titleView = textView;
}

#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(self.commentArray.count > 0){
        return self.commentArray.count + 2;
    }else{
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return self.cartoonDetailArray.count;
    }else if (section == 1){
        return 0;
    }else{
        if(self.commentArray.count > 0){
            ZZTCircleModel *model = self.commentArray[section - 2];
            return model.replyComment.count;
        }else{
            return 0;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        //漫画   是这里的数据
        if([self.cartoonModel.type isEqualToString:@"1"]){
            ZZTCartoonContentCell *cell = [tableView dequeueReusableCellWithIdentifier:CartoonContentCellIdentifier];
            cell.delegate = self;
            ZZTCartoonModel *model = self.cartoonDetailArray[indexPath.row];
            model.index = indexPath.row;
            cell.model = model;
            return cell;
        }else{
            ZZTStoryDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:story];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            ZZTStoryModel *model = self.cartoonDetailArray[indexPath.row];
            cell.str = model.content;
            NSLog(@"model.content:%@",model.content)
            return cell;
        }
    }else{
        ZZTCircleModel *model = self.commentArray[indexPath.section - 2];
        CircleCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId forIndexPath:indexPath];
        [cell setContentData:model index:indexPath.row];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        if([self.cartoonModel.type isEqualToString:@"1"]){
            return [self.imageCellHeightCache[indexPath.row] doubleValue];
        }else{
            ZZTStoryModel *model = self.cartoonDetailArray[indexPath.row];
            if(model.content.length > 300){
                return [self calculateStringHeight:model.content];
            }else{
                return 0;
            }
        }
    }else{
        return UITableViewAutomaticDimension;
    }
}

- (CGFloat)calculateStringHeight:(NSString *)text {
    return ceil([text contentSizeWithWidth:Screen_Width - 20 font:[UIFont systemFontOfSize:SectionHeaderBigFontSize] lineSpacing:0].height);
}

-(void)loadContent{
    
    dispatch_group_async(self.group, self.q, ^{
        dispatch_group_enter(self.group);
        [self loadContentData];
    });

    dispatch_group_async(self.group, self.q, ^{
        dispatch_group_enter(self.group);
        [self loadCommentData];
    });
    
    dispatch_group_async(self.group, self.q, ^{
        dispatch_group_enter(self.group);
        [self loadLikeData];
    });
    
    dispatch_group_notify(self.group, dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self reloadCellWithIndex];
        UIImage *image = [self generateSnapshot];
    });
    
}

//把请求单独的抽出来
-(void)loadContentData{
    UserInfo *user = [Utilities GetNSUserDefaults];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    
    if([self.cartoonModel.type isEqualToString:@"1"]){
        NSDictionary *paramDict = @{
                                   @"id":[NSString stringWithFormat:@"%ld",_dataModel.id],
                                   @"pageNum":@"0",
                                   @"pageSize":@"200"
                                   };
        [manager POST:[ZZTAPI stringByAppendingString:@"cartoon/getCartoonCenter"] parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self.cartoonDetailArray removeAllObjects];
            self.imageCellHeightCache = nil;
            
            NSArray *dataArray = [[EncryptionTools sharedEncryptionTools] getDecryArray:responseObject[@"result"]];
            if(dataArray.count > 0){
                NSMutableArray *array = [ZZTCartoonModel mj_objectArrayWithKeyValuesArray:dataArray[0]];
                UserInfo *author = [UserInfo mj_objectWithKeyValues:dataArray[1]];
                    self.cartoonDetailArray = array;
                    self.author = author;
            }
            dispatch_group_leave(self.group);
            [MBProgressHUD hideHUDForView:self.view];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            dispatch_group_leave(self.group);
//            [MBProgressHUD hideHUDForView:self.view];
        }];
    }else{
        //章节
        NSDictionary *paramDict = @{
                                    @"chapterinfoId":[NSString stringWithFormat:@"%ld",_dataModel.id],
                                    @"userId":[NSString stringWithFormat:@"%ld",user.id]
                                    };
        [manager POST:[ZZTAPI stringByAppendingString:@"cartoon/getChapterInfo"] parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            self.cartoonDetailArray = nil;
            NSString *data = responseObject[@"result"];
            NSDictionary *dic = [[EncryptionTools sharedEncryptionTools] decry:data];
            NSMutableArray *array = [ZZTStoryModel mj_objectArrayWithKeyValuesArray:dic];
            self.cartoonDetailArray = array;
            if(array.count > 0) {
                ZZTStoryModel *model = array[0];
                self.stroyModel = model;
                //下载txt
                [self downLoadTxt:model.content];
            }
            dispatch_group_leave(self.group);
//            [MBProgressHUD hideHUDForView:self.view];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            dispatch_group_leave(self.group);
//            [MBProgressHUD hideHUDForView:self.view];
        }];
    }
}

-(void)loadLikeData{
    UserInfo *user = [Utilities GetNSUserDefaults];
    AFHTTPSessionManager *session = [[AFHTTPSessionManager alloc] init];
    NSDictionary *likeDict = @{
                               @"chapterId":self.dataModel.chapterId,
                               @"userId":[NSString stringWithFormat:@"%ld",user.id]
//                               @"userId":@"1"
                               };
    [session POST:[ZZTAPI stringByAppendingString:@"cartoon/getChapterPraise"] parameters:likeDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [[EncryptionTools sharedEncryptionTools] decry:responseObject[@"result"]];
        ZZTStoryModel *model = [ZZTStoryModel mj_objectWithKeyValues:dic];
        self.nextWordView.likeModel = model;
        if([model.ifpraise isEqualToString:@"0"]){
            [self.kLikeBtn setImage:[UIImage imageNamed:@"正文-点赞-未点赞(灰色）"] forState:UIControlStateNormal];
        }else{
            [self.kLikeBtn setImage:[UIImage imageNamed:@"正文-点赞-已点赞"] forState:UIControlStateNormal];
        }
        NSLog(@"%@",dic);
        dispatch_group_leave(self.group);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_group_leave(self.group);
    }];
}

-(void)loadCommentData{
    UserInfo *user = [Utilities GetNSUserDefaults];
    AFHTTPSessionManager *session = [[AFHTTPSessionManager alloc] init];
    NSDictionary *commentDict = @{
                                  @"itemId":[NSString stringWithFormat:@"%ld",self.dataModel.id],
                                  @"type":self.cartoonModel.type,
                                  @"pageNum":@"0",
                                  @"pageSize":@"100",
                                  @"userId":[NSString stringWithFormat:@"%ld",user.id]
                                  };
    [session POST:[ZZTAPI stringByAppendingString:@"cartoon/cartoonComment"] parameters:commentDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.commentArray = nil;
        NSDictionary *commenDdic = [[EncryptionTools sharedEncryptionTools] decry:responseObject[@"result"]];
        //这里有问题 应该是转成数组 然后把对象取出
        NSMutableArray *array1 = [ZZTCircleModel mj_objectArrayWithKeyValuesArray:commenDdic];
        //外面的数据
        FriendCircleViewModel *circleViewModel = [[FriendCircleViewModel alloc] init];
        circleViewModel.circleModelArray = array1;
        self.commentArray = [circleViewModel loadDatas];
        
        //加工一下评论的数据
//        self.commentArray = array1;
//        [self.tableView reloadData];
        dispatch_group_leave(self.group);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_group_leave(self.group);//很重要,不能少
    }];
}

-(void)loadAuthorData{
    if(![self.cartoonModel.type isEqualToString:@"1"]){
        UserInfo *user = [[UserInfo alloc] init];
        user.headimg = self.stroyModel.headimg;
        user.nickName = self.stroyModel.nickName;
        user.id = self.stroyModel.id;
        user.userId = self.stroyModel.userId;
        self.author = user;
//        [self.tableView reloadData];
        //        [self reloadCellWithIndex];
        dispatch_group_leave(self.group);
        return;
    }
    //        dispatch_semaphore_t  sema = dispatch_semaphore_create(0);
    //头像
    NSDictionary *headDict = @{
                               @"id":[NSString stringWithFormat:@"%ld",_dataModel.id],
                               @"pageNum":@"",
                               @"pageSize":@""
                               };
    //    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    [manager POST:[ZZTAPI stringByAppendingString:@"cartoon/getCartoonCenter"] parameters:headDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [[EncryptionTools sharedEncryptionTools] decry:responseObject[@"result"]];
        NSArray *array = [UserInfo mj_objectArrayWithKeyValuesArray:dic];
//        if(array.count != 0){
//            UserInfo *author = array[1];
//            self.author = author;
//        }
//        [self.tableView reloadData];
        //        [self reloadCellWithIndex];
        dispatch_group_leave(self.group);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_group_leave(self.group);
    }];
}

//下载txt
-(void)downLoadTxt:(NSString *)txtUrl{
    NSError *error;
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);

    NSString *htmlString = [NSString stringWithContentsOfURL:[NSURL URLWithString:txtUrl] encoding:enc error:&error];
    if(!error){
        htmlString = [self getZZwithString:htmlString];
        self.stroyModel.content = htmlString;
//        [self.tableView reloadData];
        [self.tableView layoutIfNeeded];
        [self reloadCellWithIndex];
    }else{
        NSLog(@"error:%@",error);
    }
}

//json字符串转化成OC键值对
- (id)jsonStringToKeyValues:(NSString *)JSONString {
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = nil;
    if (JSONData) {
        responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableContainers error:nil];
    }
    return responseJSON;
}

//-(void)loadCommentData{
//    UserInfo *user = [Utilities GetNSUserDefaults];
//
//    //评论UITableViewAutomaticDimension
//    NSDictionary *commentDict = @{
//                                  @"itemId":[NSString stringWithFormat:@"%ld",_dataModel.id],
//                                  @"type":self.cartoonModel.type,
//                                  @"pageNum":@"0",
//                                  @"pageSize":@"100",
//                                  @"userId":[NSString stringWithFormat:@"%ld",user.id]
//                                  };
//
//    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
//    [manager POST:[ZZTAPI stringByAppendingString:@"cartoon/cartoonComment"] parameters:commentDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//        NSDictionary *commenDdic = [[EncryptionTools sharedEncryptionTools] decry:responseObject[@"result"]];
//        //这里有问题 应该是转成数组 然后把对象取出
//        NSMutableArray *array1 = [ZZTCircleModel mj_objectArrayWithKeyValuesArray:commenDdic];
//        //外面的数据
//        FriendCircleViewModel *circleViewModel = [[FriendCircleViewModel alloc] init];
//        circleViewModel.circleModelArray = array1;
//        self.commentArray = [circleViewModel loadDatas];
//
//        //加工一下评论的数据
//        self.commentArray = array1;
//        dispatch_group_leave(self.group);
////        [self loadLikeData];
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        dispatch_group_leave(self.group);
//    }];
//}

//-(void)loadLikeData{
//    //点赞人
//    NSDictionary *likeDict = @{
//                               @"cartoonId":_cartoonModel.id,//书
//                               @"chapterId":[NSString stringWithFormat:@"%ld",_dataModel.id]
//                               };
////    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
//    [manager POST:[ZZTAPI stringByAppendingString:@"cartoon/listChapterinfo"] parameters:likeDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//        NSDictionary *likeDic = [[EncryptionTools sharedEncryptionTools] decry:responseObject[@"result"]];
//        //这里有问题 应该是转成数组 然后把对象取出
//        NSArray *array2 = [ZZTChapterlistModel mj_objectArrayWithKeyValuesArray:likeDic];
//        NSLog(@"likeDic:%@",likeDic);
//        self.userLikeArray = array2;
//        dispatch_group_leave(self.group);
////        [self.tableView reloadData];
////        [self loadAuthorHead];
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//         dispatch_group_leave(self.group);
//    }];
//}

//需要传1 或者2
-(void)setDataModel:(ZZTChapterlistModel *)dataModel{
    _dataModel = dataModel; // 你的问题在哪里  是没有数据还是数据错乱
}

-(void)setCartoonModel:(ZZTCarttonDetailModel *)cartoonModel{
    _cartoonModel = cartoonModel;
}

//请求数据后显示那一行
-(void)reloadCellWithIndex{
    if(self.isJXYD){
        dispatch_async(dispatch_get_main_queue(), ^{

            [self.tableView layoutIfNeeded];

            CGFloat y = self.chapterModel.readPoint.y;
        
            [self.tableView setContentOffset:CGPointMake(0 , y)];
        });
    }
}

#pragma mark UITableViewDataSource 头高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 0){
        return 100;
    }else if(section == 1)
    {
        return 60;
    }else{
        if(self.commentArray.count > 0){
            ZZTCircleModel *item = self.commentArray[section - 2];
            return item.headerHeight;
        }
        return 0;
    }
}

//添加头 ZZTCartoonDetailFoot
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSLog(@"section%ld",section);
    if(section == 0){
        //作者 上数据
        ZZTAuthorHeadView *authorHead = [ZZTAuthorHeadView AuthorHeadView];
        authorHead.userModel = self.author;
        return authorHead;
    }else if(section == 1){
        static NSString *nextWordViewIdentfier = @"nextWordView";
        ZZTNextWordHeaderView *nextWordView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:nextWordViewIdentfier];
        [nextWordView.rightBtn addTarget:self action:@selector(nextWordWithBtn:) forControlEvents:UIControlEventTouchUpInside];
        [nextWordView.rightBtn setTag:2];
        [nextWordView.liftBtn addTarget:self action:@selector(nextWordWithBtn:) forControlEvents:UIControlEventTouchUpInside];
        [nextWordView.liftBtn setTag:1];
        nextWordView.block = ^{
            [self headerViewLike];
        };
        //如果没有头视图
        if(!nextWordView){
            nextWordView = [[ZZTNextWordHeaderView alloc] initWithReuseIdentifier:nextWordViewIdentfier];
        }
        self.nextWordView = nextWordView;
        nextWordView.backgroundColor = [UIColor whiteColor];
        return nextWordView;
    }else{
        static NSString *viewIdentfier = @"headView";
        ZZTCommentHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:viewIdentfier];
        //如果没有头视图
        if(!headerView){
            headerView = [[ZZTCommentHeaderView alloc] initWithReuseIdentifier:viewIdentfier];
        }
        headerView.delegate = self;
        ZZTCircleModel *model = self.commentArray[section - 2];
        [headerView setContentData:model section:section - 2];
        return headerView;
    }
}

#pragma mark - ZZTNextWordHeaderView target
-(void)nextWordWithBtn:(UIButton *)btn{
    NSString *upDown;
    NSString *code = self.cartoonModel.type;
    if(btn.tag == 1){
        upDown = @"2";
    }else{
        upDown = @"1";
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *dic = @{
                          @"cartoonId":self.cartoonModel.id,//书ID
                          @"chapterId":self.dataModel.chapterId,//章节ID
                          @"upDown":upDown,//1.下 2.上
                          @"code":code//1.漫画 2.章节
                          };
    [manager POST:[ZZTAPI stringByAppendingString:@"cartoon/getupDown"] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [[EncryptionTools sharedEncryptionTools] decry:responseObject[@"result"]];
        if(dic){
            [self.cartoonDetailArray removeAllObjects];
            [self.imageCellHeightCache removeAllObjects];
            [self.headerMuArr removeAllObjects];
            [self.tableView reloadData];
            ZZTChapterlistModel *model = [ZZTChapterlistModel mj_objectWithKeyValues:dic];
            self.dataModel.id = model.id;
            //最近观看改一下
            self.dataModel.chapterPage = model.chapterPage;
            self.dataModel.chapterName = model.chapterName;
            self.dataModel.chapterId = model.chapterId;
            [self.navbar.centerButton setTitle:self.dataModel.chapterName forState:UIControlStateNormal];
            [self loadData];
            [self.tableView reloadData];
            [self.tableView layoutIfNeeded];
//            NSIndexPath* indexPat = [NSIndexPath indexPathForRow:0 inSection:0];
//            [self.tableView setContentOffset:CGPointMake(0,0) animated:NO];
            [self.tableView  scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
        }else{
            //显示错误信息
            [MBProgressHUD showError:@"已经没有章节"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(void)headerViewLike{

    UserInfo *user = [Utilities GetNSUserDefaults];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    NSDictionary *dic = @{
                          @"type":self.cartoonModel.type,
                              @"typeId":[NSString stringWithFormat:@"%ld",self.dataModel.id],
                              @"userId":[NSString stringWithFormat:@"%ld",user.id],
//                          @"userId":@"1",
                              @"cartoonId":self.cartoonModel.id
                          };
    [manager POST:[ZZTAPI stringByAppendingString:@"great/cartoonPraise"] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

#pragma mark - 加尾巴
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if(section == 1){
        ZZTCommentHeadView *commentHeadView = [[ZZTCommentHeadView alloc] init];
        commentHeadView.backgroundColor = [UIColor whiteColor];
        return commentHeadView;
    }else{
        static NSString *viewIdentfier = @"footerView";
        SectionFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:viewIdentfier];
        if(!footerView){
            footerView = [[SectionFooterView alloc] initWithReuseIdentifier:viewIdentfier];
            if (!self.headerMuArr) {
                self.headerMuArr = [NSMutableArray array];
            }
            [self.headerMuArr addObject:footerView];
        }
        return footerView;
    }
}

//设置高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if(section == 2 && self.commentArray.count > 0){
        ZZTCircleModel *item = self.commentArray[section - 2];
        return item.footerHeight;
    }else if (section == 1){
        return 40;
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        if([self.cartoonModel.type isEqualToString:@"1"]){
            return [self.imageCellHeightCache[indexPath.row] doubleValue];
        }else{
            ZZTStoryModel *model = self.cartoonDetailArray[indexPath.row];
            if(model.content.length > 300){
                return [self calculateStringHeight:model.content];
            }else{
                return 0;
            }
        }
    }else if(indexPath.section == 2){
        return 100;
    }else{
        return 0;
    }
}

//续画
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    if (section == 0) {
//        ZZTContinueToDrawHeadView *view = [ZZTContinueToDrawHeadView ContinueToDrawHeadView];
//        view.buttonAction = ^(UIButton *sender) {
//          //跳转续画
//            ZZTCreationCartoonTypeViewController *xuHuaVC = [[ZZTCreationCartoonTypeViewController alloc] init];
//            xuHuaVC.type = self.cartoonModel.type;
//            self.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:xuHuaVC animated:YES];
//            self.hidesBottomBarWhenPushed = NO;
//        };
//        view.array = self.userLikeArray;
//        return view;
//    }else{
//        return nil;
//    }
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //如果是其他的cell
    if(indexPath.section == 0 || indexPath.section == 1){
        NSLog(@"你点中了不在进来的地方");
        //如果现在是隐藏状态
        if(needHide == YES){
            needHide = NO;
            [self hideOrShowHeadBottomView:needHide];
        }else{
            needHide = YES;
            [self hideOrShowHeadBottomView:needHide];
        }
    }else{
        //点击了评论cell  获取这条cell的信息
        ZZTCircleModel *model = self.commentArray[indexPath.section - 2];
        
        ZZTUserReplyModel *item = model.replyComment[indexPath.row];
        //回复人
        customer *replyer = item.replyCustomer;
        //xxx:
        customer *plyer = item.customer;
        
        customer *customer = model.customer;    //初始化字符串

        //回复谁
        if(replyer.nickName == nil || [replyer.nickName length] <= 0 || [replyer.ID isEqualToString:customer.ID]){
            //没有回复人的  p
            self.replyer = plyer;
            self.commentId = item.id;
        }else{
            self.replyer = replyer;
            self.commentId = item.id;
        }
        self.isReply = YES;
        //设置输入回复信息
        [self startComment];
    }
    //开始进来是显示的
    if(self.isNavHide == NO){
        self.isNavHide = YES;
//        [[UIApplication sharedApplication] setStatusBarHidden:YES];
//        [self hideOrShowHeadBottomView:self.isNavHide];
    }else{
        self.isNavHide = NO;
//        [[UIApplication sharedApplication] setStatusBarHidden:NO];
//        [self hideOrShowHeadBottomView:self.isNavHide];
    }

//    //弹出键盘
//    ZZTCircleModel *item = self.commentArray[indexPath.section - 2];
//    ZZTUserReplyModel *model = item.replyComment[indexPath.row];
//    if(model){
//        customer *toUser = model.replyCustomer;
//        self.selectedSection = indexPath.section;
//        self.toPeople = @{
////                          @"comment_to_user_id": toUser.ID,
//                          @"comment_to_user_name":toUser.nickName,
//                          };
//        [self startComment];
//    }
}

-(void)hideOrShowHeadView:(BOOL)needHide{
    
    if(self.navigationController.navigationBar.hidden == needHide) return;
    
    [self.navigationController setNavigationBarHidden:needHide animated:YES];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    NSLog(@"%lf",scrollView.contentOffset.y);
    
    //到顶部显示
    if(targetContentOffset->y <= 64){
        needHide = NO;
        [self hideOrShowHeadBottomView:needHide];
    }else{
        needHide = YES;
        [self hideOrShowHeadBottomView:needHide];

        needHide = YES;
        [self hideOrShowHeadBottomView:needHide];
    }
    self.isNavHide = needHide;
}

- (void)hideOrShowHeadBottomView:(BOOL)needhide{
    
    UIView  *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    BOOL statusAlpha = needhide ? 0 : 1;
    self.statusBar = statusBar;
    statusBar.alpha = statusAlpha;
//    [[UIApplication sharedApplication] setStatusBarHidden:needhide];
    CGFloat offset = needhide ? navHeight : 0;
    self.navbar.hide = needhide;
    if(needhide == YES){
        offset = -navHeight;
        [self.navbar mas_updateConstraints:^(MASConstraintMaker *make) {    //隐藏底部视图
            make.top.equalTo(self.view).offset(offset);
        }];
        [self.kInputView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(50);
        }];
    }else{
        [self.navbar mas_updateConstraints:^(MASConstraintMaker *make) {    //隐藏底部视图
            make.top.equalTo(self.view).offset(offset);
        }];
        [self.kInputView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(0);
        }];
    }
    
    //隐藏动画
    [UIView animateWithDuration:0.25 animations:^{
        [self.kInputView layoutIfNeeded];
        [self.navbar layoutIfNeeded];
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].enable = YES;
    
    self.statusBar.alpha = 1;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    //继续阅读业务
    //从本地拿到数据源
    NSMutableArray *arrayDict = [NSKeyedUnarchiver unarchiveObjectWithFile:JiXuYueDuAPI];
    if (arrayDict == nil) {
        arrayDict = [NSMutableArray array];
    }
    
    NSLog(@"arrayDict:%@",arrayDict);
    
    //直接存这本书
    //创建一本书
    ZZTJiXuYueDuModel *model = [[ZZTJiXuYueDuModel alloc] init];
    //书名
    model.bookName = _cartoonModel.bookName;
    //书ID
    model.bookId = _cartoonModel.id;    //判断那本书
    model.chapterListRow = [NSString stringWithFormat:@"%ld",self.indexRow];
    
//    model.lastChapterId = self.dataModel.id;
    //这本书有哪些章节
    ZZTChapterModel *chapterModel = [[ZZTChapterModel alloc] init];
    chapterModel.chapterName = self.dataModel.chapterName;//章节名
    chapterModel.chapterPage = self.dataModel.chapterPage;//章节字数  多少画
    chapterModel.chapterIndex = self.indexRow;//第几行
    chapterModel.chapterId = self.dataModel.id;//章节id
    chapterModel.readPoint = self.readPoint;
    NSLog(@"退出：readPoint:%@",NSStringFromCGPoint(chapterModel.readPoint));
    
    //先看有没有这篇文章
    BOOL isHave = NO;
    int arrayIndex = 0;
    //因为有很多本书 所以会有很多对象
    for (int i = 0; i < arrayDict.count; i++) {
        ZZTJiXuYueDuModel *bookModel = arrayDict[i];
        if([bookModel.bookId isEqualToString:_cartoonModel.id]){
            //证明有这一本书
            isHave = YES;
            arrayIndex = i;
            break;
        }
    }

    //如果有 就修改
    if(isHave == YES){
        //取出这本书
        ZZTJiXuYueDuModel *readModel = arrayDict[arrayIndex];
        
        //查有没有这个章节
        BOOL isChapterHave = NO;
        NSInteger index = 0;
        for (int i = 0; i < readModel.chapterArray.count; i++) {
            ZZTChapterModel *chapterM = readModel.chapterArray[i];
            if(chapterModel.chapterId == chapterM.chapterId){
                isChapterHave = YES;
                index = i;
                break;
            }
        }
        //如果有这个章节
        if(isChapterHave == YES){
            readModel.arrayIndex = [NSString stringWithFormat:@"%ld",index];
            [readModel.chapterArray replaceObjectAtIndex:index withObject:chapterModel];
        }else{
            readModel.arrayIndex = [NSString stringWithFormat:@"%ld",readModel.chapterArray.count];
            [readModel.chapterArray addObject:chapterModel];
        }
        readModel.chapterListRow = [NSString stringWithFormat:@"%ld",self.indexRow];
        [arrayDict replaceObjectAtIndex:arrayIndex withObject:readModel];
    }else{
        [model.chapterArray addObject:chapterModel];
        [arrayDict addObject:model];
    }
    //存
    NSString *path = JiXuYueDuAPI;
    [NSKeyedArchiver archiveRootObject:arrayDict toFile:path];
    NSLog(@"readPoint111111:%@",NSStringFromCGPoint(_readPoint));
}

//点击继续阅读的时候 才会传这个
//
//-(void)setModel:(ZZTJiXuYueDuModel *)model{
//    _model = model;
//    if(model){
//        self.isJXYD = YES;
//    }
//    else{
//        self.isJXYD = NO;
//    }
//}

-(void)setTestModel:(ZZTJiXuYueDuModel *)testModel{
    _testModel = testModel;
    if(testModel){
        self.isJXYD = YES;
        self.model = testModel;
        if(self.model.chapterArray.count > 0){
            for (int i = 0; i < self.model.chapterArray.count; i++) {
                ZZTChapterModel *chapterModel = testModel.chapterArray[i];
                if(chapterModel.chapterId == self.dataModel.id){
                    self.chapterModel = chapterModel;
                    break;
                }
            }
        }
    }else{
        self.isJXYD = NO;
    }
}

-(ZZTJiXuYueDuModel *)model{
    if(!_model){
        _model = [[ZZTJiXuYueDuModel alloc] init];
    }
    return _model;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint readPoint = CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y);
    _readPoint = readPoint;
}

-(void)setIndexRow:(NSInteger)indexRow{
    _indexRow = indexRow;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    NSLog(@"width:%f",[UIScreen mainScreen].bounds.size.width);
    [IQKeyboardManager sharedManager].enable = YES;
//    [IQKeyboardManager sharedManager];
//    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
//    _keyboardManager = keyboardManager;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    self.navigationController.navigationBar.alpha = 0;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

#pragma mark - SectionHeaderViewDelegate
- (void)spreadContent:(BOOL)isSpread section:(NSUInteger)section{
    ZZTCircleModel *item = self.commentArray[section - 2];
    item.isSpread = isSpread;
    item.headerHeight = [[FriendCircleViewModel new] getHeaderHeight:item];
    [self.tableView reloadData];
}

-(void)didCommentLabelReply:(NSInteger)section{
    ZZTCircleModel *item = self.commentArray[section];
    self.commentId = item.id;
    //找到回复人了
    self.isReply = YES;

//    self.replySection = section;
    //弹出键盘
    [self startComment];
    //设置ID
    //发送请求
    NSLog(@"点中了");
}

-(void)didClickLikeButton:(NSInteger)section{
    UserInfo *user = [Utilities GetNSUserDefaults];
    ZZTCircleModel *item = self.commentArray[section];
    NSDictionary *dic = @{
                          @"userId":[NSString stringWithFormat:@"%ld",user.id],
                          @"type":@"3",
                          @"typeId":item.id,
                              @"cartoonId":self.cartoonModel.id
                          };
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    [manager POST:[ZZTAPI stringByAppendingString:@"great/cartoonPraise"]  parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

//// 开始拖拽
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    [self hideKeyBoard];
//}
//
//- (void)hideKeyBoard {
//    [self.kTextView resignFirstResponder];
//}
//- (void)startComment {
//    [self.kTextView becomeFirstResponder];
//}

//- (void)dealloc {
//    [self.kInputView removeFromSuperview];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
//}
//
//
//- (void)textViewDidChange:(UITextView *)textView {
//    if (textView.text.length > 5000) { // 限制5000字内
//        textView.text = [textView.text substringToIndex:5000];
//    }
//    static CGFloat maxHeight = 36 + 24 * 2;//初始高度为36，每增加一行，高度增加24
//    CGRect frame = textView.frame;
//    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
//    CGSize size = [textView sizeThatFits:constraintSize];
//    if (size.height >= maxHeight) {
//        size.height = maxHeight;
//        textView.scrollEnabled = YES;   // 允许滚动
//    } else {
//        textView.scrollEnabled = NO;    // 不允许滚动
//    }
//    if ((ceil(size.height) + 14) != self.kInputHeight) {
//        CGPoint offset = self.tableView.contentOffset;
//        CGFloat delta = ceil(size.height) + 14 - self.kInputHeight;
//        offset.y += delta;
//        if (offset.y < 0) {
//            offset.y = 0;
//        }
//        [self.tableView setContentOffset:offset animated:NO];
//        self.kInputHeight = ceil(size.height) + 14;
//        [self.kInputView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(@(ceil(size.height) + 14));
//        }];
//    }
//}
//
//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    if ([text isEqualToString:@"\n"]){
//        if (self.kTextView.text.length > 0) {     // send Text
////            [self sendMessage:self.kTextView.text];
//        }
//        [self.kInputView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(@50);
//        }];
//        [self.kTextView setText:@""];
//        self.kInputHeight = 50;
//        [self hideKeyBoard];
//        return NO;
//    }
//    return YES;
//}
//
//#pragma mark - 通知方法
//- (void)keyboardWillChangeFrame:(NSNotification *)notification {
//    NSDictionary *userInfo = notification.userInfo;
//    // 1,取出键盘动画的时间
//    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    // 2,取得键盘将要移动到的位置的frame
//    CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    // 3,计算kInputView需要平移的距离
//    CGFloat moveY = self.view.frame.size.height + TOPBAR_HEIGHT - keyboardFrame.origin.y;
//    // 4,执行动画
//
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
////    SectionHeaderView *headerView = (SectionHeaderView *)[self.tableView headerViewForSection:self.selectedSection];
////    CGRect rect = [headerView.superview convertRect:headerView.frame toView:window];
////    CircleItem *item = self.dataMuArr[self.selectedSection];
////    CGFloat cellHeight = item.likerHeight;
////    for (NSNumber *num in item.commentHeightArr) {
////        cellHeight += [num floatValue];
////    }
////    CGFloat footerMaxY = CGRectGetMaxY(rect) + cellHeight + item.footerHeight;
////    CGFloat delta = footerMaxY - (SCREEN_MAX_LENGTH - (moveY + self.kInputHeight));
////    CGPoint offset = self.tableView.contentOffset;
//////    offset.y += delta;
////    if (offset.y < 0) {
////        offset.y = 0;
////    }
////    [self.tableView setContentOffset:offset animated:NO];
////    [self.kInputView mas_updateConstraints:^(MASConstraintMaker *make) {
////        if (moveY == 0) {
////            make.bottom.equalTo(@(self.kInputHeight));
////        } else {
////            make.bottom.equalTo(@(-moveY));
////        }
////    }];
////    [UIView animateWithDuration:duration animations:^{
////        [[UIApplication sharedApplication].keyWindow layoutIfNeeded];
////    }];
//}
////cell 漫画 3

#pragma mark cartCell代理
-(void)cellHeightUpdataWithIndex:(NSUInteger)index Height:(CGFloat)height{
    //存一个数
    //如果不一样就先刷新一下
    NSNumber *newHeight = [NSNumber numberWithDouble:height];
    [self.imageCellHeightCache replaceObjectAtIndex:index withObject:newHeight];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
//    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
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
        CGPoint offset = self.tableView.contentOffset;
        CGFloat delta = ceil(size.height) + 14 - self.kInputHeight;
        offset.y += delta;
        if (offset.y < 0) {
            offset.y = 0;
        }
        [self.tableView setContentOffset:offset animated:NO];
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
        //要记得删除掉replyer
//        if (self.replyer.nickName){
//            textView.text = [NSString stringWithFormat:@"回复%@",self.replyer.nickName];
//            textView.textColor = [UIColor blackColor];
//        }else{
            textView.text = @"";
            textView.textColor = [UIColor blackColor];
//        }
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

-(void)sendMessage{
    
    if (_kTextView.text.length == 0 || [_kTextView.text isEqualToString:@"请输入评论"]) {
        [MBProgressHUD showError:@"请输入评论再发布"];
        return;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    UserInfo *user = [Utilities GetNSUserDefaults];
    [MBProgressHUD showMessage:@"正在发布..." toView:self.view];
    NSDictionary *dic = @{
                          @"userId":[NSString stringWithFormat:@"%ld",user.id],
                              @"parentCommentId":self.commentId,
                              @"contentId":[NSString stringWithFormat:@"%ld",self.dataModel.id],
                              @"type":self.cartoonModel.type,
                              @"content":self.kTextView.text
                          };
    [manager POST:[ZZTAPI stringByAppendingString:@"cartoon/insertCartoonComment"] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self sendMessageSuccess];
   
        //关闭键盘
        //如果字数小于0 不能发布
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

-(void)hideKeyBoard{
    [self.kTextView resignFirstResponder];
}

- (void)startComment {
   [self.kTextView becomeFirstResponder];
}

-(void)sendMessageSuccess{
    //刷新数据
    [self loadCommentData];
    [self.tableView reloadData];
    
    //小菊花
    //清空字数
    [self.kInputView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@50);
    }];
    [self.kTextView setText:@""];
//    [self.kTextView ];
    self.kInputHeight = 50;
    [self hideKeyBoard];
//    [self.tableView reloadData];
    
//    //记录第几节
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(0);
//        make.bottom.left.right.mas_equalTo(0);
//    }];
}

- (void)dealloc {
    [self.kInputView removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

-(void)shareWithSharePanel{
    __weak typeof(self) ws = self;
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        [ws shareTextToPlatform:platformType];
    }];
}

//分享
-(void)shareTextToPlatform:(UMSocialPlatformType)plaform{
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    messageObject.text = @"友盟+";
    
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"自在动漫" descr:@"自在动漫~自在~" thumImage:[UIImage imageNamed:@"我的-头像框"]];
    shareObject.webpageUrl = @"http://www.zztian.cn/"; //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    [[UMSocialManager defaultManager] shareToPlatform:plaform messageObject:messageObject currentViewController:nil completion:^(id result, NSError *error) {
        if(error){
            //failed
        }else{
            //success
        }
    }];
}

#pragma mark - 屏幕快照
-(UIImage *)generateSnapshot {
    NSMutableArray *screenshots = [NSMutableArray array];
    
    //cell
    for (int row = 0; row < [self.tableView numberOfRowsInSection:0]; row++) {
        
        NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:row inSection:0];
        
        UIImage *cellScreenshot = [self.tableView screenshotOfCellAtIndexPath:cellIndexPath];
        
        if (cellScreenshot) [screenshots addObject:cellScreenshot];
        
    }
    UIImage *image = [UIImage verticalImageFromArray:screenshots];
    
    NSString *homeDirectory = NSHomeDirectory();
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:@"image.png"];
    NSLog(@"filePath%@",filePath);
    [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
    return image;
}


@end
