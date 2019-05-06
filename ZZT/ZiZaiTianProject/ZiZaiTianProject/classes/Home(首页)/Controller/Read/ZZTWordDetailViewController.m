//
//  ZZTWordDetailViewController.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/8/22.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTWordDetailViewController.h"
#import "ZZTWordsDetailHeadView.h"
#import "ZZTWordDescSectionHeadView.h"
#import "ZZTWordListCell.h"
#import "ZZTChapterlistModel.h"
#import "ZZTCartoonDetailViewController.h"
#import "ZZTJiXuYueDuModel.h"
#import "ZZTCarttonDetailModel.h"
#import "ZZTChapterChooseView.h"
#import "ZZTChapterChooseModel.h"
#import "ZZTContinueToDrawHeadView.h"
#import "ZZTWordDetailBottomView.h"


@interface ZZTWordDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,ZZTChapterChooseViewDelegate>

@property (nonatomic,strong) ZZTWordsDetailHeadView *head;

@property (nonatomic,strong) ZZTWordDescSectionHeadView *descHeadView;

@property (nonatomic,strong) ZZTCarttonDetailModel *bookDetail;

@property (nonatomic,strong) UITableView *contentView;

@property (nonatomic,strong) NSMutableArray *wordList;

@property (nonatomic,strong) ZZTJiXuYueDuModel *contiReadBook;

@property (nonatomic,assign) BOOL isHave;

@property (nonatomic,strong)ZZTWordDetailBottomView *bottomView;

@property (nonatomic,assign) CGRect navigationFrame;

@property (nonatomic,assign) ZXDNavBar *navbar;

@property (nonatomic,strong) ZZTWordsDetailHeadView *wordDetailHeadView;

@property (nonatomic,strong) ZZTChapterChooseView *chapterChooseView;

@property (nonatomic,strong) dispatch_group_t group;

@property (nonatomic,assign) dispatch_queue_t q;

@property (nonatomic,assign) BOOL isFirstOpen;
//开始阅读
@property (nonatomic,strong) ZZTChapterlistModel *startReadData;
//继续阅读
@property (nonatomic,strong) ZZTChapterlistModel *lastReadData;
@property (nonatomic,strong) ZZTChapterlistModel *multiLastReadData;

//记录选择
@property (nonatomic,strong) NSString *chooseNum;
//同人创作
@property (nonatomic,strong) ZZTContinueToDrawHeadView *xuHuaView;

@end

NSString *zztWordListCell = @"zztWordListCell";

NSString *zztWordsDetailHeadView = @"zztWordsDetailHeadView";

@implementation ZZTWordDetailViewController

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

-(NSMutableArray *)wordList{
    if(!_wordList){
        _wordList = [NSMutableArray array];
    }
    return _wordList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fd_prefersNavigationBarHidden = YES;
    
    self.isHave = NO;
    //判断是不是第一次打开
    self.isFirstOpen = YES;

    self.view.backgroundColor = [UIColor whiteColor];
    
    //设置挡住tableView白色的view
//    [self setupShieldView];
    
    //设置顶部页面
    [self setupTopView];
    //设置底部View
    [self setupBottomView];
    //详情接口
//    [self loadDetailData];
    
    //自定义navigationBar
//    [self setupNavigationBar];
    
    [self hiddenViewNavBar];
    
    //请求同人章节
    [self loadMultiChapterData];
}

-(void)loadMultiChapterData{
    [SBAFHTTPSessionManager.sharedManager loadMultiChapterData:self.cartoonDetail.id chapterId:@"1" finished:^(id responseObject, NSError *error) {
        if(error != nil){
            NSLog(@"%@",error);
            return;
        }
        NSMutableArray *array = [ZZTChapterlistModel mj_objectArrayWithKeyValuesArray:responseObject];
        //赋数据
        self.xuHuaView.array = array;
        //续画人数
        self.wordDetailHeadView.xuHuaNum = array.count;
        
        [self.contentView reloadData];
    }];
}

//-(void)setupShieldView{
//    UIView *shieldView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 100)];
//    [shieldView setBackgroundColor:[UIColor colorWithRGB:@"121,105,212"]];
//    [self.view addSubview:shieldView];
//}

//-(void)setupNavigationBar{
//    ZXDNavBar *navbar = [[ZXDNavBar alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, TOPBAR_HEIGHT)];
//    self.navbar = navbar;
//    navbar.backgroundColor = [UIColor purpleColor];
//    [self.view addSubview:navbar];

//    //返回
//    [navbar.leftButton setImage:[UIImage imageNamed:@"navigationbarBack"] forState:UIControlStateNormal];
//    navbar.leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 17);

//    //中间
//    [navbar.centerButton setTitle:@" " forState:UIControlStateNormal];
//    [navbar.centerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [navbar.mainView setBackgroundColor:[UIColor colorWithRGB:@"121,105,212"]];
//
//    [navbar.rightButton setTitle:@"分享" forState:UIControlStateNormal];
//    [navbar.rightButton addTarget:self action:@selector(shareWithSharePanel) forControlEvents:UIControlEventTouchUpInside];
//
//    navbar.showBottomLabel = NO;
//}

#pragma mark - 设置底部View
-(void)setupBottomView{
    ZZTWordDetailBottomView *bottomView = [[ZZTWordDetailBottomView alloc] init];
    bottomView.frame = CGRectMake(0, SCREEN_HEIGHT - 70, SCREEN_WIDTH, 70);
    bottomView.backgroundColor = [UIColor clearColor];
    _bottomView = bottomView;
    [self.view addSubview:bottomView];
    
    weakself(self);
    //开始阅读
    bottomView.startRead = ^{
        [weakSelf startRead];
    };
    
    //继续阅读同人
    bottomView.lastMultiReadBook = ^{
        [weakSelf lastReadBook:weakSelf.multiLastReadData];
    };
    
    //继续阅读原版
    bottomView.lastReadBook = ^{
        [weakSelf lastReadBook:weakSelf.lastReadData];
    };
}

#pragma mark - 开始阅读
-(void)startRead{
    //章节数据
    self.startReadData.cartoonId = self.bookDetail.id;
    self.startReadData.listTotal = self.chapterChooseView.total;
    
    //跳页
    ZZTCartoonDetailViewController *cartoonDetailVC = [[ZZTCartoonDetailViewController alloc] init];
    //外部书内容
    cartoonDetailVC.chapterData = self.startReadData;
    cartoonDetailVC.hidesBottomBarWhenPushed = YES;
    cartoonDetailVC.bookData = self.bookDetail;

    [self.navigationController pushViewController:cartoonDetailVC animated:YES];
}

//继续阅读
-(void)lastReadBook:(ZZTChapterlistModel *)chapterData{
    //跳页
    ZZTCartoonDetailViewController *cartoonDetailVC = [[ZZTCartoonDetailViewController alloc] init];
    //外部书内容
    cartoonDetailVC.chapterData = chapterData;
    cartoonDetailVC.hidesBottomBarWhenPushed = YES;
    cartoonDetailVC.bookData = self.bookDetail;
    if(self.isHave == YES){
        cartoonDetailVC.JXYDModel = self.contiReadBook;
    }
    [self.navigationController pushViewController:cartoonDetailVC animated:YES];
}

-(void)setIsId:(BOOL)isId{
    _isId = isId;
}

//设置数据
-(void)setCartoonDetail:(ZZTCarttonDetailModel *)cartoonDetail{
    _cartoonDetail = cartoonDetail;
}

//请求该漫画的资料
-(void)loadtopData:(NSString *)ID{
    UserInfo *user = [Utilities GetNSUserDefaults];

    NSDictionary *paramDict = @{
                                @"id":ID,
                                @"userId":[NSString stringWithFormat:@"%ld",user.id]
                                };
    AFHTTPSessionManager *manager = [SBAFHTTPSessionManager getManager];
    EncryptionTools *tool = [[EncryptionTools alloc]init];
    [manager POST:[ZZTAPI stringByAppendingString:@"cartoon/particulars"] parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic1 = [tool decry:responseObject[@"result"]];
        //这里有问题 应该是转成数组 然后把对象取出
        ZZTCarttonDetailModel *mode = [ZZTCarttonDetailModel mj_objectWithKeyValues:dic1];
        
        self.bookDetail = mode;
        //是否完结
        self.chapterChooseView.serializeStatus = [mode.serialize integerValue];
//        [self.navbar.centerButton setTitle:mode.bookName forState:UIControlStateNormal];
        [self.contentView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

//目录
-(void)loadListData:(NSString *)ID pageNum:(NSString *)pageNum isFirst:(BOOL)isFirst{

    self.chooseNum = pageNum;
    NSDictionary *paramDict = @{
                                @"cartoonId":ID,
                                @"type":self.cartoonDetail.type,//1.漫画 剧本
                                @"cartoonType":self.cartoonDetail.cartoonType, //1 独创 2 众创
                                @"pageNum":pageNum,
                                @"pageSize":@"5",
                                @"userId":[NSString stringWithFormat:@"%ld",[Utilities GetNSUserDefaults].id]
                                };
    AFHTTPSessionManager *manager = [SBAFHTTPSessionManager getManager];
    EncryptionTools *tool = [[EncryptionTools alloc]init];
    [manager POST:[ZZTAPI stringByAppendingString:@"cartoon/getChapterlist"] parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic2 = [tool decry:responseObject[@"result"]];
        //这里有问题 应该是转成数组 然后把对象取出
        NSMutableArray *array = [ZZTChapterlistModel mj_objectArrayWithKeyValuesArray:dic2[@"list"]];
        self.wordList = array;
        
        [self setupPageBtnAndSaveData:array isFirst:isFirst];
        //总共的数量
        NSNumber *totalData = dic2[@"total"];
        self.chapterChooseView.total = [totalData integerValue];
        
     
        [self.contentView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

    }];
}

//设置底部页码 与 第一阅读的数据
-(void)setupPageBtnAndSaveData:(NSArray *)array isFirst:(BOOL)isFirst{
    //列表大于1 第一次
    if(array.count > 0 && isFirst == YES){
        ZZTChapterlistModel *model = array[0];
        //没有历史
        if(self.isHave == NO){
            NSString * btnShowText = [self.cartoonDetail.type isEqualToString:@"1"]?[NSString stringWithFormat:@"%@画",model.chapterPage]:[NSString stringWithFormat:@"%@",model.chapterName];
//            [self.pageBtn setTitle:btnShowText forState:UIControlStateNormal];
            //将开始阅读的内容 储存起来
            self.startReadData = model;
        }
    }
}

-(void)setupTopView{
    
    UITableView *contenView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStyleGrouped];
    contenView.backgroundColor = [UIColor clearColor];
    contenView.contentInset = UIEdgeInsetsMake(Height_TabbleViewInset,0,0,0);
    contenView.showsVerticalScrollIndicator = NO;
    contenView.delegate = self;
    contenView.dataSource = self;
    contenView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.contentView = contenView;
    contenView.sectionFooterHeight = 0.01;
    contenView.sectionHeaderHeight = 0.01;
    contenView.estimatedSectionHeaderHeight = 0;
    contenView.estimatedSectionFooterHeight = 0;
    contenView.estimatedRowHeight = 0;
    [contenView setSeparatorColor:[UIColor blueColor]];

    //先让数据显示
    [contenView registerClass:[ZZTWordListCell class] forCellReuseIdentifier:zztWordListCell];
    
    [contenView registerNib:[UINib nibWithNibName:@"ZZTWordsDetailHeadView" bundle:nil] forHeaderFooterViewReuseIdentifier:zztWordsDetailHeadView];
    
    [self.view addSubview:contenView];
}

-(void)shareWithSharePanel{
    if([[UserInfoManager share] hasLogin] == NO){
        [UserInfoManager needLogin];
        return;
    }
    
    [[ScreenShotManager manager] openSharePlatformWithbookDetail:self.bookDetail];
}

#pragma mark - 设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return 0;
    }else if (section == 1){
        return 0;
    }else{
        return self.wordList.count;
    }
}

#pragma mark - 内容设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZZTChapterlistModel *model = self.wordList[indexPath.row];
    model.type = self.cartoonDetail.type;
    ZZTWordListCell *cell = [tableView dequeueReusableCellWithIdentifier:zztWordListCell];
    cell.gotoCommentViewBlock = ^{
        //前往评论页
        ZZTCommentViewController *commentView = [[ZZTCommentViewController alloc] init];
        ZZTNavigationViewController *nav = [[ZZTNavigationViewController alloc] initWithRootViewController:commentView];
        commentView.model = model;
        [self presentViewController:nav animated:YES completion:nil];
    };
    cell.model = model;
    return cell;
}

//将阅读的数据传过去处理
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //章节数据
    ZZTChapterlistModel *model = self.wordList[indexPath.row];
    model.cartoonId = self.bookDetail.id;
    model.listTotal = self.chapterChooseView.total;

    [self lastReadBook:model];
}

-(void)loadAttention:(ZZTChapterlistModel *)model{
    if([[UserInfoManager share] hasLogin] == NO){
        [UserInfoManager needLogin];
        return;
    }
    NSDictionary *dic = @{
                          @"userId":[UserInfoManager share].ID,
                          @"authorId":model.userId
                          };

    AFHTTPSessionManager *manager = [SBAFHTTPSessionManager getManager];
    [manager POST:[ZZTAPI stringByAppendingString:@"record/ifUserAtAuthor"] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

#pragma mark - headerView
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 0){
        return [Utilities getBannerH];
    }else if(section == 1){
        //字符串
        return self.chapterChooseView.myHeight;
    }
    else{
        return 0.01;
    }
}

//设置头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section == 0){
        //封面
        self.wordDetailHeadView.detailModel = self.bookDetail;
        return self.wordDetailHeadView;
    }else if(section == 1){
        //正篇
        return self.chapterChooseView;
    }else{
        return nil;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    //设置简介到这里来
    if(section == 0){
        //作品简介
        self.descHeadView.desc = self.bookDetail.intro;
        return self.descHeadView;
    }else if (section == 1){
        //同人版本
        weakself(self);
        self.xuHuaView.lastReadModel = self.contiReadBook;
        self.xuHuaView.bookDetail = self.bookDetail;
        self.xuHuaView.hidden = [_cartoonDetail.cartoonType isEqualToString:@"1"];
        //点击跳转其他同人页
        self.xuHuaView.xuHuaUserView.didUserItem = ^(ZZTChapterlistModel *xuHuaChapter) {
            [weakSelf lastReadBook:xuHuaChapter];
        };
        //创建同人
        self.xuHuaView.xuHuaBtnBlock = ^{
            [weakSelf.xuHuaView pushMultiCartoonEditorVC:[ZZTChapterlistModel initXuhuaModel:weakSelf.cartoonDetail chapterPage:@"1" chapterId:@"1" ]];
        };
        return self.xuHuaView;
    }else{
        static NSString *viewIdentfier = @"footerView";
        SectionFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:viewIdentfier];
        return footerView;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 0){
        //字符串
        self.descHeadView.desc = self.bookDetail.intro;
        return self.descHeadView.myHeight;
    }else if (section == 1){
        //如果是独创
        if([_cartoonDetail.cartoonType isEqualToString:@"1"]){
            return 0;
        }
        return 146;
    }
    return 0.01;
}

#pragma mark 改变tableView的背景色
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if ([view isKindOfClass:[UITableViewHeaderFooterView class]]) {
        ((UITableViewHeaderFooterView *)view).backgroundView.backgroundColor = [UIColor whiteColor];
    }
}

#pragma mark - lazyLoad
- (ZZTChapterChooseView *)chapterChooseView{
    if(!_chapterChooseView){
        _chapterChooseView = [[ZZTChapterChooseView alloc] initWithFrame:self.view.bounds];
        _chapterChooseView.delegate = self;
        weakself(self);
        _chapterChooseView.needReloadHeight = ^{
            [weakSelf.contentView reloadData];
        };
//        _chapterChooseView.backgroundColor = [UIColor whiteColor];
    }
    return _chapterChooseView;
}

-(void)chapterChooseView:(ZZTChapterChooseView *)chapterChooseView didItemWithModel:(ZZTChapterChooseModel *)model{

        if(self.isId == YES){
            [self loadListData:self.cartoonDetail.id pageNum:[NSString stringWithFormat:@"%ld",model.APIPage] isFirst:NO];
        }else{
            [self loadListData:self.cartoonDetail.cartoonId pageNum:[NSString stringWithFormat:@"%ld",model.APIPage] isFirst:NO];
        }
}

- (ZZTWordDescSectionHeadView *)descHeadView {
    if (!_descHeadView) {
        _descHeadView = [[ZZTWordDescSectionHeadView alloc] initWithFrame:self.view.bounds];
        
        weakself(self);
        
        [_descHeadView setNeedReloadHeight:^{
            
            [weakSelf.contentView reloadData];
            
        }];
    }
    return _descHeadView;
}

- (ZZTWordsDetailHeadView *)wordDetailHeadView{
    if(!_wordDetailHeadView){
        _wordDetailHeadView = [ZZTWordsDetailHeadView wordsDetailHeadViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, wordsDetailHeadViewHeight) scorllView:nil];
        [_wordDetailHeadView.shareBtn addTarget:self action:@selector(shareWithSharePanel) forControlEvents:UIControlEventTouchUpInside];
        //收藏业务
        weakself(self);
        _wordDetailHeadView.buttonAction = ^(ZZTCarttonDetailModel *detailModel) {
            if([[UserInfoManager share] hasLogin] == NO){
                [UserInfoManager needLogin];
                return;
            }
            UserInfo *userInfo = [Utilities GetNSUserDefaults];
            NSDictionary *dic = @{
                                  @"cartoonId":detailModel.id,
                                  @"userId":[NSString stringWithFormat:@"%ld",userInfo.id]
                                  };
            AFHTTPSessionManager *manager = [SBAFHTTPSessionManager getManager];
            [manager POST:[ZZTAPI stringByAppendingString:@"great/collects"] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

                    if(self.isId == YES){
                        //上部分View
                        [weakSelf loadtopData:weakSelf.cartoonDetail.id];
                    }else{
                        [weakSelf loadtopData:weakSelf.cartoonDetail.cartoonId];
                    }

            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
        };
    }
    return _wordDetailHeadView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if([self.cartoonDetail.type isEqualToString:@"1"]){
        return SCREEN_HEIGHT * 0.25;
    }else{
        return 94;
    }
}

//详情
-(ZZTCarttonDetailModel *)bookDetail{
    if (!_bookDetail) {
        _bookDetail = [[ZZTCarttonDetailModel alloc] init];
    }
    return _bookDetail;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.navigationController.navigationBar.alpha = 0;

    _navigationFrame = self.navigationController.navigationBar.frame;

    //一进来就开始判断
    [self JiXuYueDuTarget];

    //请求数据
    [self loadData];
}

-(void)loadData{

     if(self.isId == YES){
         //上部分View
         [self loadtopData:self.cartoonDetail.id];
     }else{
         [self loadtopData:self.cartoonDetail.cartoonId];
     }

//    NSLog(@"sekf ppp :%@",self.chooseNum);
    if(self.isId == YES){
        //如果有记录的值 那么请求记录哪一行
        if(self.chooseNum){
            [self loadListData:self.cartoonDetail.id pageNum:self.chooseNum isFirst:YES];

        }else{
            [self loadListData:self.cartoonDetail.id pageNum:@"1" isFirst:YES];

        }
    }else{
        [self loadListData:self.cartoonDetail.cartoonId pageNum:@"1" isFirst:YES];
    }

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

}

-(ZZTJiXuYueDuModel *)contiReadBook{
    if(!_contiReadBook){
        _contiReadBook = [[ZZTJiXuYueDuModel alloc] init];
    }
    return _contiReadBook;
}

-(ZZTContinueToDrawHeadView *)xuHuaView{
    if(_xuHuaView == nil){
        _xuHuaView = [ZZTContinueToDrawHeadView ContinueToDrawHeadView];
    }
    return _xuHuaView;
}

-(void)JiXuYueDuTarget{
    
    NSInteger isHave = [ContinueReadManager.sharedInstance isHaveThisBook:self.cartoonDetail];
    
    if(isHave >= 0){
        //如果有书
        //有这本书
        self.isHave = YES;
        self.contiReadBook = ContinueReadManager.sharedInstance.bookReadedArray[isHave];
        //设置继续阅读
        //原版
        self.lastReadData = self.contiReadBook.lastReadData;
        //同人  如果为nil 那么显示一个
        self.multiLastReadData = self.contiReadBook.lastMultiReadData;
    }
    
    [self setupBottomViewContent];
}

-(void)setupBottomViewContent{

    _bottomView.cartoonType = _cartoonDetail.cartoonType;
    _bottomView.lastReadData = self.contiReadBook.lastReadData;
    self.startReadData = _bottomView.lastReadData == nil?self.wordList[0]:nil;
    _bottomView.lastMultiReadData = self.contiReadBook.lastMultiReadData;
    
}

@end
