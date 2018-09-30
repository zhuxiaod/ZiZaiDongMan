//
//  ZZTMoreViewController.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/7/19.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTMoreViewController.h"
#import "ZZTWordCell.h"
#import "ZZTWordDetailViewController.h"
#import "ZZTMulWordDetailViewController.h"

static const CGFloat MJDuration = 1.0;

@interface ZZTMoreViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong)NSString *pageNumber;

@end

NSString *WordCell = @"WordCell";

@implementation ZZTMoreViewController

-(NSMutableArray *)dataArray{
    if(!_dataArray){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNumber = @"0";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"更多推荐";
    
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
    [self setupTableView];
    
    [self loadMoreData];
    
    [self setupMJRefresh];
    
    NSString *pageNumber = [NSString stringWithFormat:@"0"];

}
-(void)setupMJRefresh{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadMoreData];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
       
        [self loadMoreData];
    }];
}
-(void)loadMoreData{
    NSDictionary *dic = @{
                          @"pageNum":self.pageNumber,
                          @"pageSize":@"10"
                          };
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[ZZTAPI stringByAppendingString:@"cartoon/getRecommendCartoon"] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [[EncryptionTools sharedEncryptionTools] decry:responseObject[@"result"]];
        NSMutableArray *array = [ZZTCarttonDetailModel mj_objectArrayWithKeyValuesArray:dic];
//        self.dataArray = array;
        [self.dataArray addObjectsFromArray:array];
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            // 结束刷新
            [self.tableView.mj_footer endRefreshing];
        });

        [self.tableView.mj_header endRefreshing];

        self.pageNumber = [NSString stringWithFormat:@"%ld",([self.pageNumber integerValue] + 10)];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(void)setupTableView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor whiteColor];
    _tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    //注册
    [tableView registerNib:[UINib nibWithNibName:@"ZZTWordCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:WordCell];
    [self.view addSubview:tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    self.tableView.mj_footer.hidden = (_dataArray.count == 0);
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZZTCarttonDetailModel *model = self.dataArray[indexPath.row];
    ZZTWordCell *cell = [tableView dequeueReusableCellWithIdentifier:WordCell];
    cell.model = model;
    cell.textLabel.text = @"朱晓俊";
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ZZTCarttonDetailModel *model = self.dataArray[indexPath.row];
    if([model.cartoonType isEqualToString:@"1"]){
        ZZTWordDetailViewController *detailVC = [[ZZTWordDetailViewController alloc]init];
        detailVC.cartoonDetail = model;
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
    }else{
        ZZTMulWordDetailViewController *detailVC = [[ZZTMulWordDetailViewController alloc]init];
        detailVC.cartoonDetail = model;
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}
@end
