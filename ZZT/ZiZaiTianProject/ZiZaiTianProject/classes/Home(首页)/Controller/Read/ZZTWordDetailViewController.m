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

@interface ZZTWordDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) ZZTWordsDetailHeadView *head;

@property (nonatomic,strong) ZZTWordDescSectionHeadView *descHeadView;

@property (nonatomic,strong) ZZTCarttonDetailModel *ctDetail;

@property (nonatomic,strong) UITableView *contentView;

@property (nonatomic,strong) NSMutableArray *wordList;

@property (nonatomic,strong) ZZTJiXuYueDuModel *model;

@property (nonatomic,assign) BOOL isHave;

@property (nonatomic,strong) UIButton *starRead;

@end

NSString *zztWordListCell = @"zztWordListCell";

@implementation ZZTWordDetailViewController

-(NSMutableArray *)wordList{
    if(!_wordList){
        _wordList = [NSMutableArray array];
    }
    return _wordList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.fd_prefersNavigationBarHidden = YES;
    
    self.isHave = NO;

    self.view.backgroundColor = [UIColor whiteColor];
    //设置顶部页面
    [self setupTopView];
    //设置底部View
    [self setupBottomView];
    //详情接口
//    [self loadDetailData];
}

//-(void)loadDetailData{
//    UserInfo *user = [Utilities GetNSUserDefaults];
//    NSDictionary *dic = @{
//                          @"id":_cartoonDetail.id,
//                          @"userId":[NSString stringWithFormat:@"%ld",user.id]
//                          };
//    [AFNHttpTool POST:[ZZTAPI stringByAppendingString:@"cartoon/particulars"] parameters:dic success:^(id responseObject) {
//        NSDictionary *dic = [[EncryptionTools sharedEncryptionTools] decry:responseObject[@"result"]];
//        NSArray *array = [ZZTCarttonDetailModel mj_objectArrayWithKeyValuesArray:dic];
//
//    } failure:^(NSError *error) {
//
//    }];
//}

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
    //开始阅读 继续阅读
    UIButton *starRead = [[UIButton alloc] init];
    starRead.frame = CGRectMake(SCREEN_WIDTH/3*2, 0, SCREEN_WIDTH/3, 50);
    starRead.backgroundColor = [UIColor colorWithHexString:@"#7778B2"];
    [starRead addTarget:self action:@selector(starReadTarget) forControlEvents:UIControlEventTouchUpInside];
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
-(void)starReadTarget{
    ZZTCartoonDetailViewController *cartoonDetailVC = [[ZZTCartoonDetailViewController alloc] init];
    cartoonDetailVC.hidesBottomBarWhenPushed = YES;
//    cartoonDetailVC.type = _cartoonDetail.type;
//    cartoonDetailVC.cartoonId = self.cartoonDetail.id;
//    cartoonDetailVC.viewTitle = _cartoonDetail.bookName;
//    cartoonDetailVC.bookNameId = _cartoonDetail.id;
    cartoonDetailVC.cartoonModel = _cartoonDetail;

    if(self.isHave == YES){
        cartoonDetailVC.testModel = _model;
//        cartoonDetailVC.cartoonId = _model.bookChapter;
    }
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
       //目录
        [self loadListData:cartoonDetail.id];
       //评论
//        [self loadCommentData:cartoonDetail.id];
    }else{
        [self loadtopData:cartoonDetail.cartoonId];
        //目录
        [self loadListData:cartoonDetail.cartoonId];
    }
}

//请求该漫画的资料
-(void)loadtopData:(NSString *)ID{
    UserInfo *user = [Utilities GetNSUserDefaults];

    NSDictionary *paramDict = @{
                                @"id":ID,
                                @"userId":[NSString stringWithFormat:@"%ld",user.id]
                                };
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    EncryptionTools *tool = [[EncryptionTools alloc]init];
    [manager POST:[ZZTAPI stringByAppendingString:@"cartoon/particulars"] parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic1 = [tool decry:responseObject[@"result"]];
        //这里有问题 应该是转成数组 然后把对象取出
        ZZTCarttonDetailModel *mode = [ZZTCarttonDetailModel mj_objectWithKeyValues:dic1];
        self.ctDetail = mode;
        self.head.detailModel = mode;
        [self.contentView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

//目录
-(void)loadListData:(NSString *)ID{
    NSDictionary *paramDict = @{
                                @"cartoonId":ID,//1 独创 2 众创
                                @"type":@"1",
                                @"cartoonType":self.cartoonDetail.cartoonType
                                };
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    EncryptionTools *tool = [[EncryptionTools alloc]init];
    [manager POST:[ZZTAPI stringByAppendingString:@"cartoon/getChapterlist"] parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic2 = [tool decry:responseObject[@"result"]];
        //这里有问题 应该是转成数组 然后把对象取出
        NSMutableArray *array = [ZZTChapterlistModel mj_objectArrayWithKeyValuesArray:dic2];
        self.wordList = array;
        [self.contentView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
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
    
    [contenView setSeparatorColor:[UIColor blueColor]];
    
    ZZTWordsDetailHeadView *head = [ZZTWordsDetailHeadView wordsDetailHeadViewWithFrame:CGRectMake(0, -20, SCREEN_WIDTH, wordsDetailHeadViewHeight) scorllView:contenView];
    
    [head.shareBtn addTarget:self action:@selector(shareWithSharePanel) forControlEvents:UIControlEventTouchUpInside];
    
    //收藏业务
    head.buttonAction = ^(ZZTCarttonDetailModel *detailModel) {
        UserInfo *userInfo = [Utilities GetNSUserDefaults];
        NSDictionary *dic = @{
                              @"cartoonId":detailModel.id,
                              @"userId":[NSString stringWithFormat:@"%ld",userInfo.id]
                              };
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager POST:[ZZTAPI stringByAppendingString:@"great/collects"] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    };
    
    self.head = head;
    //设置数据
//    self.head.detailModel = self.cartoonDetail;
    
    //先让数据显示
    [contenView registerNib:[UINib nibWithNibName:@"ZZTWordListCell" bundle:nil] forCellReuseIdentifier:zztWordListCell];
    
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.wordList.count;
}

#pragma mark - 内容设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZZTWordListCell *cell = [tableView dequeueReusableCellWithIdentifier:zztWordListCell];
  
    ZZTChapterlistModel *model = self.wordList[indexPath.row];
    model.type = _cartoonDetail.type;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.btnBlock = ^(ZZTWordListCell *cell, ZZTChapterlistModel *model) {
//        NSIndexPath *indexPath = [tableView indexPathForCell:cell];
//        [self.wordList replaceObjectAtIndex:indexPath.row withObject:model];
//        [self loadAttention:model];
    };
    cell.model = model;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ZZTChapterlistModel *model = self.wordList[indexPath.row];
    //跳页
    ZZTCartoonDetailViewController *cartoonDetailVC = [[ZZTCartoonDetailViewController alloc] init];
    cartoonDetailVC.hidesBottomBarWhenPushed = YES;
//    cartoonDetailVC.bookNameId = _cartoonDetail.id;
    //书模型
    cartoonDetailVC.cartoonModel = _cartoonDetail;
    //章节
    cartoonDetailVC.dataModel = model;
    
    if(self.isHave == YES &&  [NSString stringWithFormat:@"%ld",model.id] == _model.bookChapter){
        cartoonDetailVC.testModel = _model;
    }
    [self.navigationController pushViewController:cartoonDetailVC animated:YES];
}


-(void)loadAttention:(ZZTChapterlistModel *)model{
    NSDictionary *dic = @{
                          @"userId":@"1",
                          @"authorId":model.userId
                          };
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[ZZTAPI stringByAppendingString:@"record/ifUserAtAuthor"] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

//高度设置
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    //字符串
    self.descHeadView.desc = self.ctDetail.intro;
    return self.descHeadView.myHeight;
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
    return 120;
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

-(ZZTJiXuYueDuModel *)model{
    if(!_model){
        _model = [[ZZTJiXuYueDuModel alloc] init];
    }
    return _model;
}

-(void)JiXuYueDuTarget{
    NSArray *models = [Utilities GetArrayWithPathComponent:@"readHistoryArray"];
    NSMutableArray *arrayDict = [ZZTJiXuYueDuModel mj_objectArrayWithKeyValuesArray:models];
    
    for (int i = 0; i < arrayDict.count; i++) {
        //看这个数组里面的模型是否有这本书
        ZZTJiXuYueDuModel *model = arrayDict[i];
        if([model.bookId isEqualToString:self.cartoonDetail.id]){
            self.isHave = YES;
            self.model = model;
            break;
        }
    }
    //有的话 说明有记录
    if(self.isHave == YES){
//        NSLog(@"数组里面有这个");
        [_starRead setTitle:@"继续阅读" forState:UIControlStateNormal];
    }else{
//        NSLog(@"数组里面没有这个");
        //如果没有  保存进去
        [_starRead setTitle:@"开始阅读" forState:UIControlStateNormal];
    }
}
@end
