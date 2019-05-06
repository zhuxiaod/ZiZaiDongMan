//
//  ZZTFindAttentionViewController.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/8/28.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTFindAttentionViewController.h"
#import "ZZTCaiNiXiHuanView.h"
#import "ZZTMyZoneModel.h"
#import "ZZTFindAttentionView.h"
#import "ZZTStatusViewModel.h"
#import "ZZTMyZoneViewController.h"
#import "ZZTStatusTabCell.h"

@interface ZZTFindAttentionViewController ()<UITableViewDelegate,UITableViewDataSource,ZZTReportBtnDelegate>

@property (nonatomic,strong) UITableView *contentView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSArray *CNXHArray;
@property (nonatomic,strong) ZZTFindAttentionView *bannerView;
@property (nonatomic,strong) ZZTCaiNiXiHuanView *caiNiXiHuanView;

@property (nonatomic,assign) NSInteger pageNumber;
//页码size
@property (nonatomic,assign) NSInteger pageSize;

@property (nonatomic,strong) dispatch_group_t group;

@property (nonatomic,assign) dispatch_queue_t q;

@end

static NSString *CaiNiXiHuanView = @"CaiNiXiHuanView";

static NSString *findCommentCell = @"findCommentCell";

@implementation ZZTFindAttentionViewController

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
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupContentView];
   
    self.pageNumber = 1;
    
    self.pageSize = 10;

    [self setupMJRefresh];
    
    [self loadMoreData];


}

-(void)setupContentView{
    
    UITableView *contentView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Screen_Height - 49) style:UITableViewStyleGrouped];
    contentView.delegate = self;
    contentView.dataSource = self;
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.contentInset = UIEdgeInsetsMake(Height_TabbleViewInset, 0, 0, 0);
    contentView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    contentView.rowHeight = UITableViewAutomaticDimension;
    contentView.estimatedRowHeight = 200;
    
    contentView.estimatedSectionFooterHeight = 0;
    contentView.estimatedSectionHeaderHeight = 0;
    _contentView = contentView;
    [contentView registerNib:[UINib nibWithNibName:@"ZZTStatusTabCell" bundle:nil] forCellReuseIdentifier:findCommentCell];
    [self.view addSubview:contentView];
    
}

-(void)setupMJRefresh{
    self.contentView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
        [self loadCaiNiXiHuanData];

     
    }];
    self.contentView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{

            [self loadMoreData];

    }];
}

-(void)loadMoreData{
    [SBAFHTTPSessionManager.sharedManager loadStatusOrAttentionData:[NSString stringWithFormat:@"%ld",self.pageNumber] pageSize:@"10" type:@"2" finished:^(id  _Nullable responseObject, NSError *error) {
        [self.contentView.mj_footer endRefreshing];
        
        if (error != nil) {
            NSLog(@"%@",error);
            return;
        }
        NSDictionary *dic = [[EncryptionTools alloc] decry:responseObject[@"result"]];
        
        NSInteger total = [[NSString stringWithFormat:@"%@",[dic objectForKey:@"total"]] integerValue];
        
        NSMutableArray *array = [ZZTMyZoneModel mj_objectArrayWithKeyValuesArray:[dic objectForKey:@"list"]];
        
        for (ZZTMyZoneModel *model in array) {
            ZZTStatusViewModel *viewModel = [ZZTStatusViewModel initViewModel:model];
            [self.dataArray addObject:viewModel];
        }
        
        [self cacheImages:self.dataArray];
        
        if(self.dataArray.count >= total){
            [self.contentView.mj_footer endRefreshingWithNoMoreData];
        }
        self.pageNumber++;
        self.pageSize += 10;
    }];
}
-(void)loadCaiNiXiHuanData{

    AFHTTPSessionManager *manager = [SBAFHTTPSessionManager getManager];
        [manager POST:[ZZTAPI stringByAppendingString:@"circle/guessYouLike"] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *dic = [[EncryptionTools alloc] decry:responseObject[@"result"]];
            NSMutableArray *array = [UserInfo mj_objectArrayWithKeyValuesArray:dic];
            self.CNXHArray = array;
            [self.contentView reloadData];
            [self.contentView.mj_header endRefreshing];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self.contentView.mj_header endRefreshing];
        }];
}

-(void)loadData{
    [SBAFHTTPSessionManager.sharedManager loadStatusOrAttentionData:@"1" pageSize:[NSString stringWithFormat:@"%ld",self.pageSize] type:@"2" finished:^(id  _Nullable responseObject, NSError *error) {
        [self.contentView.mj_header endRefreshing];
        if (error != nil) {
            NSLog(@"%@",error);
            return;
        }
        NSDictionary *dic = [[EncryptionTools alloc] decry:responseObject[@"result"]];
        
        NSInteger total = [[NSString stringWithFormat:@"%@",[dic objectForKey:@"total"]] integerValue];
        
        NSMutableArray *array = [ZZTMyZoneModel mj_objectArrayWithKeyValuesArray:[dic objectForKey:@"list"]];
        //将里面的模型数据都处理好
        [self.dataArray removeAllObjects];
        for (ZZTMyZoneModel *model in array) {
            ZZTStatusViewModel *viewModel = [ZZTStatusViewModel initViewModel:model];
            [self.dataArray addObject:viewModel];
        }
        
        //下载图片
        [self cacheImages:self.dataArray];
        
        if(self.dataArray.count >= total){
            
            [self.contentView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

-(void)cacheImages:(NSArray *)imgUrls{
    dispatch_group_t group = dispatch_group_create();
    for (ZZTStatusViewModel *model in imgUrls) {
        //下载图片
        for (NSString *imgUrl in model.imgArray) {
            dispatch_group_enter(group);
            [SDWebImageManager.sharedManager loadImageWithURL:[NSURL URLWithString:imgUrl] options:0 progress:nil
                                                    completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                                                        dispatch_group_leave(group);
                                                    }];
        }
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        [self.contentView reloadData];
        
    });
}

#pragma mark - 设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [self.contentView.mj_footer setHidden:NO];
    return self.dataArray.count;
}

#pragma mark - 内容设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //展示数据
    ZZTStatusTabCell *cell = [tableView dequeueReusableCellWithIdentifier:findCommentCell];
    ZZTStatusViewModel *model = self.dataArray[indexPath.row];
    model.modelIndex = indexPath.row;
    cell.viewModel = model;
    cell.reportBtn.reportblock = ^(ZZTReportModel *model) {
        [self shieldingMessage:model.index];
    };
    cell.reloadDataBlock = ^{
        [self loadData];
    };
    return cell;
}

-(void)shieldingMessage:(NSInteger)index{
    ZZTMyZoneModel *model = _dataArray[index];
    [_dataArray removeObject:model];
    [self.contentView reloadData];
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
    weakself(self);
    self.bannerView.gotoViewBlock = ^{
        if([[UserInfoManager share] hasLogin] == NO){
            [UserInfoManager needLogin];
            return;
        }
        //跳转个人页面
        ZZTMyZoneViewController *zoneView = [[ZZTMyZoneViewController alloc] init];
        zoneView.userId = [NSString stringWithFormat:@"%ld",user.id];
        [weakSelf.navigationController pushViewController:zoneView animated:NO];
    };
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
    return 60 + (SCREEN_WIDTH - 20) / 5 + 106 * SCREEN_WIDTH / 360;
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
//    [self.contentView.mj_header beginRefreshing];
    [self scrollViewDidScroll:_contentView];
    [self.navigationController setNavigationBarHidden:YES animated:NO];

}
@end
