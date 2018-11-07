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

@interface ZZTFindWorldViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,UICollectionViewDelegate>

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) UITableView *contentView;

@property (nonatomic,assign) NSInteger pageNumber;

@property (nonatomic,strong) NSArray *imagesURLStrings;

@property (nonatomic,strong) ZZTFindBannerView *bannerView;

@property (nonatomic,strong) ZZTZoneImageView *zoneImageView;


@end

static NSString *CaiNiXiHuanView1 = @"CaiNiXiHuanView1";

@implementation ZZTFindWorldViewController

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
    
    self.pageNumber = 0;
//    [self loadData];
    
//    //banner数据
    self.imagesURLStrings = [NSArray arrayWithObjects: @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1535282045025&di=b648e41d5d5a3535e5518a545459d351&imgtype=0&src=http%3A%2F%2Fimg.mp.itc.cn%2Fupload%2F20161123%2Fbfa082e23cd94089a907a29b021946bf_th.jpeg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1535282045025&di=d2ddcf88c11b57887d64db25c870bd4f&imgtype=0&src=http%3A%2F%2F5b0988e595225.cdn.sohucs.com%2Fimages%2F20170919%2F210211af972f4e3c8c5a7fda0fda7493.jpeg", nil];
    
    [self setupMJRefresh];
    
    [self.contentView.mj_header beginRefreshing];
    

}


-(void)setupTableView{
    UITableView *contentView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Screen_Height - 49) style:UITableViewStyleGrouped];
    contentView.delegate = self;
    contentView.dataSource = self;
    contentView.separatorStyle = UITableViewCellSeparatorStyleNone;
    contentView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    _contentView = contentView;
    contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentView];
}

-(void)setupMJRefresh{
    self.contentView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
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
                          @"type":@"1"
                          };
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
        self.pageNumber += 12;
        [self.contentView.mj_header endRefreshing];
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
        return self.dataArray.count;
    }
}

#pragma mark - 内容设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZZTFindCommentCell *cell = [ZZTFindCommentCell dynamicCellWithTable:tableView];
    cell.btnBlock = ^(ZZTFindCommentCell *cell,ZZTMyZoneModel *model,BOOL yesOrNo) {
        NSIndexPath *indexPath = [tableView indexPathForCell:cell];
        [self.dataArray replaceObjectAtIndex:indexPath.row withObject:model];
        if(yesOrNo == YES){
            //点赞接口
        }else{
            //关注接口
            [self loadAttention:model];
        }
    };
    cell.model = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)loadAttention:(ZZTMyZoneModel *)model{
    UserInfo *user = [Utilities GetNSUserDefaults];
    NSDictionary *dic = @{
                          @"userId":[NSString stringWithFormat:@"%ld",user.id],
                          @"authorId":model.userId
                          };
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    [manager POST:[ZZTAPI stringByAppendingString:@"record/ifUserAtAuthor"]  parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

#pragma mark 高度设置
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZZTMyZoneModel *model = _dataArray[indexPath.row];
    NSArray *imgs = [model.contentImg componentsSeparatedByString:@","];
    return  [ZZTFindCommentCell cellHeightWithStr:model.content imgs:imgs];
}

#pragma mark - headView
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //作者
    static NSString *findBannerView = @"findBannerView";
    self.bannerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:findBannerView];
    //如果没有头视图
    if(!_bannerView){
        _bannerView = [[ZZTFindBannerView alloc] initWithReuseIdentifier:findBannerView];
    }
    _bannerView.imageArray = @"1";
    return _bannerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return SCREEN_HEIGHT * 0.36;
    }else{
        return 0;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    //作者
    static NSString *zoneImageView = @"zoneImageView";
    self.zoneImageView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:zoneImageView];
    //如果没有头视图
    if(!_zoneImageView){
        _zoneImageView = [[ZZTZoneImageView alloc] initWithReuseIdentifier:zoneImageView];
    }
    _zoneImageView.image = [UIImage imageNamed:@"ziZaiKongJian"];
    return _zoneImageView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 0){
        return SCREEN_HEIGHT * 0.14;
    }else{
        return 0;
    }
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.y;
    
    //通知
    NSDictionary *dataDic = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%f",offset] forKey:@"navHidden"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"infoNotification" object:nil userInfo:dataDic];
}
@end
