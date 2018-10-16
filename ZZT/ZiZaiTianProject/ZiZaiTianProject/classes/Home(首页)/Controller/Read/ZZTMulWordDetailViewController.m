//
//  ZZTMulWordDetailViewController.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/8/23.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTMulWordDetailViewController.h"
#import "ZZTCartoonDetailViewController.h"
#import "ZZTWordsDetailHeadView.h"
#import "ZZTWordDescSectionHeadView.h"
#import "ZZTCarttonDetailModel.h"
#import "ZZTMulWordListCell.h"
#import "ZZTChapterlistModel.h"
#import "ZZTStoryDetailView.h"
#import "ZZTJiXuYueDuModel.h"
#import "ZZTMulCreationCell.h"
#import "ZZTMulPlayCell.h"

@interface ZZTMulWordDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) ZZTWordsDetailHeadView *head;

@property (nonatomic,strong) ZZTWordDescSectionHeadView *descHeadView;

@property (nonatomic,strong) ZZTCarttonDetailModel *ctDetail;

@property (nonatomic,strong) UITableView *contentView;
//普通目录
@property (nonatomic,strong) NSArray *wordList;
//众创
@property (nonatomic,strong) NSArray *mulWordList;

@property (nonatomic,strong) ZZTJiXuYueDuModel *model;

@property (nonatomic,assign) BOOL isHave;

@property (nonatomic,strong) UIButton *starRead;

//续画model
@property (nonatomic,strong) ZZTChapterlistModel *xuHuaModel;

@property (nonatomic,strong) UIButton *pageBtn;

@end

NSString *zztMulWordListCell = @"zztMulWordListCell";

NSString *zztMulPlayCell = @"zztMulPlayCell";

@implementation ZZTMulWordDetailViewController

-(ZZTJiXuYueDuModel *)model{
    if(!_model){
        _model = [[ZZTJiXuYueDuModel alloc] init];
    }
    return _model;
}
-(ZZTChapterlistModel *)xuHuaModel{
    if(!_xuHuaModel){
        _xuHuaModel = [[ZZTChapterlistModel alloc] init];
    }
    return _xuHuaModel;
}
-(NSArray *)mulWordList{
    if(!_mulWordList){
        _mulWordList = [NSArray array];
    }
    return _mulWordList;
}

-(NSArray *)wordList{
    if(!_wordList){
        _wordList = [NSArray array];
    }
    return _wordList;
}

- (void)setStatusBarBackgroundColor:(UIColor *)color {
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"]; if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.rr_navHidden = YES;
    
    self.fd_prefersNavigationBarHidden = YES;
//    self.fd_interactivePopDisabled = no;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#823BE0"];

    //设置顶部页面
    [self setupTopView];
    //设置底部View
    [self setupBottomView];
    
    self.isHave = NO;
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
    pageBtn.backgroundColor = [UIColor colorWithHexString:@"#DBDCDD"];
    [pageBtn setTitle:@"1 - 12页" forState:UIControlStateNormal];
    [pageBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bottom addSubview:pageBtn];
    //开始阅读
    UIButton *starRead = [[UIButton alloc] init];
    starRead.frame = CGRectMake(SCREEN_WIDTH/3*2, 0, SCREEN_WIDTH/3, 50);
    starRead.backgroundColor = [UIColor colorWithHexString:@"#7778B2"];
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
    ZZTChapterlistModel *model = [[ZZTChapterlistModel alloc] init];
    ZZTCartoonDetailViewController *cartoonDetailVC = [[ZZTCartoonDetailViewController alloc] init];
    if([startBtn.titleLabel.text isEqualToString:@"开始阅读"] && self.wordList.count > 0){
        model = self.wordList[0];
        cartoonDetailVC.indexRow = 0;
    }else if([startBtn.titleLabel.text isEqualToString:@"继续阅读"] && self.wordList.count > 0){
        //取出来的
        model = self.wordList[[self.model.chapterIndex integerValue]];
        cartoonDetailVC.indexRow = [self.model.chapterIndex integerValue];
        cartoonDetailVC.testModel = self.model;
    }
    cartoonDetailVC.cartoonModel = _cartoonDetail;
    cartoonDetailVC.hidesBottomBarWhenPushed = YES;
    cartoonDetailVC.dataModel = model;
    cartoonDetailVC.cartoonModel = _cartoonDetail;
    [self.navigationController pushViewController:cartoonDetailVC animated:YES];
}

-(void)setIsId:(BOOL)isId{
    _isId = isId;
}

//设置数据
-(void)setCartoonDetail:(ZZTCarttonDetailModel *)cartoonDetail{
    _cartoonDetail = cartoonDetail;
    if(self.isId == YES){
        //上部分View
        [self loadtopData:cartoonDetail.id];
        //续画
//        [self loadXuHuaListData:cartoonDetail.id];
        //目录
//        [self loadCatalogueData:cartoonDetail.id];
        //评论
        //        [self loadCommentData:cartoonDetail.id];
    }else{
        [self loadtopData:cartoonDetail.cartoonId];
        //续画
//        [self loadXuHuaListData:cartoonDetail.cartoonId];
        //目录
//        [self loadCatalogueData:cartoonDetail.cartoonId];
    }
}

-(void)loadCatalogueData:(NSString *)Id{
    //加载用户信息
    NSDictionary *paramDict = @{
                                @"cartoonId":Id,//1 独创 2 众创
                                @"type":@"1",
                                @"cartoonType":self.cartoonDetail.cartoonType
                                };
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    EncryptionTools *tool = [[EncryptionTools alloc] init];
    [manager POST:[ZZTAPI stringByAppendingString:@"cartoon/getChapterlist"] parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [tool decry:responseObject[@"result"]];
        //这里有问题 应该是转成数组 然后把对象取出
        NSMutableArray *array = [ZZTChapterlistModel mj_objectArrayWithKeyValuesArray:dic];
        self.wordList = array;
        [self.contentView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
    }];
}

//请求该漫画的资料
-(void)loadtopData:(NSString *)Id{
    UserInfo *userInfo = [Utilities GetNSUserDefaults];
    //加载用户信息
    NSDictionary *paramDict = @{
                                @"id":Id,
                                @"userId":[NSString stringWithFormat:@"%ld",userInfo.id]
                                };
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    EncryptionTools *tool = [[EncryptionTools alloc] init];
    [manager POST:[ZZTAPI stringByAppendingString:@"cartoon/particulars"] parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [tool decry:responseObject[@"result"]];
        ZZTCarttonDetailModel *mode = [ZZTCarttonDetailModel mj_objectWithKeyValues:dic];
        self.ctDetail = mode;
        self.head.detailModel = mode;
        [self.contentView reloadData];
        if(self.isId == YES){
            [self loadXuHuaListData:self.cartoonDetail.id];
        }else{
            [self loadXuHuaListData:self.cartoonDetail.cartoonId];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
    }];
}

//目录 - 众创
-(void)loadXuHuaListData:(NSString *)ID{
    //加载用户信息
    NSDictionary *paramDict = @{
                                //1 独创 2众创
                                 @"cartoonId":@"1",
                                 @"type":@"2"
                               };
    EncryptionTools *tool = [[EncryptionTools alloc] init];

//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    [manager POST:[ZZTAPI stringByAppendingString:@"cartoon/getXuhualist"] parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [tool decry:responseObject[@"result"]];
        NSArray *modelArray = [ZZTChapterlistModel mj_objectArrayWithKeyValuesArray:dic];
        self.mulWordList = modelArray;
        [self.contentView reloadData];
        if(self.isId == YES){
            [self loadCatalogueData:self.cartoonDetail.id];
        }else{
            [self loadCatalogueData:self.cartoonDetail.cartoonId];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
    }];
}

-(void)setupTopView{
    
    UITableView *contenView = [[UITableView alloc] initWithFrame:CGRectMake(0, -20, self.view.width, self.view.height) style:UITableViewStyleGrouped];
    contenView.backgroundColor = [UIColor whiteColor];
    contenView.contentInset = UIEdgeInsetsMake(wordsDetailHeadViewHeight,0,0,0);
    contenView.delegate = self;
    contenView.dataSource = self;
    contenView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.contentView = contenView;
    contenView.sectionFooterHeight = 0;
    [contenView  setSeparatorColor:[UIColor blueColor]];
    
    ZZTWordsDetailHeadView *head = [ZZTWordsDetailHeadView wordsDetailHeadViewWithFrame:CGRectMake(0, -20, SCREEN_WIDTH, wordsDetailHeadViewHeight) scorllView:contenView];
    
    [head.shareBtn addTarget:self action:@selector(shareWithSharePanel) forControlEvents:UIControlEventTouchUpInside];

    //收藏业务
    head.buttonAction = ^(ZZTCarttonDetailModel *detailModel) {
        UserInfo *userInfo = [Utilities GetNSUserDefaults];
        NSDictionary *dic = @{
                              @"cartoonId":detailModel.id,
                              @"userId":[NSString stringWithFormat:@"%ld",userInfo.id]
                              };
//        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
        [manager POST:[ZZTAPI stringByAppendingString:@"great/collects"] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    };
    
    self.head = head;
    //设置数据
//    self.head.detailModel = self.cartoonDetail;
    //先让数据显示
    [contenView registerClass:[ZZTMulPlayCell class] forCellReuseIdentifier:zztMulPlayCell];

    [self.view addSubview:contenView];
    [self.view addSubview:head];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return self.mulWordList.count;
    }else{
        return self.wordList.count;
    }
}

#pragma mark - 内容设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        ZZTMulPlayCell *cell = [tableView dequeueReusableCellWithIdentifier:zztMulPlayCell];
        cell.str = self.ctDetail.type;
        cell.isHave = YES;
        ZZTChapterlistModel *model = self.mulWordList[0];
        cell.xuHuaModel = model;
        cell.selectionStyle = UITableViewCellAccessoryNone;
        return cell;
    }else{
        ZZTMulPlayCell *cell = [tableView dequeueReusableCellWithIdentifier:zztMulPlayCell];
        cell.str = self.ctDetail.type;
        cell.isHave = NO;
        ZZTChapterlistModel *model = self.wordList[0];
        cell.xuHuaModel = model;
        cell.selectionStyle = UITableViewCellAccessoryNone;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ZZTChapterlistModel *model = self.wordList[indexPath.row];
    //跳页
    ZZTCartoonDetailViewController *cartoonDetailVC = [[ZZTCartoonDetailViewController alloc] init];
    cartoonDetailVC.hidesBottomBarWhenPushed = YES;
    
    cartoonDetailVC.indexRow = indexPath.row;

    cartoonDetailVC.dataModel = model;
    cartoonDetailVC.cartoonModel = _cartoonDetail;
    //章节内容id
//    cartoonDetailVC.cartoonId = [NSString stringWithFormat:@"%ld",model.id];//内容
//    cartoonDetailVC.bookNameId = _cartoonDetail.id;
    
 
    [self.navigationController pushViewController:cartoonDetailVC animated:YES];
}

-(void)loadAttention:(ZZTChapterlistModel *)model{
    NSDictionary *dic = @{
                          @"userId":@"1",
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
    //字符串
    if(section == 0){
        self.descHeadView.desc = self.ctDetail.intro;
        return self.descHeadView.myHeight;
    }else{
        return 0;
    }
}

//设置头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    //介绍
    self.descHeadView.desc = self.ctDetail.intro;
    return self.descHeadView;
}

#pragma mark - lazyLoad
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        if([self.ctDetail.type isEqualToString:@"1"]){
            return 150;
        }else{
            return 120;
        }
    }else{
        if([self.ctDetail.type isEqualToString:@"1"]){
            return 130;
        }else{
            return 100;
        }
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
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self JiXuYueDuTarget];
}

//判断是否有这个记录
-(void)JiXuYueDuTarget{
    
    NSMutableArray *arrayDict = [NSKeyedUnarchiver unarchiveObjectWithFile:JiXuYueDuAPI];
    if (arrayDict == nil) {
        arrayDict = [NSMutableArray array];
    }
    
    for (int i = 0; i < arrayDict.count; i++) {
        //看这个数组里面的模型是否有这本书
        ZZTJiXuYueDuModel *model = arrayDict[i];
        if([model.bookId isEqualToString:self.cartoonDetail.id]){
            self.isHave = YES;
            self.model = model;
            break;
        }
    }
    [self setupBottomViewContent];
}

-(void)setupBottomViewContent{
    //有的话 说明有记录
    if(self.isHave == YES){
        [_starRead setTitle:@"继续阅读" forState:UIControlStateNormal];
        //第几画
        if([self.cartoonDetail.type isEqualToString:@"1"]){
            [_pageBtn setTitle:[NSString stringWithFormat:@"%@画",self.model.bookChapter] forState:UIControlStateNormal];
        }else{
            [_pageBtn setTitle:[NSString stringWithFormat:@"%@页",self.model.bookChapter] forState:UIControlStateNormal];
        }
    }else{
        //如果没有  保存进去
        [_starRead setTitle:@"开始阅读" forState:UIControlStateNormal];
    }
}
@end
