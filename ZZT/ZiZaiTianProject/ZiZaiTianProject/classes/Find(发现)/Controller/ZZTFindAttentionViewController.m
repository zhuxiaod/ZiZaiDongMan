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
#import "ZZTMyZoneViewController.h"

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
    contentView.estimatedRowHeight = 0;
    contentView.estimatedSectionFooterHeight = 0;
    contentView.estimatedSectionHeaderHeight = 0;
    _contentView = contentView;
    [contentView registerClass:[ZZTFindCommentCell class] forCellReuseIdentifier:findCommentCell];
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
    UserInfo *user = [Utilities GetNSUserDefaults];
    //请求世界数据
    NSDictionary *dic = @{
                          @"pageNum":[NSString stringWithFormat:@"%ld",self.pageNumber],
                          @"pageSize":@"10",
                          @"userId":[NSString stringWithFormat:@"%ld",user.id],
                          @"type":@"2"//1.世界 2.关注
                          };
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    [manager POST:[ZZTAPI stringByAppendingString:@"circle/selDiscover"] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [[EncryptionTools alloc] decry:responseObject[@"result"]];
        
        NSInteger total = [[NSString stringWithFormat:@"%@",[dic objectForKey:@"total"]] integerValue];
        
        NSMutableArray *array = [ZZTMyZoneModel mj_objectArrayWithKeyValuesArray:[dic objectForKey:@"list"]];
        
        [self.dataArray addObjectsFromArray:array];
        
        [self.contentView reloadData];
        
        if(self.dataArray.count >= total){
            [self.contentView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.contentView.mj_footer endRefreshing];
        }
        self.pageNumber++;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.contentView.mj_footer endRefreshing];
        [self.contentView.mj_header endRefreshing];
    }];
}
-(void)loadCaiNiXiHuanData{

        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
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
    UserInfo *user = [Utilities GetNSUserDefaults];
    //请求世界数据
    NSDictionary *dic = @{
                          @"pageNum":@"1",
                          @"pageSize":[NSString stringWithFormat:@"%ld",self.pageSize],
                          @"userId":[NSString stringWithFormat:@"%ld",user.id],
                          @"type":@"2"//1.世界 2.关注
                          };
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    [manager POST:[ZZTAPI stringByAppendingString:@"circle/selDiscover"] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [[EncryptionTools alloc] decry:responseObject[@"result"]];
        if(dic.count > 6){
//        if([[dic allKeys] containsObject:@"total"]){
            NSInteger total = [[NSString stringWithFormat:@"%@",[dic objectForKey:@"total"]] integerValue];
            
            NSMutableArray *array = [ZZTMyZoneModel mj_objectArrayWithKeyValuesArray:[dic objectForKey:@"list"]];
            
            self.dataArray = array;
            [self.contentView reloadData];
            
            if(self.dataArray.count >= total){
                //            [self.contentView.mj_footer setHidden:YES];
                [self.contentView.mj_header endRefreshing];
            }else{
                [self.contentView.mj_header endRefreshing];
            }
            self.pageSize += 10;
        }else{
            NSLog(@"bug");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.contentView.mj_footer endRefreshing];
        [self.contentView.mj_header endRefreshing];
    }];
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
    ZZTFindCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:findCommentCell forIndexPath:indexPath];
    ZZTMyZoneModel *model = self.dataArray[indexPath.row];
    model.index = indexPath.row;
    cell.model = model;
    cell.reportBtn.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)shieldingMessage:(NSInteger)index{
    ZZTMyZoneModel *model = _dataArray[index];
    [_dataArray removeObject:model];
    [self.contentView reloadData];
}

//-(void)reportUserData:(ZZTMyZoneModel *)messageData{
//    //弹出举报框
//    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//    UIAlertAction *reportBtn = [UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//
////        NSLog(@"%@ : %@",messageData.nickName,messageData.content);
//        [self gotoReportVCWithModel:messageData];
//
//    }];
//    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        NSLog(@"点击了取消");
//    }];
//
//    [actionSheet addAction:reportBtn];
//    [actionSheet addAction:action2];
//
//
//    [self presentViewController:actionSheet animated:YES completion:nil];
//}
//
//-(void)gotoReportVCWithModel:(ZZTMyZoneModel *)reportMessage{
//    ZZTReportViewController *reportVC = [[ZZTReportViewController alloc] init];
//    reportVC.reportData = reportMessage;
//    [self.navigationController pushViewController:reportVC animated:YES];
//}

#pragma mark 高度设置
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZZTMyZoneModel *model = _dataArray[indexPath.row];
    return  [GlobalUI cellHeightWithModel:model];
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
//    [self.contentView.mj_header beginRefreshing];
    [self scrollViewDidScroll:_contentView];
    [self.navigationController setNavigationBarHidden:YES animated:NO];

}
@end
