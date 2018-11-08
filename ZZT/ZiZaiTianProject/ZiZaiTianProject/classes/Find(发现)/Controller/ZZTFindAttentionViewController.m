//
//  ZZTFindAttentionViewController.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/8/28.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTFindAttentionViewController.h"
#import "ZZTCaiNiXiHuanView.h"
#import "ZZTFindCommentCell.h"
#import "ZZTMyZoneModel.h"
#import "ZZTFindAttentionView.h"

@interface ZZTFindAttentionViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *contentView;
@property (nonatomic,assign) NSInteger pageNumber;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSArray *CNXHArray;
@property (nonatomic,strong) ZZTFindAttentionView *bannerView;
@property (nonatomic,strong) ZZTCaiNiXiHuanView *caiNiXiHuanView;
@end

static NSString *CaiNiXiHuanView = @"CaiNiXiHuanView";

@implementation ZZTFindAttentionViewController

-(NSMutableArray *)dataArray{
    if(!_dataArray){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(NSArray *)CNXHArray{
    if(!_CNXHArray){
        _CNXHArray = [NSArray array];
    }
    return _CNXHArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //猜你喜欢
    self.view.backgroundColor = [UIColor redColor];
    
    [self setupContentView];
   
    self.pageNumber = 0;
    
    [self loadData];
    
    [self loadCaiNiXiHuanData];
    
    [self setupMJRefresh];

}

-(void)setupContentView{
    
    UITableView *contentView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Screen_Height - 49) style:UITableViewStyleGrouped];
    contentView.delegate = self;
    contentView.dataSource = self;
    contentView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    contentView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _contentView = contentView;
    [self.view addSubview:contentView];
    
}

-(void)setupMJRefresh{
    self.contentView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadCaiNiXiHuanData];
        [self loadData];
    }];
}

-(void)loadCaiNiXiHuanData{

//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    [manager POST:[ZZTAPI stringByAppendingString:@"circle/guessYouLike"] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [[EncryptionTools sharedEncryptionTools] decry:responseObject[@"result"]];
        NSMutableArray *array = [UserInfo mj_objectArrayWithKeyValuesArray:dic];
        self.CNXHArray = array;
        [self.contentView reloadData];
        [self.contentView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.contentView.mj_header endRefreshing];
    }];
}
-(void)loadData{
    //请求世界数据
    NSDictionary *dic = @{
                          //                          @"pageNum":self.pageNumber,
                          @"pageNum":[NSString stringWithFormat:@"%ld",self.pageNumber],
                          @"pageSize":@"12",
                          //                          @"userId":[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]
                          @"userId":@"1",
                          @"type":@"2"
                          };
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];

    [manager POST:[ZZTAPI stringByAppendingString:@"circle/selDiscover"] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [[EncryptionTools sharedEncryptionTools] decry:responseObject[@"result"]];
        id to = [dic objectForKey:@"total"];
        NSInteger total = [to integerValue];
        NSArray *list = [dic objectForKey:@"list"];
        NSMutableArray *array = [ZZTMyZoneModel mj_objectArrayWithKeyValuesArray:list];
        [self.dataArray addObjectsFromArray:array];
        [self.contentView reloadData];
        if(self.dataArray.count >= total){
            [self.contentView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.contentView.mj_footer endRefreshing];
        }
        //page+size
        self.pageNumber += 6;
        [self.contentView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.contentView.mj_footer endRefreshing];
    }];
}

#pragma mark - 设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
#pragma mark - 内容设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZZTFindCommentCell *cell = [ZZTFindCommentCell dynamicCellWithTable:tableView];
    cell.model = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)loadAttention:(ZZTMyZoneModel *)model{
    NSDictionary *dic = @{
                          @"userId":@"1",
                          @"authorId":model.userId
                          };
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];

    [manager POST:[ZZTAPI stringByAppendingString:@"record/ifUserAtAuthor"] parameters:dic progress:nil success:nil failure:nil];
}

#pragma mark 高度设置
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZZTMyZoneModel *model = _dataArray[indexPath.row];
    NSArray *imgs = [model.contentImg componentsSeparatedByString:@","];
    return  [ZZTFindCommentCell cellHeightWithStr:model.content imgs:imgs];
}


#pragma mark - headView
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //   //作者
    static NSString *attentionBannerView = @"attentionBannerView";
    self.bannerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:attentionBannerView];
    //如果没有头视图
    if(!_bannerView){
        _bannerView = [[ZZTFindAttentionView alloc] initWithReuseIdentifier:attentionBannerView];
    }
    UserInfo *user = [Utilities GetNSUserDefaults];
    self.bannerView.model = user;
    return _bannerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return SCREEN_HEIGHT * 0.36;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    //   //作者
    static NSString *caiNiXiHuanView = @"caiNiXiHuanView";
    self.caiNiXiHuanView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:caiNiXiHuanView];
    //如果没有头视图
    if(!_caiNiXiHuanView){
        _caiNiXiHuanView = [[ZZTCaiNiXiHuanView alloc] initWithReuseIdentifier:caiNiXiHuanView];
    }
    self.caiNiXiHuanView.dataArray = self.CNXHArray;
    [self.caiNiXiHuanView.updataBtn addTarget:self action:@selector(loadCaiNiXiHuanData) forControlEvents:UIControlEventTouchUpInside];
    return _caiNiXiHuanView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return SCREEN_HEIGHT * 0.34;
}

-(ZZTCaiNiXiHuanView *)caiNiXiHuanView{
    if(!_caiNiXiHuanView){
        _caiNiXiHuanView = [[ZZTCaiNiXiHuanView alloc] initWithFrame:CGRectZero];
    }
    return _caiNiXiHuanView;
}

-(ZZTFindAttentionView *)bannerView{
    if(!_bannerView){
        _bannerView = [[ZZTFindAttentionView alloc] initWithFrame:CGRectZero];
    }
    return _bannerView;
}
//是否隐藏navBar
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.y;
    
    //通知
    NSDictionary *dataDic = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%f",offset] forKey:@"navHidden"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"infoNotification" object:nil userInfo:dataDic];
}

//刷新NavBar的状态
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self scrollViewDidScroll:_contentView];
}
@end
