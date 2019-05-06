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
#import "ZZTChapterlistModel.h"
#import "ZZTCarttonDetailModel.h"
#include <sys/time.h>
#import "CircleCell.h"
#import "ZZTUserReplyModel.h"
#import "FriendCircleViewModel.h"
#import "ZZTChapterModel.h"
#import "ZZTNextWordHeaderView.h"
#import "UITableView+ZFTableViewSnapshot.h"
#import "ZZTLikeCollectShareHeaderView.h"
#import "ZZTAuthorHeaderView.h"
#import "ZZTCommentAirView.h"
#import "ZZTCommentViewController.h"
#import "ZZTStatusCell.h"
#import "ZZTStatusFooterView.h"
#import "ZZTStoryModel.h"
#import "ZZTChapterPayViewController.h"
#import "ZZTCartoonDetailRightBtnView.h"
#import "ZZTCartInfoModel.h"
#import "ZZTTextFiledView.h"


@interface ZZTCartoonDetailViewController ()<UITableViewDelegate,UITableViewDataSource,CircleCellDelegate,ZZTCommentHeaderViewDelegate,UITextViewDelegate,NSURLSessionDataDelegate,ZZTCartoonContentCellDelegate,ZZTStoryDetailCellDelegate,ZZTStatusCellDelegate,ZZTStatusFooterViewDelegate,ZZTReportBtnDelegate,ZZTChapterPayViewDelegate>

@property (nonatomic,strong) NSMutableArray *cartoonDetailArray;

@property (nonatomic,strong) NSMutableArray *commentArray;

@property (nonatomic,strong) NSArray *userLikeArray;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,assign) BOOL isNavHide;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,assign) BOOL isOnce;

@property (nonatomic,assign) BOOL isJXYD;

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
//右边btnView
@property (nonatomic,weak) ZZTCartoonDetailRightBtnView *rightBtnView;

@property (nonatomic,strong) ZZTContinueToDrawHeadView *xuhuaView;


@end

static NSString *CartoonContentCellIdentifier = @"CartoonContentCellIdentifier";

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

-(ZZTContinueToDrawHeadView *)xuhuaView{
    if(_xuhuaView == nil){
        _xuhuaView = [ZZTContinueToDrawHeadView ContinueToDrawHeadView];
   
    }
    return _xuhuaView;
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

    self.commentId = @"0";
    
    self.navigationController.navigationBar.translucent = NO;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //显示
    self.isNavHide = NO;
    
#warning 待改
    
    self.isOnce = NO;
    
    if(self.JXYDModel){
        self.isOnce = YES;
    }

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
    
    //右下边按钮
    [self setupRightBtn];
    
    //自定义导航栏
    [self setupNavigationBar];
    
    //键盘输入框
    [self addInputView];
    
    //监听键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenKeyboard) name:UIKeyboardWillHideNotification object:nil];
    
}

-(void)hiddenKeyboard{
    self.isReply = NO;
    self.commentId = @"0";
}

#pragma mark - 右边操作按钮
-(void)setupRightBtn{
    ZZTCartoonDetailRightBtnView *rightBtnView = [[ZZTCartoonDetailRightBtnView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50, SCREEN_HEIGHT / 2, 50, 240)];
    _rightBtnView = rightBtnView;
    //数据传进来
    //收藏
    _rightBtnView.collectStatus = _bookData.ifCollect;
    //是否关注作者
    _rightBtnView.attentionStatus = _bookData.ifauthor;
    //点赞
    weakself(self);
    _rightBtnView.collectBtnBlock = ^(NSInteger tag) {
        [weakSelf headerViewCollect:tag];
    };
    
    _rightBtnView.likeBtnBlock = ^{
        [weakSelf headerViewLike];
    };
    
    _rightBtnView.attentionBtnBlock = ^{
        [weakSelf addAuthorAttention];
    };
    
    [self.view addSubview:rightBtnView];
}

#pragma mark - 作者关注
-(void)addAuthorAttention{
    NSDictionary *dict = @{
                        @"userId":SBAFHTTPSessionManager.sharedManager.userID,
                           @"authorId":[NSString stringWithFormat:@"%ld",self.author.id]
                           };
    [SBAFHTTPSessionManager.sharedManager loadPostRequest:@"record/ifUserAtAuthor" paramDict:dict finished:^(id responseObject, NSError *error) {
        
    }];
}

-(void)chapterPayViewDismissLastViewController{

    [self.navigationController popViewControllerAnimated:YES];

}

-(void)setupMJRefresh{
    
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
    
    //显示评论页面
    ZZTCommentViewController *commentView = [[ZZTCommentViewController alloc] init];
    ZZTNavigationViewController *nav = [[ZZTNavigationViewController alloc] initWithRootViewController:commentView];

    commentView.chapterId = [NSString stringWithFormat:@"%ld",self.chapterData.id];
    commentView.cartoonType = self.bookData.type;
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
                                  @"itemId":[NSString stringWithFormat:@"%ld",self.chapterData.id],
                                  @"type":self.bookData.type,
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

    [self.viewNavBar setBackgroundColor:[UIColor colorWithRed:0.0 green:0 blue:0 alpha:0.5]];
    
    [self.view bringSubviewToFront:self.viewNavBar];
    
    //返回
    [self.viewNavBar.leftButton setImage:[UIImage imageNamed:@"navigationbarBack"] forState:UIControlStateNormal];
    self.viewNavBar.leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 17);
    
    //中间
    [self.viewNavBar.centerButton setTitle:[NSString stringWithFormat:@"%@第%@",_bookData.bookName,self.chapterData.chapterName] forState:UIControlStateNormal];
    [self.viewNavBar.centerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.viewNavBar.rightButton setImage:[UIImage imageNamed:@"cartoonDetail_share"] forState:UIControlStateNormal];
    [self.viewNavBar.rightButton addTarget:self action:@selector(shareWithSharePanel) forControlEvents:UIControlEventTouchUpInside];
    self.viewNavBar.showBottomLabel = NO;
}

//取消多余字符
- (NSString *)getZZwithString:(NSString *)string{
    
    NSRegularExpression *regularExpretion = [NSRegularExpression regularExpressionWithPattern:@"<[^>]*>|\n" options:0 error:nil];
    
    string = [regularExpretion stringByReplacingMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length) withTemplate:@""];
    
    return string;
}

#pragma mark - 输入View
- (void)addInputView {
    ZZTTextFiledView *textFiledView = [[ZZTTextFiledView alloc] init];
    [self.view addSubview:textFiledView];
    
    self.kInputView = textFiledView;
    
    _kTextView = textFiledView.kTextView;
    
    [textFiledView.publishBtn addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    
    [textFiledView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(50);
        make.right.left.bottom.equalTo(self.view);
    }];
}

-(void)likeBtnTaget{
    if([[UserInfoManager share] hasLogin] == NO){
        [UserInfoManager needLogin];
        return;
    }
    [MBProgressHUD showSuccess:@"点赞成功" toView:self.view];
  
    [self headerViewLike];

    //点赞完了以后 重新请求一次获取点赞的接口  刷新点赞图标
 
    [self loadLikeDataWithCartoonId:_bookData.id];
}

#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(self.commentArray.count > 0){
        return self.commentArray.count + 4;
    }else{
        return 4;//有问题
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return self.cartoonDetailArray.count;
            break;
        case 1 : case 2 : case 3:
            return 0;
            break;
        default:{
            ZZTCircleModel *model = self.commentArray[section - 4];

            return _isHasComment?0:model.replyComment.count;
            }
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if(indexPath.section == 0){
        //漫画   是这里的数据
        if([self.bookData.type isEqualToString:@"1"]){
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
            return cell;
        }
    }else{
        //回复cell
        ZZTCircleModel *model = self.commentArray[indexPath.section - 4];
        CircleCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId forIndexPath:indexPath];
        [cell setContentData:model index:indexPath.row];
        cell.delegate = self;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        //漫画高度
        if([self.bookData.type isEqualToString:@"1"]){
            return [self.imageCellHeightCache[indexPath.row] doubleValue];
        }else{
            //小说高度
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

    [self loadLikeDataWithCartoonId:_bookData.id];
    //显示作者信息
    self.authorHeaderView.userModel = self.author;
    //没有本地连接
//    if(!self.chapterModel.TXTFileName){
        //下载地址
//        [self downloadTxT];
//    }else{
//            [self.tableView reloadData];
//    }
    [self.tableView reloadData];

    //请求同人章节数据
    [self loadMultiChapter];
}

#warning 上下页btn样式
//上下页btn样式
//-(void)loadUpDownBtnData{
//    AFHTTPSessionManager *manager = [SBAFHTTPSessionManager getManager];
//    NSDictionary *dic = @{
//                          @"cartoonId":self.cartoonModel.id,//书ID
//                          @"chapterId":self.dataModel.chapterId,//章节ID
//                          @"upDown":@"1",//1.下 2.上
//                          @"code":@"1"//1.漫画 2.章节
//                          };
//    [manager POST:[ZZTAPI stringByAppendingString:@"cartoon/getupDown"] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
////        NSDictionary *dic = [[EncryptionTools alloc] decry:responseObject[@"result"]];
////        NSLog(@"dic:%@",dic);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//    }];
//}

//-(void)downloadTxT{
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    // 1. 创建会话管理者
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
//    // 2. 创建下载路径和请求对象
//    NSURL *URL = [NSURL URLWithString:self.TXTURL]; NSURLRequest *request = [NSURLRequest requestWithURL:URL];
//    // 3.创建下载任务 /** * 第一个参数 - request：请求对象 * 第二个参数 - progress：下载进度block * 其中： downloadProgress.completedUnitCount：已经完成的大小 * downloadProgress.totalUnitCount：文件的总大小 * 第三个参数 - destination：自动完成文件剪切操作 * 其中： 返回值:该文件应该被剪切到哪里 * targetPath：临时路径 tmp NSURL * response：响应头 * 第四个参数 - completionHandler：下载完成回调 * 其中： filePath：真实路径 == 第三个参数的返回值 * error:错误信息 */
//    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
//
//        //保存的文件路径
//        NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
//
////        NSLog(@"response:%@",response.suggestedFilename);
//
//        return [NSURL fileURLWithPath:fullPath];
//
//    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
////        NSLog(@"File downloaded to: %@", filePath.path);
//        //把response的文件名
//        self.fileName = filePath.path;
//    }];
//    // 4. 开启下载任务
//    [downloadTask resume];
//}

//把请求单独的抽出来
-(void)loadContentData{

    if([self.bookData.type isEqualToString:@"1"]){
        //漫画  曾经阅读
        if(self.chapterModel.imageUrlArray.count > 0){
            self.cartoonDetailArray = self.chapterModel.imageUrlArray;
            self.imageUrlArray = self.cartoonDetailArray;
            self.author = self.chapterModel.autherData;
            [self reloadCellWithIndex];
        }else{
            //加载内容信息
            [SBAFHTTPSessionManager.sharedManager loadCartoonContentData:@"cartoon/getCartoonCenter" id:[NSString stringWithFormat:@"%ld",_chapterData.id] finished:^(id responseObject, NSError *error) {
                if(error != nil){
                    NSLog(@"%@",error);
                    return;
                }
                self.cartoonDetailArray = nil;
                self.imageUrlArray = nil;

                NSArray *dataArray = [[EncryptionTools alloc] getDecryArray:responseObject[@"result"]];
                if(dataArray.count > 0){
                    NSMutableArray *cartArray = [ZZTCartoonModel mj_objectArrayWithKeyValuesArray:dataArray[0][@"list"]];
                    //作者名字 信息
                    UserInfo *author = [UserInfo mj_objectWithKeyValues:dataArray[1]];
                    self.cartoonDetailArray = cartArray;
                    self.imageUrlArray = cartArray;
                    self.author = author;
                }
                [self reloadCellWithIndex];
            }];
        }
    }
//    else{
//        if(self.chapterModel.TXTFileName){
//
//            ZZTStoryModel *model = [[ZZTStoryModel alloc] init];
//            model = self.chapterModel.storyModel;
//            model.content = self.chapterModel.TXTFileName;
//            [self.cartoonDetailArray addObject:model];
//            self.fileName = self.chapterModel.TXTFileName;
//            self.stroyModel = model;
//            self.author = self.chapterModel.autherData;
//            [self reloadCellWithIndex];

//        }else{
//            //章节
//            NSDictionary *paramDict = @{
//                                        @"chapterinfoId":[NSString stringWithFormat:@"%ld",_dataModel.id],
//                                        @"userId":[NSString stringWithFormat:@"%ld",user.id]
//                                        };
//            [manager POST:[ZZTAPI stringByAppendingString:@"cartoon/getChapterInfo"] parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                self.cartoonDetailArray = nil;
//                NSString *data = responseObject[@"result"];
//                NSDictionary *dic = [[EncryptionTools alloc] decry:data];
//                NSMutableArray *array = [ZZTStoryModel mj_objectArrayWithKeyValuesArray:dic];
//                self.cartoonDetailArray = array;
//                if(array.count > 0) {
//                    ZZTStoryModel *model = array[0];
//                    self.stroyModel = model;
//                    //下载文件的地址  为了缓存下载
//                    self.TXTURL = model.content;
//                    //作者信息
//                    UserInfo *userData = [UserInfo initAuthorWithUserId:model.userId headImg:model.headimg nikeName:model.nickName];
//                    self.author = userData;
//                }
//
//                [self reloadCellWithIndex];
//            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//            }];
//        }
//    }
}

-(void)loadLikeDataWithCartoonId:(NSString *)cartoonId{
    NSDictionary *likeDict = @{
                               @"chapterId":[NSString stringWithFormat:@"%ld",self.chapterData.id],
                            @"userId":SBAFHTTPSessionManager.sharedManager.userID
                               };
    [SBAFHTTPSessionManager.sharedManager loadPostRequest:@"cartoon/getChapterPraise" paramDict:likeDict finished:^(id responseObject, NSError *error) {
        if(error != nil){
            NSLog(@"%@",error);
            return;
        }
        NSDictionary *dic = [[EncryptionTools alloc] decry:responseObject[@"result"]];
        self.likeModel = [ZZTStoryModel mj_objectWithKeyValues:dic];
        self.likeCollectView.likeModel = self.likeModel;
        //右边点赞状态
        self.rightBtnView.likeStatus = self.likeModel.ifpraise;
        [self.tableView reloadData];
    }];
}

-(void)loadCommentData{
    _isHasComment = NO;
    
    [SBAFHTTPSessionManager.sharedManager loadCartoonCommentData:@"cartoon/cartoonComment" chapterId:[NSString stringWithFormat:@"%ld",self.chapterData.id] type:self.bookData.type finished:^(NSDictionary *commentDict, NSError *error) {
        if(error != nil){
            NSLog(@"%@",error);
            return;
        }
        self.commentArray = nil;
        NSMutableArray *array1 = [ZZTCircleModel mj_objectArrayWithKeyValuesArray:commentDict];
        if(array1.count == 0){
            //没有数据的时候
            [self.commentArray addObject:@"1"];
            self.isHasComment = YES;
        }else{
            //外面的数据
            FriendCircleViewModel *circleViewModel = [[FriendCircleViewModel alloc] init];
            circleViewModel.circleModelArray = array1;
            self.commentArray = [circleViewModel loadDatas];
        }
        //加工一下评论的数据
        [self.tableView reloadData];
    }];
}

-(void)loadAuthorData{
    if(![self.bookData.type isEqualToString:@"1"]){
        UserInfo *user = [[UserInfo alloc] init];
        user.headimg = self.stroyModel.headimg;
        user.nickName = self.stroyModel.nickName;
        user.id = self.stroyModel.id;
        user.userId = self.stroyModel.userId;
        self.author = user;
        return;
    }
}

-(void)loadMultiChapter{
    [SBAFHTTPSessionManager.sharedManager loadMultiChapterData:self.bookData.id chapterId:self.chapterData.chapterId finished:^(id responseObject, NSError *error) {
        if(error != nil){
            NSLog(@"%@",error);
            return;
        }
        NSMutableArray *array = [ZZTChapterlistModel mj_objectArrayWithKeyValuesArray:responseObject];
        //赋数据
        self.xuhuaView.array = array;
//        //续画人数

//
        [self.tableView reloadData];
    }];
}
//下载txt
//-(void)downLoadTxt:(NSString *)txtUrl{
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
//}

//json字符串转化成OC键值对
//- (id)jsonStringToKeyValues:(NSString *)JSONString {
//    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary *responseJSON = nil;
//    if (JSONData) {
//        responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableContainers error:nil];
//    }
//    return responseJSON;
//}

//设置有关章节的数据
-(void)setChapterData:(ZZTChapterlistModel *)chapterData{
    _chapterData = chapterData; // 你的问题在哪里  是没有数据还是数据错乱
    //设置总数 方便进行下一页判断
    self.listTotal = chapterData.listTotal;
}

//请求数据后显示那一行
-(void)reloadCellWithIndex{
    if(self.isJXYD){

        CGFloat y = self.chapterModel.readPoint.y;
        
        [self.tableView setContentOffset:CGPointMake(0 , y) animated:NO];

    }
    [self.tableView layoutIfNeeded];
    
    [self.tableView reloadData];
}

#pragma mark UITableViewDataSource 头高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return SCREEN_HEIGHT * 0.14;
            break;
        case 1:
            return SCREEN_HEIGHT * 0.124;
            break;
        case 2:
            return 130;
            break;
        case 3:
            return 40;
            break;
        default:{
            ZZTCircleModel *model = self.commentArray[section - 4];
            return _isHasComment?196 * SCREEN_WIDTH / 360:model.headerHeight;
            }
            break;
    }
}

//添加头 ZZTCartoonDetailFoot
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
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
        likeCollectView.collectModel = self.bookData;
        weakself(self);
        //点赞
        likeCollectView.likeBtnBlock = ^{
            [weakSelf headerViewLike];
        };
        //收藏
        likeCollectView.collectBtnBlock = ^(NSInteger tag) {
            [weakSelf headerViewCollect:tag];
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
    }else if (section == 3){
        ZZTCommentHeadView *view = [[ZZTCommentHeadView alloc] init];
        return view;
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
            ZZTCircleModel *model = self.commentArray[section - 4];
            self.statusCell = [[ZZTStatusCell alloc] initWithReuseIdentifier:statusHeaderReuseIdentifier];
            self.statusCell.delegate = self;
            model.indexRow = section - 4;
            self.statusCell.model = model;
            [self.tableView.mj_footer setHidden:NO];
            return _statusCell;
        }
    }
}

#pragma mark - FooterView
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if(section == 0){
        //空白View
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
        self.nextWordView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:nextWordViewIdentfier];
//        //如果没有头视图
        if(!_nextWordView){
            _nextWordView = [[ZZTNextWordHeaderView alloc] initWithReuseIdentifier:nextWordViewIdentfier];
        }
        [_nextWordView.rightBtn addTarget:self action:@selector(nextWordWithBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_nextWordView.leftBtn addTarget:self action:@selector(nextWordWithBtn:) forControlEvents:UIControlEventTouchUpInside];
        _nextWordView.listTotal = self.listTotal;
        _nextWordView.chapterModel = self.chapterData;
        return _nextWordView;
    }else if (section == 2){
//        //同人创作
        weakself(self);
        self.xuhuaView.hidden = [_bookData.cartoonType isEqualToString:@"1"];
        _xuhuaView.xuHuaUserView.didUserItem = ^(ZZTChapterlistModel *xuHuaChapter) {
            //内容跳转  类似上下章
            [self reloadNewChapterCartoon:xuHuaChapter];
        };
        _xuhuaView.xuHuaBtnBlock = ^{
            
            [weakSelf.xuhuaView pushMultiCartoonEditorVC:[ZZTChapterlistModel initXuhuaModel:weakSelf.bookData chapterPage:weakSelf.chapterData.chapterPage chapterId:weakSelf.chapterData.chapterId]];
            
        };
        return _xuhuaView;
    }else if(section == 3){
        return [[UIView alloc] init];
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
            footerView.delegate = self;
            footerView.update = ^{
                //更新评论数据
                [self loadCommentData];
            };
            footerView.reportBtn.delegate = self;
            footerView.bookId = self.bookData.id;
            ZZTCircleModel *model = self.commentArray[section - 4];
            footerView.model = model;
            return footerView;
        }
    }
}

-(void)shieldingMessage:(NSInteger)index{
    ZZTCircleModel *model = self.commentArray[index];
    [self.commentArray removeObject:model];
    [self.tableView reloadData];
}

//设置高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    switch (section) {
        case 0: case 3:
            return 0.1;
            break;
        case 1:
            return SCREEN_HEIGHT * 0.12;
            break;
        case 2:
            return [self.bookData.cartoonType isEqualToString:@"1"]?0:146;
            break;
        default:
            return 30;
            break;
    }
}

#pragma mark - ZZTNextWordHeaderView target
-(void)nextWordWithBtn:(UIButton *)btn{
    
    [SBAFHTTPSessionManager.sharedManager loadUpDownData:@"cartoon/getupDown" cartoonId:self.bookData.id chapterId:self.chapterData.chapterId code:self.bookData.type authorId:self.author.id upDown:btn.tag finished:^(id  _Nullable responseObject, NSError *error) {
        [self continueReading];
        if(error != nil){
            NSLog(@"%@",error);
            return ;
        }
        NSDictionary *dic = [[EncryptionTools alloc] decry:responseObject[@"result"]];
        if(dic){
            //获得内容id
            ZZTChapterlistModel *chapterModel = [ZZTChapterlistModel mj_objectWithKeyValues:dic];
            chapterModel.nickName = self.chapterData.nickName;
            chapterModel.chapterType = self.chapterData.chapterType;
//            chapterModel.listTotal = _bookData.
            [self reloadNewChapterCartoon:chapterModel];
        }else{
            //显示错误信息
            [MBProgressHUD showError:@"已经没有章节"];
            [self.nextWordView changeBtnColorToGray:btn];
        }
        [self.tableView reloadData];
    }];
}

-(void)reloadNewChapterCartoon:(ZZTChapterlistModel *)model{
    self.chapterData = model;
    //准备跳转  --->   初始化数据源
    self.cartoonDetailArray = nil;
    self.imageCellHeightCache = nil;
    self.headerMuArr = nil;
    self.commentArray = nil;
    self.tableView = nil;
    //清空当前存储的章节历史信息
    self.chapterModel = nil;
    //通过书id 找到这本书的id
    self.JXYDModel =  [ContinueReadManager.sharedInstance getJuXuYueDuModelWithBookId:self.bookData.id];
    [self.viewNavBar.centerButton setTitle:self.chapterData.chapterName forState:UIControlStateNormal];
    [self loadContent];
    [self viewWillAppear:YES];
}

//点赞
-(void)headerViewLike{
    if([[UserInfoManager share] hasLogin] == NO){
        [UserInfoManager needLogin];
        return;
    }
    
    [SBAFHTTPSessionManager.sharedManager cartoonGiveGood:@"great/cartoonPraise" type:self.bookData.type typeId:[NSString stringWithFormat:@"%ld",self.chapterData.id] cartoonId:self.bookData.id finished:^(id  _Nullable responseObject, NSError *error) {
        [self loadLikeDataWithCartoonId:self.bookData.id];
    }];
}

//估算行高度
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //准确估算卡通高度
    if(indexPath.section == 0){
        if([self.bookData.type isEqualToString:@"1"]){
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //如果是其他的cell
    if(indexPath.section == 0 || indexPath.section == 1){
        //如果现在是隐藏状态
        needHide = needHide == YES ? NO: YES;
        [self hideOrShowHeadView:needHide];
        [self hideOrShowBottomView:needHide];
        
    }else{
        //没有登录
        if([[UserInfoManager share] hasLogin] == NO){
            [UserInfoManager needLogin];
            return;
        }
        //点击了评论cell  获取这条cell的信息
        ZZTCircleModel *model = self.commentArray[indexPath.section - 4];
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
    AFHTTPSessionManager *manager = [SBAFHTTPSessionManager getManager];
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
    
    self.viewNavBar.hide = needhide;
    
    self.viewNavBar.hidden = needHide;
    
    offset = needhide == YES? -navHeight : navHeight;
    
    //隐藏动画
    [UIView animateWithDuration:0.25 animations:^{
        [self.viewNavBar layoutIfNeeded];
    }];
    //隐藏右边按钮区
    self.rightBtnView.hidden = needhide;
}

//隐藏底部评论
- (void)hideOrShowBottomView:(BOOL)needhide{
    CGFloat offsetFloat = needhide == YES?50:0;
    
    [self.kInputView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(offsetFloat);
    }];
    
    //隐藏动画
    [UIView animateWithDuration:0.25 animations:^{
        [self.kInputView layoutIfNeeded];
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].enable = YES;
    
    self.statusBar.alpha = 1;
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self continueReading];
}

#pragma mark - 继续阅读
-(void)continueReading{
    //继续阅读业务
    //章节模型 信息
    ZZTChapterModel *chapterModel = [[ZZTChapterModel alloc] init];
    //漫画
    if([self.bookData.type isEqualToString:@"1"]){

        chapterModel = [ZZTChapterModel initJxydChapterModel:self.chapterData userData:self.author readPoint:self.readPoint imageUrlArray:self.imageUrlArray imageHeightCache:self.imageCellHeightCache];
        
    }else{

        chapterModel = [ZZTChapterModel initTxtChapter:self.chapterData.id chapterName:self.chapterData.chapterName autherData:self.author chapterPage:self.chapterData.chapterPage chapterIndex:self.indexRow readPoint:self.readPoint TxTContent:self.TXTURL TXTFileName:self.fileName storyModel:self.stroyModel];
    }
    
    NSInteger isHave = [ContinueReadManager.sharedInstance isHaveThisBook:_bookData];
    
    if(isHave >= 0){
        //替换
        /*
         1.新建章节信息
         2.书信息
         3.是否存在 存在第几位
         5.此章节信息
         */
        [ContinueReadManager.sharedInstance replaceReadedBookWithChapter:chapterModel bookModel:_bookData readedIndex:isHave chapterData:self.chapterData];
    }else{
        //添加
        /*
         1.新建章节信息
         2.书信息
         */
        [ContinueReadManager.sharedInstance addReadedBookWithChapter:self.chapterData bookModel:_bookData chapterModel:chapterModel];
        
    }

}

//处理继续阅读
-(void)setJXYDModel:(ZZTJiXuYueDuModel *)JXYDModel{
    _JXYDModel = JXYDModel;
    if(JXYDModel){
        self.isJXYD = YES;//是否继续阅读

        if(self.JXYDModel.chapterArray.count > 0){
            //通过比对id 得到当前这本书的历史数据
            for (int i = 0; i < self.JXYDModel.chapterArray.count; i++) {
                ZZTChapterModel *chapterModel = JXYDModel.chapterArray[i];
                if(chapterModel.chapterId == self.chapterData.id && [chapterModel.chapterType isEqualToString:self.chapterData.chapterType]){
                    self.chapterModel = chapterModel;
                    break;
                }
            }
        }
    }else{
        self.isJXYD = NO;
    }
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
        //到底部了
        needHide = NO;
    }else{
        //非底部
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
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    self.navigationController.navigationBar.alpha = 0;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    //是否购买 0没购买
    [self isPayCartoon];
}

//是否购买
-(void)isPayCartoon{
    if([_chapterData.ifbuy isEqualToString:@"0"] && _chapterData.ifrelease == 2){
        //        NSLog(@"没有购买 弹出界面");
        ZZTChapterPayViewController *CPVC = [[ZZTChapterPayViewController alloc] init];
        CPVC.delegate = self;
        CPVC.model = self.chapterData;
        ZZTNavigationViewController *nav = [[ZZTNavigationViewController alloc] initWithRootViewController:CPVC];
        nav.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:nav animated:YES completion:nil];
    }
}

#pragma mark - SectionHeaderViewDelegate
- (void)spreadContent:(BOOL)isSpread section:(NSUInteger)section{
    ZZTCircleModel *item = self.commentArray[section - 4];
    item.isSpread = isSpread;
    item.headerHeight = [[FriendCircleViewModel new] getHeaderHeight:item];
    [self.tableView reloadData];
}

//评论点赞
-(void)didClickLikeButton:(NSInteger)section{
    if([[UserInfoManager share] hasLogin] == NO){
        [UserInfoManager needLogin];
        return;
    }
    ZZTCircleModel *item = self.commentArray[section];
    
    [SBAFHTTPSessionManager.sharedManager cartoonGiveGood:@"great/cartoonPraise" type:@"3" typeId:item.id cartoonId:self.bookData.id finished:^(id  _Nullable responseObject, NSError *error) {
        
    }];
}

#pragma mark cartCell代理
-(void)cellHeightUpdataWithIndex:(NSUInteger)index Height:(CGFloat)height{
    //走到这里说明第一次图片第一次来   记录高度
    if(isnan(height)){
        height = 500;
    }
    NSNumber *newHeight = [NSNumber numberWithDouble:height];
    
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

#pragma mark 评论发布
-(void)sendMessage{
    if([[UserInfoManager share] hasLogin] == NO){
        [UserInfoManager needLogin];
        return;
    }
    if (_kTextView.text.length == 0 || [_kTextView.text isEqualToString:ZZTTextMindString]) {
        [MBProgressHUD showError:@"请输入评论再发布"];
        return;
    }
  
    if(self.isReply){
        NSDictionary *dict = @{
                               @"userId":SBAFHTTPSessionManager.sharedManager.userID,
                                   @"toUser":self.replyer.id,
                                   @"commentId":self.nowReplyModel.id,//节id
                                   @"replyId":self.commentId,//回复id
                                   @"replyType":self.isCommentOrReply,
                                   @"content":self.kTextView.text
                               };
        [SBAFHTTPSessionManager.sharedManager loadPostRequest:@"cartoon/insertReply" paramDict:dict finished:^(id responseObject, NSError *error) {
            if(error != nil){
                NSLog(@"%@",error);
                return;
            }
            self.commentId = @"0";
            [self sendMessageSuccess];
        }];
    }else{
        [MBProgressHUD showMessage:@"正在发布..." toView:self.view];
        NSDictionary *dic = @{
                              @"userId":SBAFHTTPSessionManager.sharedManager.userID,
                              @"chapterId":[NSString stringWithFormat:@"%ld",self.chapterData.id],
                              @"type":self.bookData.type,
                              @"content":self.kTextView.text
                              };
        [SBAFHTTPSessionManager.sharedManager loadPostRequest:@"cartoon/insertComment" paramDict:dic finished:^(id responseObject, NSError *error) {
            if(error != nil){
                NSLog(@"%@",error);
                return;
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self sendMessageSuccess];
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

    [self.kTextView setText:@""];
    
    self.kInputHeight = 50;
    
    [self hideKeyBoard];
}

- (void)dealloc {
    [self.kInputView removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 分享
-(void)shareWithSharePanel{
    if([[UserInfoManager share] hasLogin] == NO){
        [UserInfoManager needLogin];
        return;
    }
    [[ScreenShotManager manager] openSharePlatformWithbookDetail:self.bookData];
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
//        NSLog(@"priorIndexPathCount:%ld row:%ld",section,row);
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
        
        //按钮View提升到最前面来
        [self.view bringSubviewToFront:_rightBtnView];
        
        [self loadViewIfNeeded];
        
        _tableView.pagingEnabled = NO;
        //评论
        //注册cell
        [self.tableView registerClass:[CircleCell class] forCellReuseIdentifier:kCellId];
        [self.tableView registerClass:[ZZTStoryDetailCell class] forCellReuseIdentifier:story];
        
        self.tableView.tableFooterView = [UIView new];
        [self.view bringSubviewToFront:self.viewNavBar];
        [self.view bringSubviewToFront:self.kInputView];
    }
    return _tableView;
}

-(void)headerViewCollect:(NSInteger)tag{
    //没有登录
    if([[UserInfoManager share] hasLogin] == NO){
        [UserInfoManager needLogin];
        return;
    }
    UserInfo *userInfo = [Utilities GetNSUserDefaults];
    NSDictionary *dic = @{
                          @"cartoonId":_bookData.id,
                          @"userId":[NSString stringWithFormat:@"%ld",userInfo.id]
                          };
    AFHTTPSessionManager *manager = [SBAFHTTPSessionManager getManager];
    [manager POST:[ZZTAPI stringByAppendingString:@"great/collects"] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //成功后刷新
        NSDictionary *dic = [[EncryptionTools alloc] decry:responseObject[@"result"]];
//        NSLog(@"dic:%@",dic);
        //重新获取数据
        self.rightBtnView.rightCollectBtn.selected = tag?self.rightBtnView.rightCollectBtn.selected:!self.rightBtnView.rightCollectBtn.selected;
//
        NSMutableArray *array = [ZZTCartInfoModel mj_objectArrayWithKeyValuesArray:dic];
        if(array.count > 0){
            ZZTCartInfoModel *model = array[0];
            if([model.status isEqualToString:@"1"]){
                self.bookData.collectNum += 1;
            }else{
                self.bookData.collectNum -= 1;
            }
        }
        //关注
        
        [self.tableView reloadData];
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

@end
