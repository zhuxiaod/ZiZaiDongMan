//
//  ZZTRankViewController.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/8/21.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTRankViewController.h"
#import "RankButton.h"
#import "ZZTRankCell.h"
#import "ZZTCartonnPlayModel.h"

@interface ZZTRankViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *array;

@property (nonatomic,strong) UIView *topView;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,assign) NSInteger pageNumber;

@property (nonatomic,assign) NSInteger pageSize;

@end

NSString *zztRankCell = @"zztRankCell";

@implementation ZZTRankViewController

-(NSMutableArray *)array{
    if(!_array){
        _array = [NSMutableArray array];
    }
    return _array;
}

-(NSMutableArray *)dataArray{
    if(!_dataArray){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F0F1F2"];
    //4个btn
//    [self setupTopView];
    
    
    self.pageSize = 10;
    
    //默认男生
//    [self manTarget:self.array[0]];
    
    //下view
    [self setupTableView];
    
    [self.viewNavBar.centerButton setTitle:@"排行榜" forState:UIControlStateNormal];
    
    self.viewNavBar.backgroundColor = [UIColor whiteColor];
    
    [self addBackBtn];

    [self setupMJRefresh];

    [self.tableView.mj_header beginRefreshing];
    
    self.pageNumber = 2;
}

-(void)setupMJRefresh{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadNewData];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadData];
    }];
}

-(void)loadNewData{
    NSDictionary *dic = @{
                          //众创
                          @"pageNum":@"1",
                          @"pageSize":[NSString stringWithFormat:@"%ld",self.pageSize]
                          };
    
    AFHTTPSessionManager *manager = [SBAFHTTPSessionManager getManager];
    [manager POST:[ZZTAPI stringByAppendingString:@"cartoon/getCartoonRanking"] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [[EncryptionTools alloc] decry:responseObject[@"result"]];
        
        NSMutableArray *array = [ZZTCarttonDetailModel mj_objectArrayWithKeyValuesArray:dic[@"list"]];
        
//        array = [self addIsHave:array];
        
        self.dataArray = array;
        
        [self.tableView reloadData];

        [self.tableView.mj_header endRefreshing];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self.tableView.mj_header endRefreshing];
        
    }];
}

-(void)loadData{
    
    NSDictionary *dic = @{
                          //众创
                          @"pageNum":[NSString stringWithFormat:@"%ld",self.pageNumber],
                          @"pageSize":@"10"
                          };
    
    AFHTTPSessionManager *manager = [SBAFHTTPSessionManager getManager];
    [manager POST:[ZZTAPI stringByAppendingString:@"cartoon/getCartoonRanking"] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [[EncryptionTools alloc] decry:responseObject[@"result"]];
        NSMutableArray *array = [ZZTCarttonDetailModel mj_objectArrayWithKeyValuesArray:dic[@"list"]];
        
        id to = [dic objectForKey:@"total"];
        NSInteger total = [to integerValue];
        array = [self addIsHave:array];
        
        [self.dataArray addObjectsFromArray:array];
        
        [self.tableView reloadData];
        
        if(self.dataArray.count >= total){
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
        //page+size
        self.pageNumber++;
        self.pageSize += 10;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_footer endRefreshing];
    }];
}

-(NSMutableArray *)addIsHave:(NSMutableArray *)array{
    for (int i = 0; i < array.count; i++) {
        ZZTCarttonDetailModel *model = array[i];
        model.isHave = NO;
    }
    return array;
}

-(void)setupTopView{
    //上view
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, navHeight, SCREEN_WIDTH, 50)];
    topView.backgroundColor = [UIColor whiteColor];
    _topView = topView;
    [self.view addSubview:topView];
    
    CGFloat btnViewW = SCREEN_WIDTH - 100;
    UIView *btnView = [[UIView alloc] init];
    btnView.frame = CGRectMake((SCREEN_WIDTH - btnViewW)/2, 5, btnViewW, topView.height - 10);
    [topView addSubview:btnView];
    
    CGFloat btnW = 60;
    CGFloat btnH = btnView.height;
    CGFloat space = (btnViewW - btnW*4)/3;
    
    RankButton *man = [[RankButton alloc] init];
    [man setTitle:@"男生榜" forState:UIControlStateNormal];
    [man setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    man.frame = CGRectMake(0, 0, btnW, btnH);
    [man addTarget:self action:@selector(manTarget:) forControlEvents:UIControlEventTouchUpInside];
    man.rankType = @"7";
    [btnView addSubview:man];
    
    RankButton *woman = [[RankButton alloc] init];
    [woman setTitle:@"女生榜" forState:UIControlStateNormal];
    [woman setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [woman addTarget:self action:@selector(manTarget:) forControlEvents:UIControlEventTouchUpInside];
    woman.rankType = @"8";

    woman.frame = CGRectMake(man.x + btnW + space, 0, btnW, btnH);

    [btnView addSubview:woman];
    
    RankButton *multiplayer = [[RankButton alloc] init];
    [multiplayer setTitle:@"众创榜" forState:UIControlStateNormal];
    [multiplayer setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    multiplayer.frame = CGRectMake(woman.x + btnW + space, 0, btnW, btnH);
    [multiplayer addTarget:self action:@selector(manTarget:) forControlEvents:UIControlEventTouchUpInside];
    multiplayer.rankType = @"1";
    [btnView addSubview:multiplayer];
    
    RankButton *boom = [[RankButton alloc] init];
    [boom setTitle:@"畅销榜" forState:UIControlStateNormal];
    [boom setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    boom.frame = CGRectMake(multiplayer.x + btnW + space, 0, btnW, btnH);
    [boom addTarget:self action:@selector(manTarget:) forControlEvents:UIControlEventTouchUpInside];
    boom.rankType = @"5";
    [btnView addSubview:boom];
    
    NSMutableArray *array = [NSMutableArray arrayWithObjects:man,woman,multiplayer,boom, nil];
    self.array = array;
}

-(void)manTarget:(RankButton *)btn{
    for (RankButton *button in self.array) {
        if(button == btn){
            [btn setTitleColor:[UIColor colorWithHexString:@"#7B7BE4"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"排行榜-当前榜单"] forState:UIControlStateNormal];
            [self loadData];
        }else{
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setImage:nil forState:UIControlStateNormal];
        }
    }
}

-(void)setupTableView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Height_NavBar, SCREEN_WIDTH, SCREEN_HEIGHT - self.topView.height + 10 - navHeight) style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.estimatedRowHeight = [Utilities getCarChapterH] + 24 + 15;
    _tableView = tableView;
    [self.view addSubview:tableView];
    //注册
    [tableView registerNib:[UINib nibWithNibName:@"ZZTRankCell" bundle:nil] forCellReuseIdentifier:zztRankCell];
    tableView.contentInset = UIEdgeInsetsMake(-30, 0, 0, 0);
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
    ZZTRankCell *cell = [tableView dequeueReusableCellWithIdentifier:zztRankCell];
    ZZTCarttonDetailModel *model = self.dataArray[indexPath.row];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSString *index = [NSString stringWithFormat:@"%ld",indexPath.row];
    cell.currentIndex = index;
    cell.cellIndex = indexPath.row;
    cell.dataModel = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ZZTCarttonDetailModel *md = self.dataArray[indexPath.row];
        ZZTWordDetailViewController *detailVC = [[ZZTWordDetailViewController alloc]init];
        detailVC.isId = YES;
        detailVC.cartoonDetail = md;
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark 高度设置
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //根据点击的不同 判断应该有多少高度
    return  [Utilities getCarChapterH] + 24 + 15;
}
@end
