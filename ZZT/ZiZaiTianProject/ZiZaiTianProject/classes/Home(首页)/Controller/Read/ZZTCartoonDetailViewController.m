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
#import "TJLongImgCut.h"
#import "ZZTLikeCollectShareHeaderView.h"
#import "ZZTAuthorHeaderView.h"
#import "ZZTCommentAirView.h"
#import "ZZTCommentViewController.h"
#import "ZZTStatusCell.h"
#import "ZZTStatusFooterView.h"
#import "ZZTStoryModel.h"

@interface ZZTCartoonDetailViewController ()<UITableViewDelegate,UITableViewDataSource,CircleCellDelegate,ZZTCommentHeaderViewDelegate,UITextViewDelegate,NSURLSessionDataDelegate,ZZTCartoonContentCellDelegate,ZZTStoryDetailCellDelegate,ZZTStatusCellDelegate,ZZTStatusFooterViewDelegate>

@property (nonatomic,strong) NSMutableArray *cartoonDetailArray;

@property (nonatomic,strong) NSMutableArray *commentArray;

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

@property (nonatomic,strong) ZZTStatusCell *statusCell;
//判断恢复状态
@property (nonatomic,assign) BOOL isReply;
//回复者ID(节上的)
@property (nonatomic,strong) NSString *replyId;

@property (nonatomic,assign) NSInteger replySection;
//回复人（cell上的）
@property (nonatomic,strong) customer *replyer;

//@property (nonatomic,strong) dispatch_group_t group;
//
//@property (nonatomic,assign) dispatch_queue_t q;
//点赞模型
@property (nonatomic,strong) ZZTStoryModel *likeModel;
//上一章下一章视图
@property (nonatomic,strong) ZZTNextWordHeaderView *nextWordView;
//点赞视图
@property (nonatomic,strong) ZZTLikeCollectShareHeaderView *likeCollectView;
//电池条
@property (nonatomic,strong) UIView *statusBar;
//图片地址数组
@property (nonatomic,strong) NSMutableArray *imageUrlArray;
//TXTURL
@property (nonatomic,strong) NSString *TXTURL;

@property (nonatomic,strong) NSString *fileName;
//刷新计数
@property (nonatomic,assign) NSInteger reloadDataCount;
//底部作者视图
@property (nonatomic,strong) ZZTAuthorHeaderView *authorHeaderView;

@property (nonatomic,assign) NSInteger moreCommentPage;

@property (nonatomic,assign) NSInteger updataCommentPage;
//判断有没有评论
@property (nonatomic,assign) BOOL isHasComment;
//当前回复
@property (nonatomic,strong) ZZTCircleModel *nowReplyModel;
//判断是评论还是回复
@property (nonatomic,strong) NSString *isCommentOrReply;
//章节总数
@property (nonatomic,assign) NSInteger listTotal;

@end

NSString *CartoonContentCellIdentifier = @"CartoonContentCellIdentifier";

NSString *Comment = @"Comment";

NSString *story = @"story";

NSString *storyDe = @"storyDe";

static NSString *const airView = @"airView";

static NSString *const kCellId = @"CircleCell";

static const CGFloat imageCellHeight = 500.0f;

static bool needHide = false;

@implementation ZZTCartoonDetailViewController

-(NSMutableArray *)imageUrlArray{
    if(!_imageUrlArray){
        _imageUrlArray = [NSMutableArray array];
    }
    return _imageUrlArray;
}
//
//-(dispatch_group_t)group{
//    if(!_group){
//        _group = dispatch_group_create();
//    }
//    return _group;
//}
//
//-(dispatch_queue_t)q{
//    if(!_q){
//        _q = dispatch_get_global_queue(0, 0);
//    }
//    return _q;
//}

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
//初始化图片高度 如果有缓存使用缓存高度
- (NSMutableArray *)imageCellHeightCache {
    if (!_imageCellHeightCache && self.cartoonDetailArray) {
        
        if(self.chapterModel.imageHeightCache.count > 0){
            _imageCellHeightCache = self.chapterModel.imageHeightCache;
        }else{
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            
            for (NSInteger index = 0; index < self.cartoonDetailArray.count; index++) {
                [arr addObject:@(imageCellHeight)];
            }
            _imageCellHeightCache = arr;
        }
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

-(NSMutableArray *)commentArray{
    if (!_commentArray) {
        _commentArray = [NSMutableArray array];
    }
    return _commentArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

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

    //键盘输入框
    [self addInputView];
    
    self.kInputHeight = 50;
    
    //初始化 没有人回复
    self.isReply = NO;

    self.reloadDataCount = 0;
    
    self.tableView.fd_debugLogEnabled = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:@"cellreloadData" object:nil];
    
    //加载数据
    [self loadContent];
    
    //评论下拉刷新
    [self setupMJRefresh];
}

-(void)setupMJRefresh{
//    //刷新评论的page数
//    _moreCommentPage = 2;
//    //更新评论的page数
//    _updataCommentPage = 1;
//    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        [self loadMoreCommentData];
//    }];

    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullUpToReloadMoreData:)];

}

#pragma mark - 跳转评论页
- (void)pullUpToReloadMoreData:(MJRefreshBackNormalFooter *)table{
    //没有登录
    if([[UserInfoManager share] hasLogin] == NO){
        [UserInfoManager needLogin];
        [table endRefreshing];
        return;
    }
    NSLog(@"--- 上拉");
    
    //显示评论页面
    ZZTCommentViewController *commentView = [[ZZTCommentViewController alloc] init];
    ZZTNavigationViewController *nav = [[ZZTNavigationViewController alloc] initWithRootViewController:commentView];

    commentView.chapterId = [NSString stringWithFormat:@"%ld",self.dataModel.id];
    commentView.cartoonType = self.cartoonModel.type;
    [self presentViewController:nav animated:YES completion:nil];

    [table endRefreshing];

}

//下拉评论接口
- (void)loadMoreCommentData{
    if([[UserInfoManager share] hasLogin] == NO){
        [UserInfoManager needLogin];
        return;
    }
    UserInfo *user = [Utilities GetNSUserDefaults];
    AFHTTPSessionManager *session = [[AFHTTPSessionManager alloc] init];
    NSDictionary *commentDict = @{
                                  @"itemId":[NSString stringWithFormat:@"%ld",self.dataModel.id],
                                  @"type":self.cartoonModel.type,
                                  @"pageNum":[NSString stringWithFormat:@"%ld",_moreCommentPage],
                                  @"pageSize":@"10",
                                  @"userId":[NSString stringWithFormat:@"%ld",user.id]
                                  };
    [session POST:[ZZTAPI stringByAppendingString:@"cartoon/cartoonComment"] parameters:commentDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //还要判断
        NSDictionary *commenDdic = [[EncryptionTools alloc] decry:responseObject[@"result"]];
        //这里有问题 应该是转成数组 然后把对象取出
        NSMutableArray *array1 = [ZZTCircleModel mj_objectArrayWithKeyValuesArray:commenDdic];
        //外面的数据
        FriendCircleViewModel *circleViewModel = [[FriendCircleViewModel alloc] init];
        circleViewModel.circleModelArray = array1;
        NSMutableArray *moreArray = [circleViewModel loadDatas];
        [self.commentArray addObjectsFromArray:moreArray];
        //加工一下评论的数据
        [self.tableView reloadData];
        self.updataCommentPage = self.moreCommentPage;
        self.moreCommentPage++;
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_footer endRefreshing];
    }];
}

-(void)receiveNotification:(NSNotification *)infoNotification {
    
    NSDictionary *dic = [infoNotification userInfo];
    
    NSString *index = [dic objectForKey:@"index"];
    
    NSNumber *height = [dic objectForKey:@"height"];
    
    NSInteger indexRow = [index integerValue];
    
    NSLog(@"height:%@",height);
    
    [self.tableView beginUpdates];
    if(height > 0)[self.imageCellHeightCache replaceObjectAtIndex:indexRow withObject:height];

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:indexRow inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];

    [self.tableView endUpdates];
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
    [navbar.centerButton setTitle:[NSString stringWithFormat:@"%@第%@",_cartoonModel.bookName,self.dataModel.chapterName] forState:UIControlStateNormal];
    [navbar.centerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [navbar.mainView setBackgroundColor:[UIColor colorWithRGB:@"121,105,212"]];
    
    [navbar.rightButton setImage:[UIImage imageNamed:@"cartoonDetail_share"] forState:UIControlStateNormal];
    [navbar.rightButton addTarget:self action:@selector(shareWithSharePanel) forControlEvents:UIControlEventTouchUpInside];
    navbar.showBottomLabel = NO;
}

//取消多余字符
- (NSString *)getZZwithString:(NSString *)string{
    
    NSRegularExpression *regularExpretion = [NSRegularExpression regularExpressionWithPattern:@"<[^>]*>|\n" options:0 error:nil];
    
    string = [regularExpretion stringByReplacingMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length) withTemplate:@""];
    
    return string;
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
    _kTextView.text = @"赶紧评论秀才华~";
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
        make.left.equalTo(@7);
        make.right.equalTo(@(-(SCREEN_WIDTH / 5)));
    }];
    
    //发布按钮
    UIButton *publishBtn = [[UIButton alloc] init];
    [publishBtn setTitle:@"发布" forState:UIControlStateNormal];
    [publishBtn setBackgroundColor:ZZTSubColor];
    [publishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_kInputView addSubview:publishBtn];
    [publishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.bottom.equalTo(@(-0));
        make.left.equalTo(self.kTextView.mas_right).offset(4);
        make.width.mas_equalTo(SCREEN_WIDTH / 5);
    }];
    _publishBtn = publishBtn;
    [publishBtn addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)likeBtnTaget{
    if([[UserInfoManager share] hasLogin] == NO){
        [UserInfoManager needLogin];
        return;
    }
    [MBProgressHUD showSuccess:@"点赞成功" toView:self.view];
  
        [self headerViewLike];


    //点赞完了以后 重新请求一次获取点赞的接口  刷新点赞图标
 
        [self loadLikeData];

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
        return self.commentArray.count + 3;
    }else{
        return 3;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return self.cartoonDetailArray.count;
    }else if (section == 1 || section == 2){
        return 0;
    }else{
        if(_isHasComment){
            //没有评论的时候
            return 0;
        }else{
            ZZTCircleModel *model = self.commentArray[section - 3];
            return model.replyComment.count;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"indexRow:%ld",(long)indexPath.row);
    if(indexPath.section == 0){
        //漫画   是这里的数据
        if([self.cartoonModel.type isEqualToString:@"1"]){
            //数据源
            ZZTCartoonContentCell *cell = [tableView dequeueReusableCellWithIdentifier:CartoonContentCellIdentifier];
            cell.delegate = self;
            ZZTCartoonModel *model = self.cartoonDetailArray[indexPath.row];
            model.index = indexPath.row;
            cell.model = model;
            return cell;
        }else{
            ZZTStoryDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:story];
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            ZZTStoryModel *model = self.cartoonDetailArray[indexPath.row];
            cell.index = indexPath.row;
            cell.str = model.content;
            NSLog(@"model.content:%@",model.content);
            return cell;
        }
    }else{
        //回复cell
        ZZTCircleModel *model = self.commentArray[indexPath.section - 3];
        CircleCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId forIndexPath:indexPath];
        [cell setContentData:model index:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
            if(model.TXTContent.length > 300){
                return [self calculateStringHeight:model.TXTContent];
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


    [self loadContentData];

    [self loadCommentData];

    [self loadLikeData];

#warning 看这里有没有问题
    //显示作者信息
    self.authorHeaderView.userModel = self.author;
    //没有本地连接
    if(!self.chapterModel.TXTFileName){
        //下载地址
//        [self downloadTxT];
    }else{
//            [self.tableView reloadData];
    }
    [self.tableView reloadData];

}

#warning 上下页btn样式
//上下页btn样式
-(void)loadUpDownBtnData{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    NSDictionary *dic = @{
                          @"cartoonId":self.cartoonModel.id,//书ID
                          @"chapterId":self.dataModel.chapterId,//章节ID
                          @"upDown":@"1",//1.下 2.上
                          @"code":@"1"//1.漫画 2.章节
                          };
    [manager POST:[ZZTAPI stringByAppendingString:@"cartoon/getupDown"] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [[EncryptionTools alloc] decry:responseObject[@"result"]];
        NSLog(@"dic:%@",dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(void)downloadTxT{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    // 1. 创建会话管理者
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    // 2. 创建下载路径和请求对象
    NSURL *URL = [NSURL URLWithString:self.TXTURL]; NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    // 3.创建下载任务 /** * 第一个参数 - request：请求对象 * 第二个参数 - progress：下载进度block * 其中： downloadProgress.completedUnitCount：已经完成的大小 * downloadProgress.totalUnitCount：文件的总大小 * 第三个参数 - destination：自动完成文件剪切操作 * 其中： 返回值:该文件应该被剪切到哪里 * targetPath：临时路径 tmp NSURL * response：响应头 * 第四个参数 - completionHandler：下载完成回调 * 其中： filePath：真实路径 == 第三个参数的返回值 * error:错误信息 */
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        //保存的文件路径
        NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
        
        NSLog(@"response:%@",response.suggestedFilename);
        
        return [NSURL fileURLWithPath:fullPath];

    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath.path);
        //把response的文件名
        self.fileName = filePath.path;
    }];
    // 4. 开启下载任务
    [downloadTask resume];
}

//把请求单独的抽出来
-(void)loadContentData{
    UserInfo *user = [Utilities GetNSUserDefaults];

    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    
    if([self.cartoonModel.type isEqualToString:@"1"]){
        //漫画
        if(self.chapterModel.imageUrlArray.count > 0){
            self.cartoonDetailArray = self.chapterModel.imageUrlArray;
            self.imageUrlArray = self.cartoonDetailArray;
            self.author = self.chapterModel.autherData;
            [self reloadCellWithIndex];
        }else{
            
            NSDictionary *paramDict = @{
                                        @"userId":[UserInfoManager share].ID,
                                        @"id":[NSString stringWithFormat:@"%ld",_dataModel.id],
                                        @"pageNum":@"0",
                                        @"pageSize":@"200"
                                        };
            [manager POST:[ZZTAPI stringByAppendingString:@"cartoon/getCartoonCenter"] parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                [self.cartoonDetailArray removeAllObjects];
                self.cartoonDetailArray = nil;
//                [self.imageUrlArray removeAllObjects];
                self.imageUrlArray = nil;
                
                NSArray *dataArray = [[EncryptionTools alloc] getDecryArray:responseObject[@"result"]];
                if(dataArray.count > 0){
                    NSDictionary *dict = dataArray[0];
                    NSArray *array = dict[@"list"];
                    NSMutableArray *cartArray = [ZZTCartoonModel mj_objectArrayWithKeyValuesArray:array];
                    //作者名字 信息
                    UserInfo *author = [UserInfo mj_objectWithKeyValues:dataArray[1]];
                    self.cartoonDetailArray = cartArray;
                    self.imageUrlArray = cartArray;
                    self.author = author;
                }
                [self reloadCellWithIndex];

            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            }];
            
        }
    }else{
        if(self.chapterModel.TXTFileName){
            
            ZZTStoryModel *model = [[ZZTStoryModel alloc] init];
            model = self.chapterModel.storyModel;
            model.content = self.chapterModel.TXTFileName;
            [self.cartoonDetailArray addObject:model];
            self.fileName = self.chapterModel.TXTFileName;
            self.stroyModel = model;
            self.author = self.chapterModel.autherData;
            [self reloadCellWithIndex];
            [self reloadCellWithIndex];

        }else{
            //章节
            NSDictionary *paramDict = @{
                                        @"chapterinfoId":[NSString stringWithFormat:@"%ld",_dataModel.id],
                                        @"userId":[NSString stringWithFormat:@"%ld",user.id]
                                        };
            [manager POST:[ZZTAPI stringByAppendingString:@"cartoon/getChapterInfo"] parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                self.cartoonDetailArray = nil;
                NSString *data = responseObject[@"result"];
                NSDictionary *dic = [[EncryptionTools alloc] decry:data];
                NSMutableArray *array = [ZZTStoryModel mj_objectArrayWithKeyValuesArray:dic];
                self.cartoonDetailArray = array;
                if(array.count > 0) {
                    ZZTStoryModel *model = array[0];
                    self.stroyModel = model;
                    //下载文件的地址  为了缓存下载
                    self.TXTURL = model.content;
                    //作者信息
                    UserInfo *userData = [UserInfo initAuthorWithUserId:model.userId headImg:model.headimg nikeName:model.nickName];
                    self.author = userData;
                }

                [self reloadCellWithIndex];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

            }];
        }
    }
}

-(void)loadLikeData{
    
    UserInfo *user = [Utilities GetNSUserDefaults];
    AFHTTPSessionManager *session = [[AFHTTPSessionManager alloc] init];
    NSDictionary *likeDict = @{
                               @"chapterId":[NSString stringWithFormat:@"%ld",self.dataModel.id],
                               @"userId":[NSString stringWithFormat:@"%ld",user.id]
                               };
    [session POST:[ZZTAPI stringByAppendingString:@"cartoon/getChapterPraise"] parameters:likeDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [[EncryptionTools alloc] decry:responseObject[@"result"]];
        self.likeModel = [ZZTStoryModel mj_objectWithKeyValues:dic];
        self.likeCollectView.likeModel = self.likeModel;
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

    }];
}

-(void)loadCommentData{
    _isHasComment = NO;
    UserInfo *user = [Utilities GetNSUserDefaults];
    AFHTTPSessionManager *session = [[AFHTTPSessionManager alloc] init];

    NSDictionary *dict = @{
                           @"chapterId":[NSString stringWithFormat:@"%ld",self.dataModel.id],
                           @"type":self.cartoonModel.type,
                           @"userId":[NSString stringWithFormat:@"%ld",user.id],
                           @"pageNum":@"0",
                           @"pageSize":@"10",
                           @"host":@"1"
                           };
    [session POST:[ZZTAPI stringByAppendingString:@"cartoon/cartoonComment"] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.commentArray = nil;
        NSDictionary *commenDdic = [[EncryptionTools alloc] decry:responseObject[@"result"]];
        //这里有问题 应该是转成数组 然后把对象取出
        NSDictionary *list = commenDdic[@"list"];
        NSMutableArray *array1 = [ZZTCircleModel mj_objectArrayWithKeyValuesArray:list];
        if(array1.count == 0){
            //没有数据的时候
            [self.commentArray addObject:@"1"];
            self.isHasComment = YES;
//            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            //外面的数据
            FriendCircleViewModel *circleViewModel = [[FriendCircleViewModel alloc] init];
            circleViewModel.circleModelArray = array1;
            self.commentArray = [circleViewModel loadDatas];
//            [self.tableView.mj_footer endRefreshing];
        }
        //加工一下评论的数据
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

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
        return;
    }
}

//下载txt
-(void)downLoadTxt:(NSString *)txtUrl{
//    NSError *error;
//    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
//
//    NSString *htmlString = [NSString stringWithContentsOfURL:[NSURL URLWithString:txtUrl] encoding:enc error:&error];
//    if(!error){
//        htmlString = [self getZZwithString:htmlString];
//        self.stroyModel.content = htmlString;
////        [self.tableView reloadData];
//        [self reloadCellWithIndex];
//    }else{
//        NSLog(@"error:%@",error);
//    }
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

-(void)setDataModel:(ZZTChapterlistModel *)dataModel{
    _dataModel = dataModel; // 你的问题在哪里  是没有数据还是数据错乱
    //设置总数 方便进行下一页判断
    self.listTotal = dataModel.listTotal;
}
-(void)setCartoonModel:(ZZTCarttonDetailModel *)cartoonModel{
    _cartoonModel = cartoonModel;
}

//请求数据后显示那一行
-(void)reloadCellWithIndex{
    if(self.isJXYD){
//        dispatch_async(dispatch_get_main_queue(), ^{

            [self.tableView layoutIfNeeded];
            
            [self.tableView reloadData];

            CGFloat y = self.chapterModel.readPoint.y;
        
            [self.tableView setContentOffset:CGPointMake(0 , y) animated:NO];
//        });
    }else{
//        dispatch_async(dispatch_get_main_queue(), ^{
        
            [self.tableView layoutIfNeeded];
            
            [self.tableView reloadData];
//        });
    }
}

#pragma mark UITableViewDataSource 头高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 0){
        return SCREEN_HEIGHT * 0.14;
    }else if(section == 1){
        //点赞 关注 分享
        return SCREEN_HEIGHT * 0.124;
    }else if (section == 2){
        //作者
        return SCREEN_HEIGHT * 0.18;
    }else{
        if(_isHasComment){
            //没有评论
            return SCREEN_HEIGHT * 0.31;
        }else{
//            ZZTCircleModel *item = self.commentArray[section - 3];
//            return item.headerHeight + 24;
            ZZTCircleModel *model = self.commentArray[section - 3];
            return model.headerHeight;
        }
    }

}

//添加头 ZZTCartoonDetailFoot
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSLog(@"section%ld",section);
    if(section == 0){
        //作者 顶部
        ZZTAuthorHeadView *authorHead = [ZZTAuthorHeadView AuthorHeadView];
        authorHead.userModel = self.author;
        return authorHead;
    }else if(section == 1){
        //点赞 关注 分享
        static NSString *likeCollectShareHeaderView = @"likeCollectShareHeaderView";
        ZZTLikeCollectShareHeaderView *likeCollectView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:likeCollectShareHeaderView];
        //如果没有头视图
        if(!likeCollectView){
            likeCollectView = [[ZZTLikeCollectShareHeaderView alloc] initWithReuseIdentifier:likeCollectShareHeaderView];
        }
        likeCollectView.collectModel = self.collectModel;
        weakself(self);
        //点赞
        likeCollectView.likeBtnBlock = ^{
            [weakSelf headerViewLike];
        };
        //收藏
        likeCollectView.collectBtnBlock = ^{
            [weakSelf headerViewCollect];
        };
        //分享
        [likeCollectView.shareBtn addTarget:self action:@selector(shareWithSharePanel) forControlEvents:UIControlEventTouchUpInside];
        _likeCollectView = likeCollectView;
        self.likeCollectView.likeModel = self.likeModel;
        return _likeCollectView;
    }else if (section == 2){
        //作者
        static NSString *authorView = @"authorHeaderView";
        self.authorHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:authorView];
        //如果没有头视图
        if(!_authorHeaderView){
            _authorHeaderView = [[ZZTAuthorHeaderView alloc] initWithReuseIdentifier:authorView];
        }
        _authorHeaderView.userModel = self.author;
        return _authorHeaderView;
    }else{
        if(self.isHasComment){
            //显示占位图
            ZZTCommentAirView *airHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:airView];
            //如果没有头视图
            if(!airHeaderView){
                airHeaderView = [[ZZTCommentAirView alloc] initWithReuseIdentifier:airView];
            }
            [self.tableView.mj_footer setHidden:YES];
            return airHeaderView;
        }else{
            //评论
            ZZTCircleModel *model = self.commentArray[section - 3];
            self.statusCell = [[ZZTStatusCell alloc] initWithReuseIdentifier:statusHeaderReuseIdentifier];
            self.statusCell.delegate = self;
            model.indexRow = section - 3;
            self.statusCell.model = model;
            return _statusCell;
        }
    }
}

#pragma mark - FooterView
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if(section == 0){
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
    }else if(section == 1){
        //上下篇
        static NSString *nextWordViewIdentfier = @"nextWordView";
        _nextWordView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:nextWordViewIdentfier];
        //如果没有头视图
        if(!_nextWordView){
            _nextWordView = [[ZZTNextWordHeaderView alloc] initWithReuseIdentifier:nextWordViewIdentfier];
        }
        [_nextWordView.rightBtn addTarget:self action:@selector(nextWordWithBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_nextWordView.rightBtn setTag:2];
        [_nextWordView.leftBtn addTarget:self action:@selector(nextWordWithBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_nextWordView.leftBtn setTag:1];
        _nextWordView.listTotal = self.listTotal;
        _nextWordView.chapterModel = self.dataModel;
        return _nextWordView;
    }else if (section == 2){
        //精彩点评
        ZZTCommentHeadView *commentHeadView = [[ZZTCommentHeadView alloc] init];
        commentHeadView.backgroundColor = [UIColor whiteColor];
        return commentHeadView;
    }else{
        if(self.isHasComment){
            UIView *footerView = [[UIView alloc] init];
            return footerView;
        }else{
            static NSString *statusFooterView = @"statusFooterView";
            ZZTStatusFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:statusFooterView];
            if(!footerView){
                footerView = [[ZZTStatusFooterView alloc] initWithReuseIdentifier:statusFooterView];
            }
//            footerView.isFind = NO;
            footerView.delegate = self;
            footerView.update = ^{
                //更新评论数据
          
                    [self loadCommentData];

            };
            footerView.bookId = self.cartoonModel.id;
            ZZTCircleModel *model = self.commentArray[section - 3];
            footerView.model = model;
            return footerView;
        }
    }
}

//设置高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    if(section == 2 && self.commentArray.count > 0){
//    if(self.commentArray.count > 0){
//        ZZTCircleModel *item = self.commentArray[section - 2];
//        return item.footerHeight;
//    }else
    if(section == 0){
        return 0;
    }else if (section == 1){
        return SCREEN_HEIGHT * 0.12;
    }else if (section == 2){
        return 40;
    }else{
        return 30;
    }
}

#pragma mark - ZZTNextWordHeaderView target
-(void)nextWordWithBtn:(UIButton *)btn{
    //上下
    NSString *upDown;
    //判断是漫画还是文章
    NSString *code = self.cartoonModel.type;
    //判断是上一篇 下一篇
    if(btn.tag == 1){
        upDown = @"2";
    }else{
        upDown = @"1";
    }
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    NSDictionary *dic = @{
                          @"cartoonId":self.cartoonModel.id,//书ID
                          @"chapterId":self.dataModel.chapterId,//章节ID
                          @"upDown":upDown,//1.下 2.上
                          @"code":code//1.漫画 2.章节
                          };
    [manager POST:[ZZTAPI stringByAppendingString:@"cartoon/getupDown"] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [[EncryptionTools alloc] decry:responseObject[@"result"]];
        if(dic){
            //准备跳转  --->   初始化数据源
//            [self.cartoonDetailArray removeAllObjects];
            self.cartoonDetailArray = nil;
            self.imageCellHeightCache = nil;
//            [self.headerMuArr removeAllObjects];
            self.headerMuArr = nil;
            self.commentArray = nil;
            self.tableView = nil;
            //获得内容id
            ZZTChapterlistModel *model = [ZZTChapterlistModel mj_objectWithKeyValues:dic];
            self.dataModel.id = model.id;
            //最近观看改一下
            self.dataModel.chapterPage = model.chapterPage;
            self.dataModel.chapterName = model.chapterName;
            self.dataModel.chapterId = model.chapterId;
            //清空当前存储的章节历史信息
            self.chapterModel = nil;
            //通过书id 找到这本书的id
            self.testModel = [self getJuXuYueDuModelWithBookId:self.cartoonModel.id];
            [self.navbar.centerButton setTitle:self.dataModel.chapterName forState:UIControlStateNormal];
            [self loadContent];
        }else{
            //显示错误信息
            [MBProgressHUD showError:@"已经没有章节"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(ZZTJiXuYueDuModel *)getJuXuYueDuModelWithBookId:(NSString *)bookId{
    NSMutableArray *arrayDict = [NSKeyedUnarchiver unarchiveObjectWithFile:JiXuYueDuAPI];
    if (arrayDict == nil) {
        arrayDict = [NSMutableArray array];
    }
    ZZTJiXuYueDuModel *model = [[ZZTJiXuYueDuModel alloc] init];
    for (int i = 0; i < arrayDict.count; i++) {
        //看这个数组里面的模型是否有这本书
        model = arrayDict[i];
        if([model.bookId isEqualToString:bookId]){
            self.model = model;
            break;
        }
    }
    return model;
}

//点赞
-(void)headerViewLike{
    if([[UserInfoManager share] hasLogin] == NO){
        [UserInfoManager needLogin];
        return;
    }
    UserInfo *user = [Utilities GetNSUserDefaults];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    NSDictionary *dic = @{
                          @"type":self.cartoonModel.type,
                              @"typeId":[NSString stringWithFormat:@"%ld",self.dataModel.id],
//                              @"typeId":self.cartoonModel.id,
                              @"userId":[NSString stringWithFormat:@"%ld",user.id],
                              @"cartoonId":self.cartoonModel.id
                          };
    [manager POST:[ZZTAPI stringByAppendingString:@"great/cartoonPraise"] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

//估算行高度
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //准确估算卡通高度
    if(indexPath.section == 0){
        if([self.cartoonModel.type isEqualToString:@"1"]){
            return [self.imageCellHeightCache[indexPath.row] doubleValue];
        }else{
            //估算文章高度
            ZZTStoryModel *model = self.cartoonDetailArray[indexPath.row];
            if(model.TXTContent.length > 300){
                return [self calculateStringHeight:model.TXTContent];
            }else{
                return 0;
            }
        }
    }else if(indexPath.section == 3){
        //恢复高度
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
            [self hideOrShowHeadView:needHide];
            [self hideOrShowBottomView:needHide];
        }else{
            needHide = YES;
            [self hideOrShowHeadView:needHide];
            [self hideOrShowBottomView:needHide];
        }
    }else{
        //没有登录
        if([[UserInfoManager share] hasLogin] == NO){
            [UserInfoManager needLogin];
            return;
        }
        //点击了评论cell  获取这条cell的信息
        ZZTCircleModel *model = self.commentArray[indexPath.section - 3];
        //第几条回复
        ZZTUserReplyModel *item = model.replyComment[indexPath.row];
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
}
#pragma mark 删除评论
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
    if([[UserInfoManager share] hasLogin] == NO){
        [UserInfoManager needLogin];
        return;
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *dict = @{
                           @"type":type,//节是1 cell是2
                               @"commentId":commentId
                           };
    [manager POST:[ZZTAPI stringByAppendingString:@"circle/deleteComment"] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self sendMessageSuccess];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
-(void)deleteCommentHeaderView:(ZZTCircleModel *)circleItem{
    UserInfo *user = [Utilities GetNSUserDefaults];
    if([circleItem.customer.id isEqualToString:[NSString stringWithFormat:@"%ld",user.id]]){
        [self deleteReplyActionView:@"1" comentId:circleItem.id];

    }
}

//隐藏navBar
- (void)hideOrShowHeadView:(BOOL)needhide{
    //隐藏状态bar
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    BOOL statusAlpha = needhide ? 0 : 1;
    self.statusBar = statusBar;
    statusBar.alpha = statusAlpha;
    
    //隐藏navbar
    CGFloat offset = needhide ? navHeight : 0;
    self.navbar.hide = needhide;
    
    if(needhide == YES){
        offset = -navHeight;
        [self.navbar mas_updateConstraints:^(MASConstraintMaker *make) {    //隐藏底部视图
            make.top.equalTo(self.view).offset(offset);
        }];
    }else{
        [self.navbar mas_updateConstraints:^(MASConstraintMaker *make) {    //隐藏底部视图
            make.top.equalTo(self.view).offset(offset);
        }];
    }
    //隐藏动画
    [UIView animateWithDuration:0.25 animations:^{
        [self.navbar layoutIfNeeded];
    }];
}
//隐藏底部评论
- (void)hideOrShowBottomView:(BOOL)needhide{
    if(needhide == YES){
        [self.kInputView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(50);
        }];
    }else{
        [self.kInputView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(0);
        }];
    }
    
    //隐藏动画
    [UIView animateWithDuration:0.25 animations:^{
        [self.kInputView layoutIfNeeded];
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].enable = YES;
    
    self.statusBar.alpha = 1;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self continueReading];
}

//继续浏览
-(void)continueReading{
    //继续阅读业务
    //获取已经存储的继续阅读数据
    NSMutableArray *arrayDict = [NSKeyedUnarchiver unarchiveObjectWithFile:JiXuYueDuAPI];
    if (arrayDict == nil) {
        arrayDict = [NSMutableArray array];
    }
    
    NSLog(@"arrayDict:%@",arrayDict);
    
    //直接存这本书
    //创建书模型
    ZZTJiXuYueDuModel *model = [[ZZTJiXuYueDuModel alloc] init];
    //书名
    model.bookName = _cartoonModel.bookName;
    //书ID
    model.bookId = _cartoonModel.id;    //判断那本书
    model.chapterListRow = [NSString stringWithFormat:@"%ld",self.indexRow];//位于第几章节第几行
    
    //章节模型 信息
    ZZTChapterModel *chapterModel = [[ZZTChapterModel alloc] init];
    
    if([self.cartoonModel.type isEqualToString:@"1"]){
        
        chapterModel = [ZZTChapterModel initCarttonChapter:self.dataModel.id chapterName:self.dataModel.chapterName autherData:self.author chapterPage:self.dataModel.chapterPage chapterIndex:self.indexRow readPoint:self.readPoint imageUrlArray:self.imageUrlArray imageHeightCache:self.imageCellHeightCache];
        
    }else{

        chapterModel = [ZZTChapterModel initTxtChapter:self.dataModel.id chapterName:self.dataModel.chapterName autherData:self.author chapterPage:self.dataModel.chapterPage chapterIndex:self.indexRow readPoint:self.readPoint TxTContent:self.TXTURL TXTFileName:self.fileName storyModel:self.stroyModel];
    }
    
    
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
        
        readModel.lastReadData = self.dataModel;

        readModel.chapterListRow = [NSString stringWithFormat:@"%ld",self.indexRow];
        [arrayDict replaceObjectAtIndex:arrayIndex withObject:readModel];
    }else{
        
        model.lastReadData = self.dataModel;

        [model.chapterArray addObject:chapterModel];
        [arrayDict addObject:model];
    }
 

    //存
    NSString *path = JiXuYueDuAPI;
    [NSKeyedArchiver archiveRootObject:arrayDict toFile:path];
}

//继续阅读本地文件
-(void)setTestModel:(ZZTJiXuYueDuModel *)testModel{
    _testModel = testModel;
    if(testModel){
        self.isJXYD = YES;//是否继续阅读
        self.model = testModel;
        if(self.model.chapterArray.count > 0){
            //通过比对id 得到当前这本书的历史数据
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
//滑动时候 隐藏视图的逻辑
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGRect sectionRect = [self.tableView rectForSection:1];
    CGPoint readPoint = CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y);
    _readPoint = readPoint;
    //到顶部显示
    if(scrollView.contentOffset.y <= 64){
        needHide = NO;
    }else if (scrollView.contentOffset.y >= sectionRect.origin.y - SCREEN_HEIGHT / 2){
        needHide = NO;
    }else{
        needHide = YES;
    }
    [self hideOrShowHeadView:needHide];
    [self hideOrShowBottomView:needHide];
    
    self.isNavHide = needHide;
}
//章节 位于章节列表的索引
-(void)setIndexRow:(NSInteger)indexRow{
    _indexRow = indexRow;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    NSLog(@"width:%f",[UIScreen mainScreen].bounds.size.width);
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    self.navigationController.navigationBar.alpha = 0;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

#pragma mark - SectionHeaderViewDelegate
- (void)spreadContent:(BOOL)isSpread section:(NSUInteger)section{
    ZZTCircleModel *item = self.commentArray[section - 3];
    item.isSpread = isSpread;
    item.headerHeight = [[FriendCircleViewModel new] getHeaderHeight:item];
    [self.tableView reloadData];
}

-(void)didCommentLabelReply:(NSInteger)section{
    ZZTCircleModel *item = self.commentArray[section];
    
    self.commentId = item.id;
    //找到回复人了
    self.isReply = YES;
    //判断是评论还是回复
    self.isCommentOrReply = @"1";
    
    self.nowReplyModel = item;
    
    UserInfo *user = [Utilities GetNSUserDefaults];
    
    if([item.customer.id isEqualToString:[NSString stringWithFormat:@"%ld",user.id]]){
        item.customer.id = @"0";
    }
    
    self.replyer = item.customer;
    
    //弹出键盘
    [self startComment];
}

-(void)didClickLikeButton:(NSInteger)section{
    if([[UserInfoManager share] hasLogin] == NO){
        [UserInfoManager needLogin];
        return;
    }
    UserInfo *user = [Utilities GetNSUserDefaults];
    ZZTCircleModel *item = self.commentArray[section];
    NSDictionary *dic = @{
                          @"userId":[NSString stringWithFormat:@"%ld",user.id],
                          @"type":@"3",
                          @"typeId":item.id,
                          @"cartoonId":self.cartoonModel.id
                          };
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    [manager POST:[ZZTAPI stringByAppendingString:@"great/cartoonPraise"]  parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

#pragma mark cartCell代理
-(void)cellHeightUpdataWithIndex:(NSUInteger)index Height:(CGFloat)height{
    //走到这里说明第一次图片第一次来   记录高度
    if(isnan(height)){
        height = 500;
    }
    NSNumber *newHeight = [NSNumber numberWithDouble:height];
    NSLog(@"imageCellHeightCacheCount:%lu,index:%lu",(unsigned long)self.imageCellHeightCache.count,(unsigned long)index);
    
    if(newHeight > 0){
        if(index <= self.imageCellHeightCache.count){
            [self.imageCellHeightCache replaceObjectAtIndex:index withObject:newHeight];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }
    }
    

}

-(void)updataStoryCellHeight:(NSString *)story index:(NSUInteger)index{
    self.stroyModel.TXTContent = story;
    [self.cartoonDetailArray replaceObjectAtIndex:index withObject:self.stroyModel];
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

    if([textView.text isEqualToString:@"赶紧评论秀才华~"]){
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
        textView.text = @"赶紧评论秀才华~";
        textView.textColor = [UIColor grayColor];
    }
}

#pragma mark 评论发布
-(void)sendMessage{
    if([[UserInfoManager share] hasLogin] == NO){
        [UserInfoManager needLogin];
        return;
    }
    if (_kTextView.text.length == 0 || [_kTextView.text isEqualToString:@"请输入评论"]) {
        [MBProgressHUD showError:@"请输入评论再发布"];
        return;
    }
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
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
            [self sendMessageSuccess];

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }else{
        [MBProgressHUD showMessage:@"正在发布..." toView:self.view];
        NSDictionary *dic = @{
                              @"userId":[NSString stringWithFormat:@"%ld",user.id],
                              @"chapterId":[NSString stringWithFormat:@"%ld",self.dataModel.id],
                              @"type":self.cartoonModel.type,
                              @"content":self.kTextView.text
                              };
        [manager POST:[ZZTAPI stringByAppendingString:@"cartoon/insertComment"] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self sendMessageSuccess];
            //关闭键盘
            //如果字数小于0 不能发布
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
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

    
//    [self.tableView reloadData];
    
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)shareWithSharePanel{
    if([[UserInfoManager share] hasLogin] == NO){
        [UserInfoManager needLogin];
        return;
    }
//    UIImage *imageView = [[TJLongImgCut manager] screenShotForTableView:self.tableView screenRect:UIEdgeInsetsMake(0, 0, 88, 40) imageKB:1024 * 10];//获取图片小于等于1M
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *path = [paths objectAtIndex:0];
//    NSString *filePath = [path stringByAppendingPathComponent:@"imageView.png"];
//    NSLog(@"filePath%@",filePath);
//    [UIImagePNGRepresentation(imageView) writeToFile:filePath atomically:YES];
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
    for (int row = 0; row < self.cartoonDetailArray.count; row++) {
        
        NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:row inSection:0];
        
        UIImage *cellScreenshot = [self.tableView screenshotOfCellAtIndexPath:cellIndexPath];
        
        if (cellScreenshot) [screenshots addObject:cellScreenshot];
    }
    
    UIImage *image = [UIImage verticalImageFromArray:screenshots];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:@"image.png"];
    NSLog(@"filePath%@",filePath);
    [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
    return image;
}

- (UIImage *)getImage:(UITableView *)cell
{
    UIImage* viewImage = nil;
    UITableView *scrollView = self.tableView;
    UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, scrollView.opaque, 0.0);
    {
        CGPoint savedContentOffset = scrollView.contentOffset;
        CGRect savedFrame = scrollView.frame;
        
        scrollView.contentOffset = CGPointZero;
        
        scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
        
        [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
        
        viewImage = UIGraphicsGetImageFromCurrentImageContext();
        
        scrollView.contentOffset = savedContentOffset;
        
        scrollView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:@"cellImage.png"];
    NSLog(@"filePath%@",filePath);
    [UIImagePNGRepresentation(viewImage) writeToFile:filePath atomically:YES];
    
    return viewImage;
}

#pragma mark 预加载
//当view开始减速的时候
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{   //预加载
    [self prefetchImagesForTableView:self.tableView];
}

//当view已经停止的时候
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{   //预加载
    if(!decelerate){
        [self prefetchImagesForTableView:self.tableView];
    }
}

-(void)prefetchImagesForTableView:(UITableView *)tableView{
    //获取显示出来的行
    NSArray *indexPaths = [self.tableView indexPathsForVisibleRows];
    //如果行为0 不继续执行
    if ([indexPaths count] == 0) return;
    //显示出来的第一行
    NSIndexPath *minimumIndexPath = indexPaths[0];
    //显示出来的最后一行
    NSIndexPath *maximumIndexPath = [indexPaths lastObject];
    //遍历
    for (NSIndexPath *indexPath in indexPaths)
    {   //得到最小行 和 最大行
        if (indexPath.section < minimumIndexPath.section || (indexPath.section == minimumIndexPath.section && indexPath.row < minimumIndexPath.row)) minimumIndexPath = indexPath;
        if (indexPath.section > maximumIndexPath.section || (indexPath.section == maximumIndexPath.section && indexPath.row > maximumIndexPath.row)) maximumIndexPath = indexPath;
    }
    
//  预加载的图片数组
    NSMutableArray *imageURLs = [NSMutableArray array];
    
//    indexPaths = [self tableView:tableView priorIndexPathCount:3 fromIndexPath:minimumIndexPath];
    
//    for (NSIndexPath *indexPath in indexPaths){
//        ZZTCartoonModel *model = self.cartoonDetailArray[indexPath.row];
//        [imageURLs addObject:model];
//    }
    
    //获取下面的行数
    indexPaths = [self tableView:tableView nextIndexPathCount:6 fromIndexPath:maximumIndexPath];
    
    for (NSIndexPath *indexPath in indexPaths){
        if(indexPath.section == 0){
            ZZTCartoonModel *model = self.cartoonDetailArray[indexPath.row];
            [imageURLs addObject:model.cartoonUrl];
        }
    }
    
    // now prefetch
    if ([imageURLs count] > 0)
    {
        [[SDWebImagePrefetcher sharedImagePrefetcher] prefetchURLs:imageURLs];
    }
}

- (NSArray *)tableView:(UITableView *)tableView priorIndexPathCount:(NSInteger)count fromIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *indexPaths = [NSMutableArray array];
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    for (NSInteger i = 0; i < count; i++) {
        //如果是第一行不再进行
        if (row == 0) {
            if (section == 0) {
                return indexPaths;
            } else {
                //如果不是第一节
                section--;
                row = [tableView numberOfRowsInSection:section] - 1;
            }
        } else {
            row--;
        }
        [indexPaths addObject:[NSIndexPath indexPathForRow:row inSection:section]];
        NSLog(@"priorIndexPathCount:%ld row:%ld",section,row);
    }
    return indexPaths;
}

//获取下行的数据索引
- (NSArray *)tableView:(UITableView *)tableView nextIndexPathCount:(NSInteger)count fromIndexPath:(NSIndexPath *)indexPath
{
    //创建数组
    NSMutableArray *indexPaths = [NSMutableArray array];
    //第几行
    NSInteger row = indexPath.row;
    //第几节
    NSInteger section = indexPath.section;
    //这一节有多少行
    NSInteger rowCountForSection = [tableView numberOfRowsInSection:section];
    //需要获取几行数据
    for (NSInteger i = 0; i < count; i++) {
        //下一行
        row++;
        //如果row是最后一行
        if (row == rowCountForSection) {
            return indexPaths;
        }
        [indexPaths addObject:[NSIndexPath indexPathForRow:row inSection:section]];
        NSLog(@"nextIndexPathCount:%ld row:%ld",section,row);
    }
    return indexPaths;
}

#pragma mark lazyLoad
- (ZZTAuthorHeaderView *)authorHeaderView{
    if(!_authorHeaderView){
        _authorHeaderView = [[ZZTAuthorHeaderView alloc] initWithFrame:CGRectZero];
    }
    return _authorHeaderView;
}

-(ZZTNextWordHeaderView *)nextWordView{
    if(!_nextWordView){
        _nextWordView= [[ZZTNextWordHeaderView alloc] initWithFrame:CGRectZero];
        [_nextWordView.rightBtn addTarget:self action:@selector(nextWordWithBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_nextWordView.rightBtn setTag:2];
        [_nextWordView.leftBtn addTarget:self action:@selector(nextWordWithBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_nextWordView.leftBtn setTag:1];
    }
    return _nextWordView;
}

//-(ZZTLikeCollectShareHeaderView *)likeCollectView{
//    if(_likeCollectView){
//        _likeCollectView = [[ZZTLikeCollectShareHeaderView alloc] initWithFrame:CGRectZero];
//    }
//    return _likeCollectView;
//}

-(UITableView *)tableView{
    if(!_tableView){
        //先把漫画显示出来
        _tableView= [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.contentInset = UIEdgeInsetsMake(navHeight - 20,0,50,0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[ZZTCartoonContentCell class] forCellReuseIdentifier:CartoonContentCellIdentifier];
        _tableView.showsVerticalScrollIndicator = YES;
        [self.view addSubview:_tableView];
        
        [self loadViewIfNeeded];
        
        _tableView.pagingEnabled = NO;
        //评论
        //注册cell
        [self.tableView registerClass:[CircleCell class] forCellReuseIdentifier:kCellId];
        [self.tableView registerClass:[ZZTStoryDetailCell class] forCellReuseIdentifier:story];
        
        self.tableView.tableFooterView = [UIView new];
        [self.view bringSubviewToFront:self.navbar];
        [self.view bringSubviewToFront:self.kInputView];
    }
    return _tableView;
}

-(void)headerViewCollect{
    //没有登录
    if([[UserInfoManager share] hasLogin] == NO){
        [UserInfoManager needLogin];
        return;
    }
    UserInfo *userInfo = [Utilities GetNSUserDefaults];
    NSDictionary *dic = @{
                          @"cartoonId":_cartoonModel.id,
                          @"userId":[NSString stringWithFormat:@"%ld",userInfo.id]
                          };
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    [manager POST:[ZZTAPI stringByAppendingString:@"great/collects"] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

    }];
}

- (ZZTStatusCell *)statusCell {
    if (!_statusCell) {
        
        _statusCell = [[ZZTStatusCell alloc] initWithFrame:CGRectZero];
        _statusCell.backgroundColor = [UIColor clearColor];
        
    }
    return _statusCell;
}

-(void)StatusFooterView:(ZZTStatusFooterView *)StatusFooterView didClickCommentButton:(ZZTCircleModel *)model{
    if([[UserInfoManager share] hasLogin] == NO){
        [UserInfoManager needLogin];
        return;
    }
    [self didCommentLabelReply:model.indexRow];
}

@end
