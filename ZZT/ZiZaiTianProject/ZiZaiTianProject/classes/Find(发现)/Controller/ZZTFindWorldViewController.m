//
//  ZZTFindWorldViewController.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/8/28.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTFindWorldViewController.h"
#import "ZZTFindCommentCell.h"
#import "ZZTCaiNiXiHuanView.h"
#import "ZZTMyZoneModel.h"
#import <SDCycleScrollView.h>
#import "ZZTFindBannerView.h"
#import "ZZTZoneImageView.h"
#import "ZZTFindAttentionView.h"
#import "Utilities.h"

@interface ZZTFindWorldViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,UICollectionViewDelegate,ZZTReportBtnDelegate>

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) UITableView *contentView;

@property (nonatomic,assign) NSInteger pageNumber;
//页码size
@property (nonatomic,assign) NSInteger pageSize;

@property (nonatomic,strong) NSArray *imagesURLStrings;

@property (nonatomic,strong) ZZTFindBannerView *bannerView;

@property (nonatomic,strong) ZZTZoneImageView *zoneImageView;

@property (nonatomic,strong) ZZTCaiNiXiHuanView *caiNiXiHuanView;

@property (nonatomic,strong) NSArray *CNXHArray;

@property (nonatomic,strong) dispatch_group_t group;

@property (nonatomic,assign) dispatch_queue_t q;

@end

static NSString *CaiNiXiHuanView1 = @"CaiNiXiHuanView1";

static NSString *findCommentCell = @"findCommentCell";


@implementation ZZTFindWorldViewController

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

-(NSArray *)CNXHArray{
    if(!_CNXHArray){
        _CNXHArray = [NSArray array];
    }
    return _CNXHArray;
}

-(NSArray *)imagesURLStrings{
    if(!_imagesURLStrings){
        _imagesURLStrings = [NSArray array];
    }
    return _imagesURLStrings;
}

-(NSMutableArray *)dataArray{
    if(!_dataArray){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(void)viewDidLoad{
    [super viewDidLoad];

    //猜你喜欢
    self.view.backgroundColor = [UIColor whiteColor];
    
    //tableView
    [self setupTableView];
    
    self.pageNumber = 1;
    
    self.pageSize = 10;
//    [self loadData];
    
   //banner数据
    self.imagesURLStrings = [NSArray arrayWithObjects: @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1535282045025&di=b648e41d5d5a3535e5518a545459d351&imgtype=0&src=http%3A%2F%2Fimg.mp.itc.cn%2Fupload%2F20161123%2Fbfa082e23cd94089a907a29b021946bf_th.jpeg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1535282045025&di=d2ddcf88c11b57887d64db25c870bd4f&imgtype=0&src=http%3A%2F%2F5b0988e595225.cdn.sohucs.com%2Fimages%2F20170919%2F210211af972f4e3c8c5a7fda0fda7493.jpeg", nil];
    
    [self setupMJRefresh];
    
//    [self loadCaiNiXiHuanData];

//    [self.contentView.mj_header beginRefreshing];
    
    [self loadMoreData];

}


-(void)setupTableView{
    UITableView *contentView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Screen_Height - 49) style:UITableViewStyleGrouped];
    contentView.delegate = self;
    contentView.dataSource = self;
    contentView.separatorStyle = UITableViewCellSeparatorStyleNone;
    contentView.contentInset = UIEdgeInsetsMake(Height_TabbleViewInset, 0, 0, 0);
    _contentView = contentView;
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.estimatedRowHeight = 0;
    contentView.estimatedSectionFooterHeight = 0;
    contentView.estimatedSectionHeaderHeight = 0;
    
    [contentView registerClass:[ZZTFindCommentCell class] forCellReuseIdentifier:findCommentCell];
    
    [self.view addSubview:contentView];
    
    [self.contentView.mj_footer setHidden:YES];
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

//刷新数据
-(void)loadData{
    UserInfo *user = [Utilities GetNSUserDefaults];
    //请求世界数据
    NSDictionary *dic = @{
                          @"pageNum":@"1",
                          @"pageSize":[NSString stringWithFormat:@"%ld",self.pageSize],
                          @"userId":[NSString stringWithFormat:@"%ld",user.id],
                          @"type":@"1"//1.世界 2.关注
                          };
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    [manager POST:[ZZTAPI stringByAppendingString:@"circle/selDiscover"] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [[EncryptionTools alloc] decry:responseObject[@"result"]];
//        NSDictionary *dic = [NSString alloc]desc  description];
        if(dic.count >= 6){
            NSInteger total = [[NSString stringWithFormat:@"%@",[dic objectForKey:@"total"]] integerValue];
            
            NSMutableArray *array = [ZZTMyZoneModel mj_objectArrayWithKeyValuesArray:[dic objectForKey:@"list"]];
            
            self.dataArray = array;
            
            [self.contentView reloadData];
            
            if(self.dataArray.count >= total){
                [self.contentView.mj_header endRefreshing];
                [self.contentView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.contentView.mj_header endRefreshing];
            }
            self.pageSize += 10;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.contentView.mj_footer endRefreshing];
        [self.contentView.mj_header endRefreshing];
    }];
}

-(void)loadMoreData{
    UserInfo *user = [Utilities GetNSUserDefaults];
    //请求世界数据
    NSDictionary *dic = @{
                          @"pageNum":[NSString stringWithFormat:@"%ld",self.pageNumber],
                          @"pageSize":@"10",
                          @"userId":[NSString stringWithFormat:@"%ld",user.id],
                          @"type":@"1"//1.世界 2.关注
                          };
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    [manager POST:[ZZTAPI stringByAppendingString:@"circle/selDiscover"] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [[EncryptionTools alloc] decry:responseObject[@"result"]];
        
        NSInteger total = [[NSString stringWithFormat:@"%@",[dic objectForKey:@"total"]] integerValue];
        
        NSMutableArray *array = [ZZTMyZoneModel mj_objectArrayWithKeyValuesArray:[dic objectForKey:@"list"]];
        
        [self.dataArray addObjectsFromArray:array];
        
        [self.contentView reloadData];
        
        if(self.dataArray.count >= total){
            //            [self.contentView.mj_footer setHidden:YES];
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

#pragma mark - 设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return 0;
    }else{
        [self.contentView.mj_footer setHidden:NO];
        return self.dataArray.count;
    }
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

#pragma mark 高度设置
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZZTMyZoneModel *model = _dataArray[indexPath.row];
    NSArray *imgs = [model.contentImg componentsSeparatedByString:@","];
    return  [GlobalUI cellHeightWithModel:model];
}

#pragma mark - headView
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0){
        //作者
        static NSString *findBannerView = @"findBannerView";
        self.bannerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:findBannerView];
        //如果没有头视图
        if(!_bannerView){
            _bannerView = [[ZZTFindBannerView alloc] initWithReuseIdentifier:findBannerView];
        }
        _bannerView.imageArray = @"1";
        return _bannerView;
    }else{
        UIView *view = [[UIView alloc] init];
        return view;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return SCREEN_HEIGHT * 0.36;
    }else{
        return 0.1f;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(section == 0){
        //作者
        static NSString *zoneImageView = @"zoneImageView";
        self.zoneImageView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:zoneImageView];
        //如果没有头视图
        if(!_zoneImageView){
            _zoneImageView = [[ZZTZoneImageView alloc] initWithReuseIdentifier:zoneImageView];
        }
        _zoneImageView.image = [UIImage imageNamed:@"ziZaiKongJian"];
        return _zoneImageView;
    }else{
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
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 0){
        return SCREEN_HEIGHT * 0.125;
    }else{
        return SCREEN_HEIGHT * 0.34;
    }
}

-(ZZTCaiNiXiHuanView *)caiNiXiHuanView{
    if(!_caiNiXiHuanView){
        _caiNiXiHuanView = [[ZZTCaiNiXiHuanView alloc] initWithFrame:CGRectZero];
    }
    return _caiNiXiHuanView;
}

-(ZZTFindBannerView *)bannerView{
    if(!_bannerView){
        _bannerView = [[ZZTFindBannerView alloc] initWithFrame:CGRectZero];
    }
    return _bannerView;
}
-(ZZTZoneImageView *)zoneImageView{
    if(!_zoneImageView){
        _zoneImageView = [[ZZTZoneImageView alloc] initWithFrame:CGRectZero];
    }
    return _zoneImageView;
}


//是否隐藏navBar
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.y;
    
    //通知
    NSDictionary *dataDic = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%f",offset] forKey:@"navHidden"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"infoNotification" object:nil userInfo:dataDic];
    
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

//刷新NavBar的zhuang'ta
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [_contentView.mj_header beginRefreshing];
    [self scrollViewDidScroll:_contentView];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

//#pragma mark 预加载
////当view开始减速的时候
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{   //预加载
//    [self prefetchImagesForTableView:self.contentView];
//}
//
////当view已经停止的时候
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{   //预加载
//    if(!decelerate){
//        [self prefetchImagesForTableView:self.contentView];
//    }
//}
//
//-(void)prefetchImagesForTableView:(UITableView *)tableView{
//
//    NSArray *indexPaths = [self.contentView indexPathsForVisibleRows];
//
//    //获取显示出来的行
//    //如果行为0 不继续执行
//    if ([indexPaths count] == 0) return;
//    //显示出来的第一行
//    NSIndexPath *minimumIndexPath = indexPaths[0];
//    //显示出来的最后一行
//    NSIndexPath *maximumIndexPath = [indexPaths lastObject];
//    //遍历
//
//    for (NSIndexPath *indexPath in indexPaths)
//    {   //得到最小行 和 最大行
//        if (indexPath.section < minimumIndexPath.section || (indexPath.section == minimumIndexPath.section && indexPath.row < minimumIndexPath.row)) minimumIndexPath = indexPath;
//        if (indexPath.section > maximumIndexPath.section || (indexPath.section == maximumIndexPath.section && indexPath.row > maximumIndexPath.row)) maximumIndexPath = indexPath;
//    }
//
//    //  预加载的图片数组
//    NSMutableArray *imageURLs = [NSMutableArray array];
//
//    indexPaths = [self tableView:tableView priorIndexPathCount:3 fromIndexPath:minimumIndexPath];
//
//    for (NSIndexPath *indexPath in indexPaths){
//        ZZTMyZoneModel *model = self.dataArray[indexPath.row];
//        [imageURLs addObject:model.contentImg];
//    }
//
//    //获取下面的行数
//    indexPaths = [self tableView:tableView nextIndexPathCount:3 fromIndexPath:maximumIndexPath];
//
//    for (NSIndexPath *indexPath in indexPaths){
//        if(indexPath.section == 0){
//            ZZTMyZoneModel *model = self.dataArray[indexPath.row];
//            [imageURLs addObject:model.contentImg];
//        }
//    }
//
//    // now prefetch
//    if ([imageURLs count] > 0)
//    {
//        [[SDWebImagePrefetcher sharedImagePrefetcher] prefetchURLs:imageURLs];
//    }
//
//
//
//}
//
//- (NSArray *)tableView:(UITableView *)tableView priorIndexPathCount:(NSInteger)count fromIndexPath:(NSIndexPath *)indexPath
//{
//
//
//    NSMutableArray *indexPaths = [NSMutableArray array];
//    NSInteger row = indexPath.row;
//    NSInteger section = indexPath.section;
//
//    for (NSInteger i = 0; i < count; i++) {
//        //如果是第一行不再进行
//        if (row == 0) {
//            if (section == 0) {
//                return indexPaths;
//            } else {
//                //如果不是第一节
//                section--;
//                row = [tableView numberOfRowsInSection:section] - 1;
//            }
//        } else {
//            row--;
//        }
//        if(row < 0){
//            break;
//        }else{
//            [indexPaths addObject:[NSIndexPath indexPathForRow:row inSection:section]];
//            NSLog(@"priorIndexPathCount:%ld row:%ld",section,row);
//        }
//    }
//    return indexPaths;
//}
//
////获取下行的数据索引
//- (NSArray *)tableView:(UITableView *)tableView nextIndexPathCount:(NSInteger)count fromIndexPath:(NSIndexPath *)indexPath
//{
//    //创建数组
//    NSMutableArray *indexPaths = [NSMutableArray array];
//    //第几行
//    NSInteger row = indexPath.row;
//    //第几节
//    NSInteger section = indexPath.section;
//    //这一节有多少行
//    NSInteger rowCountForSection = [tableView numberOfRowsInSection:section];
//    //需要获取几行数据
//    for (NSInteger i = 0; i < count; i++) {
//        //下一行
//        row++;
//        //如果row是最后一行
//        if (row == rowCountForSection) {
//            return indexPaths;
//        }
//        [indexPaths addObject:[NSIndexPath indexPathForRow:row inSection:section]];
//        NSLog(@"nextIndexPathCount:%ld row:%ld",section,row);
//    }
//    return indexPaths;
//}


@end
