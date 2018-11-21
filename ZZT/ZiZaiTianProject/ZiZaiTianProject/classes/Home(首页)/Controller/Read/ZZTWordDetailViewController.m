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

@interface ZZTWordDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,ZZTChapterChooseViewDelegate>

@property (nonatomic,strong) ZZTWordsDetailHeadView *head;

@property (nonatomic,strong) ZZTWordDescSectionHeadView *descHeadView;

@property (nonatomic,strong) ZZTCarttonDetailModel *ctDetail;

@property (nonatomic,strong) UITableView *contentView;

@property (nonatomic,strong) NSMutableArray *wordList;

@property (nonatomic,strong) ZZTJiXuYueDuModel *model;

@property (nonatomic,assign) BOOL isHave;

@property (nonatomic,strong) UIButton *starRead;

@property (nonatomic,strong) UIButton *pageBtn;

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
}

-(void)setupShieldView{
    UIView *shieldView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 100)];
    [shieldView setBackgroundColor:[UIColor colorWithRGB:@"121,105,212"]];
    [self.view addSubview:shieldView];
}

-(void)setupNavigationBar{
    ZXDNavBar *navbar = [[ZXDNavBar alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, TOPBAR_HEIGHT)];
    self.navbar = navbar;
    navbar.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:navbar];
    
    //返回
    [navbar.leftButton setImage:[UIImage imageNamed:@"navigationbarBack"] forState:UIControlStateNormal];
    navbar.leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 17);
    
    //中间
    [navbar.centerButton setTitle:@" " forState:UIControlStateNormal];
    [navbar.centerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navbar.mainView setBackgroundColor:[UIColor colorWithRGB:@"121,105,212"]];
    
    [navbar.rightButton setTitle:@"分享" forState:UIControlStateNormal];
    [navbar.rightButton addTarget:self action:@selector(shareWithSharePanel) forControlEvents:UIControlEventTouchUpInside];
    
    navbar.showBottomLabel = NO;
}

//设置底部View
-(void)setupBottomView{
    UIView *bottom = [[UIView alloc] init];
    bottom.frame = CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50);
    bottom.backgroundColor = [UIColor redColor];
    [self.view addSubview:bottom];
    
    //页码
    UIButton *pageBtn = [[UIButton alloc] init];
    pageBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH/3*2, 50);
    pageBtn.backgroundColor = [UIColor colorWithRGB:@"226,226,226"];
//    pageBtn.alpha = 0.6;
    [pageBtn setTitle:@" " forState:UIControlStateNormal];
    _pageBtn = pageBtn;
    [pageBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bottom addSubview:pageBtn];
    
    //开始阅读 继续阅读
    UIButton *starRead = [[UIButton alloc] init];
    starRead.frame = CGRectMake(SCREEN_WIDTH/3*2, 0, SCREEN_WIDTH/3, 50);
    starRead.backgroundColor = ZZTSubColor;
    [starRead addTarget:self action:@selector(starReadTarget:) forControlEvents:UIControlEventTouchUpInside];
    [starRead setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _starRead = starRead;
    [starRead setTitle:@"开始阅读" forState:UIControlStateNormal];
    [bottom addSubview:starRead];
    
    //有的话 说明有记录
    if(self.isHave == YES){
        NSLog(@"数组里面有这个");
        [starRead setTitle:@"继续阅读" forState:UIControlStateNormal];
    }else{
        NSLog(@"数组里面没有这个");
        //如果没有  保存进去
        [starRead setTitle:@"开始阅读" forState:UIControlStateNormal];
    }
}

//开始阅读
-(void)starReadTarget:(UIButton *)startBtn{
    //章节模型
    ZZTChapterlistModel *model = [[ZZTChapterlistModel alloc] init];
    ZZTCartoonDetailViewController *cartoonDetailVC = [[ZZTCartoonDetailViewController alloc] init];
    //如果没有阅读过
    if([startBtn.titleLabel.text isEqualToString:@"开始阅读"] && self.wordList.count > 0){
        //此书第一章节的数据
        model = self.startReadData;
        cartoonDetailVC.indexRow = 0;
        cartoonDetailVC.dataModel = model;
    }else if([startBtn.titleLabel.text isEqualToString:@"继续阅读"] && self.wordList.count > 0){
        //阅读过
        //要一个数据 能代替这里的
//        model = self.wordList[[self.model.chapterListRow integerValue]];
        cartoonDetailVC.indexRow = [self.model.chapterListRow integerValue];
//        cartoonDetailVC.dataModel = model;
        cartoonDetailVC.dataModel = self.lastReadData;
        cartoonDetailVC.testModel = self.model;
//        cartoonDetailVC.lastReadModel = self.lastReadData;
    }
    cartoonDetailVC.hidesBottomBarWhenPushed = YES;
    cartoonDetailVC.cartoonModel = _cartoonDetail;
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
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    EncryptionTools *tool = [[EncryptionTools alloc]init];
    [manager POST:[ZZTAPI stringByAppendingString:@"cartoon/particulars"] parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic1 = [tool decry:responseObject[@"result"]];
        //这里有问题 应该是转成数组 然后把对象取出
        ZZTCarttonDetailModel *mode = [ZZTCarttonDetailModel mj_objectWithKeyValues:dic1];
        self.ctDetail = mode;
        self.head.detailModel = mode;
        [self.navbar.centerButton setTitle:mode.bookName forState:UIControlStateNormal];
        dispatch_group_leave(self.group);
        [self.contentView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_group_leave(self.group);
    }];
}

//目录
-(void)loadListData:(NSString *)ID pageNum:(NSString *)pageNum isFirst:(BOOL)isFirst{
    NSDictionary *paramDict = @{
                                @"cartoonId":ID,
                                @"type":self.cartoonDetail.type,//1.漫画 剧本
                                @"cartoonType":self.cartoonDetail.cartoonType, //1 独创 2 众创
                                @"pageNum":pageNum,
                                @"pageSize":@"5"
                                };
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    EncryptionTools *tool = [[EncryptionTools alloc]init];
    [manager POST:[ZZTAPI stringByAppendingString:@"cartoon/getChapterlist"] parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic2 = [tool decry:responseObject[@"result"]];
        //这里有问题 应该是转成数组 然后把对象取出
        NSMutableArray *array = [ZZTChapterlistModel mj_objectArrayWithKeyValuesArray:dic2[@"list"]];
        self.wordList = array;
        
        //总共的数量
        NSNumber *totalData = dic2[@"total"];
        self.chapterChooseView.total = [totalData integerValue];
        
        //列表大于1 第一次
        if(array.count > 0 && isFirst == YES){
            ZZTChapterlistModel *model = array[0];
            //没有历史
            if(self.isHave == NO){
                if([self.cartoonDetail.type isEqualToString:@"1"]){
                    [self.pageBtn setTitle:[NSString stringWithFormat:@"%@画",model.chapterPage] forState:UIControlStateNormal];
                }else{
                    [self.pageBtn setTitle:[NSString stringWithFormat:@"%@",model.chapterName] forState:UIControlStateNormal];
                }
                //将开始阅读的内容 储存起来
                self.startReadData = model;
            }
        }
        [self.contentView reloadData];
        dispatch_group_leave(self.group);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_group_leave(self.group);
    }];
}

-(void)setupTopView{
    
    UITableView *contenView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 50) style:UITableViewStyleGrouped];
    contenView.backgroundColor = [UIColor clearColor];
    contenView.contentInset = UIEdgeInsetsMake(-20,0,0,0);
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
//    [self.view addSubview:head];
}

-(void)shareWithSharePanel{
    if([[UserInfoManager share] hasLogin] == NO){
        [UserInfoManager needLogin];
        return;
    }
    __weak typeof(self) ws = self;
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        [ws shareTextToPlatform:platformType];
    }];
}

//分享
-(void)shareTextToPlatform:(UMSocialPlatformType)plaform{
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    messageObject.text = @"友盟+";
    
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"分享到标题" descr:@"分享的描述" thumImage:[UIImage imageNamed:@"3.png"]];
    shareObject.webpageUrl = @"https://www.baidu.com/"; //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    [[UMSocialManager defaultManager] shareToPlatform:plaform messageObject:messageObject currentViewController:nil completion:^(id result, NSError *error) {
        if(error){
            //failed
        }else{
            //success
        }
    }];
}


#pragma mark - 设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //2节
    //第一个View单独一节
    //
//    return 1;
//    return 2;
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
        commentView.chapterId = [NSString stringWithFormat:@"%ld",model.id];
        commentView.cartoonType = model.type;
        [self presentViewController:commentView animated:YES completion:nil];
    };
    cell.selected = UITableViewCellSelectionStyleNone;
    cell.model = model;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ZZTChapterlistModel *model = self.wordList[indexPath.row];
    //跳页
    ZZTCartoonDetailViewController *cartoonDetailVC = [[ZZTCartoonDetailViewController alloc] init];
    //书模型 cartoonDetail.id
    cartoonDetailVC.cartoonModel = _cartoonDetail;
    //章节
    model.listTotal = self.chapterChooseView.total;
    cartoonDetailVC.dataModel = model;
    cartoonDetailVC.indexRow = indexPath.row;
    if(self.isHave == YES){
        cartoonDetailVC.testModel = self.model;
    }
    cartoonDetailVC.hidesBottomBarWhenPushed = YES;
    cartoonDetailVC.collectModel = self.ctDetail;
    [self.navigationController pushViewController:cartoonDetailVC animated:YES];
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
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    [manager POST:[ZZTAPI stringByAppendingString:@"record/ifUserAtAuthor"] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

//高度设置
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 0){
        return SCREEN_HEIGHT * 0.3385;
    }else if(section == 1){
        //字符串
        self.descHeadView.desc = self.ctDetail.intro;
        return self.descHeadView.myHeight;
    }
    else{
//        return self.chapterChooseView.myHeight;
        return 0.01;
    }
}

//设置头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section == 0){
        //设置数据
        self.wordDetailHeadView.detailModel = self.ctDetail;
        return self.wordDetailHeadView;
    }else if(section == 1){
        //介绍
        self.descHeadView.desc = self.ctDetail.intro;
        return self.descHeadView;
    }else{
        return nil;
    }

}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(section == 1){
        return self.chapterChooseView;
    }else{
        static NSString *viewIdentfier = @"footerView";
        SectionFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:viewIdentfier];
        return footerView;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 1){
        return self.chapterChooseView.myHeight;
    }
    return 0.01;
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
        _chapterChooseView.backgroundColor = [UIColor whiteColor];
    }
    return _chapterChooseView;
}

-(void)chapterChooseView:(ZZTChapterChooseView *)chapterChooseView didItemWithModel:(ZZTChapterChooseModel *)model{
    
    dispatch_group_async(self.group, self.q, ^{
        dispatch_group_enter(self.group);
        if(self.isId == YES){
            [self loadListData:self.cartoonDetail.id pageNum:[NSString stringWithFormat:@"%ld",model.APIPage] isFirst:NO];
        }else{
            [self loadListData:self.cartoonDetail.cartoonId pageNum:[NSString stringWithFormat:@"%ld",model.APIPage] isFirst:NO];
        }
    });
    
}

- (ZZTWordDescSectionHeadView *)descHeadView {
    if (!_descHeadView) {
        
        _descHeadView = [[ZZTWordDescSectionHeadView alloc] initWithFrame:self.view.bounds];
        _descHeadView.backgroundColor = [UIColor clearColor];
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
            AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
            [manager POST:[ZZTAPI stringByAppendingString:@"great/collects"] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                //重新获取信息
                dispatch_group_async(weakSelf.group, weakSelf.q, ^{
                    dispatch_group_enter(weakSelf.group);
                    if(self.isId == YES){
                        //上部分View
                        [weakSelf loadtopData:weakSelf.cartoonDetail.id];
                    }else{
                        [weakSelf loadtopData:weakSelf.cartoonDetail.cartoonId];
                    }
                });
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
-(ZZTCarttonDetailModel *)ctDetail{
    if (!_ctDetail) {
        _ctDetail = [[ZZTCarttonDetailModel alloc] init];
    }
    return _ctDetail;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.navigationController.navigationBar.alpha = 0;
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
    _navigationFrame = self.navigationController.navigationBar.frame;

    //一进来就开始判断
    [self JiXuYueDuTarget];

    //请求数据
    [self loadData];
}

-(void)loadData{
     dispatch_group_async(self.group, self.q, ^{
         dispatch_group_enter(self.group);
         if(self.isId == YES){
             //上部分View
             [self loadtopData:self.cartoonDetail.id];
         }else{
             [self loadtopData:self.cartoonDetail.cartoonId];
         }
    });
    
    dispatch_group_async(self.group, self.q, ^{
        dispatch_group_enter(self.group);
        if(self.isId == YES){
            [self loadListData:self.cartoonDetail.id pageNum:@"1" isFirst:YES];
        }else{
            [self loadListData:self.cartoonDetail.cartoonId pageNum:@"1" isFirst:YES];
        }
    });
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

}

-(ZZTJiXuYueDuModel *)model{
    if(!_model){
        _model = [[ZZTJiXuYueDuModel alloc] init];
    }
    return _model;
}

-(void)JiXuYueDuTarget{
    //拿到本地历史数据
    NSMutableArray *arrayDict = [NSKeyedUnarchiver unarchiveObjectWithFile:JiXuYueDuAPI];
    if (arrayDict == nil) {
        arrayDict = [NSMutableArray array];
    }
    
    for (int i = 0; i < arrayDict.count; i++) {
        //看这个数组里面的模型是否有这本书
        ZZTJiXuYueDuModel *model = arrayDict[i];
        if([model.bookId isEqualToString:self.cartoonDetail.id]){
            //有这本书
            self.isHave = YES;
            self.model = model;
            //设置继续阅读
            self.lastReadData = model.lastReadData;
            break;
        }
    }
    [self setupBottomViewContent];
}

-(void)setupBottomViewContent{
    //有的话 说明有记录
    if(self.isHave == YES){
        [_starRead setTitle:@"继续阅读" forState:UIControlStateNormal];
        ZZTChapterModel *model = [[ZZTChapterModel alloc] init];
        if(self.model.chapterArray.count > 0){
            model = self.model.chapterArray[[self.model.arrayIndex integerValue]];
        }
        //第几画
        if([self.cartoonDetail.type isEqualToString:@"1"]){
            //得到最后一章
            [_pageBtn setTitle:[NSString stringWithFormat:@"%@画",model.chapterPage] forState:UIControlStateNormal];
        }else{
            [_pageBtn setTitle:[NSString stringWithFormat:@"%@",model.chapterName] forState:UIControlStateNormal];
        }
    }else{
        //如果没有  保存进去
        [_starRead setTitle:@"开始阅读" forState:UIControlStateNormal];
    }
}


@end
