//
//  ZZTMyZoneViewController.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/9/20.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTMyZoneViewController.h"
#import "ZZTMyZoneModel.h"
#import "ZZTMyZoneCell.h"
#import "ZZTCreationCartoonTypeViewController.h"
#import "ZZTMyZoneHeaderView.h"
static const CGFloat MJDuration = 2.0;

@interface ZZTMyZoneViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView * tabelView;
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,strong)NSString *pageNumber;
@property (nonatomic,assign)NSInteger total;

@end

NSString *myZoneCell = @"myZoneCell";

@implementation ZZTMyZoneViewController

-(NSMutableArray *)dataArray{
    if(!_dataArray){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的空间";
    self.view.backgroundColor = [UIColor whiteColor];
    self.pageNumber = @"0";

    //tabView
    _tabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Screen_Height) style:UITableViewStylePlain];
    _tabelView.delegate = self;
    _tabelView.dataSource = self;
    [_tabelView registerClass:[UITableViewCell class] forCellReuseIdentifier:myZoneCell];
    [self.view addSubview:_tabelView];
    
    //头视图
    ZZTMyZoneHeaderView *headView = [[ZZTMyZoneHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 280)];
    headView.user = [Utilities GetNSUserDefaults];
    _tabelView.tableHeaderView = headView;
    
    //数据源
    [self loadData];

    //cell 1 编辑 跳编辑器
    //cell 2 时间 内容 图片
    [self setupMJRefresh];
}

-(void)setupMJRefresh{
    self.tabelView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadData];
    }];
//    [self.tabelView.mj_footer beginRefreshing];
}

-(void)loadData{
    //请求世界数据
    NSDictionary *dic = @{
//                          @"pageNum":self.pageNumber,
                        @"pageNum":@"0",
                          @"pageSize":@"3",
//                          @"userId":[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]
                          @"userId":@"3"
                          };
    [AFNHttpTool POST:[ZZTAPI stringByAppendingString:@"circle/selUserRoom"] parameters:dic success:^(id responseObject) {
        NSDictionary *dic = [[EncryptionTools sharedEncryptionTools] decry:responseObject[@"result"]];
        id to = [dic objectForKey:@"total"];
        NSInteger total = [to integerValue];
        self.total = total;
        NSArray *list = [dic objectForKey:@"list"];
        NSMutableArray *array = [ZZTMyZoneModel mj_objectArrayWithKeyValuesArray:list];
        [self.dataArray addObjectsFromArray:array];
        [self.tabelView reloadData];
        if(self.dataArray.count >= total){
            [self.tabelView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.tabelView.mj_footer endRefreshing];
        }
        //page+size
        self.pageNumber = [NSString stringWithFormat:@"%ld",([self.pageNumber integerValue] + 3)];
    } failure:^(NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    self.tabelView.mj_footer.hidden = (_dataArray.count == 0);
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return 170;
    }
    ZZTMyZoneModel *model = _dataArray[indexPath.row];
    NSArray *imgs = [model.contentImg componentsSeparatedByString:@","];
    return  [ZZTMyZoneCell cellHeightWithStr:model.content imgs:imgs];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myZoneCell];
        if(indexPath.row == 0){
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myZoneCell];
            //今天
            UILabel *dateLab = [GlobalUI createLabelFont:25 titleColor:[UIColor blackColor] bgColor:[UIColor whiteColor]];
            dateLab.frame = CGRectMake(10, 10, 100, 30);
            dateLab.text = @"今天";
            [cell.contentView addSubview:dateLab];
            //编写button
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(dateLab.frame) + 10, 80, 80)];
            button.backgroundColor = [UIColor greenColor];
            [button setBackgroundImage:[UIImage imageNamed:@"正文-续"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(startCreate) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:button];
            //底线
            UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(button.frame), SCREEN_WIDTH, 1)];
            bottomView.backgroundColor = [UIColor grayColor];
            [cell.contentView addSubview:bottomView];
            return cell;
        }else{
            ZZTMyZoneCell * cell = [ZZTMyZoneCell dynamicCellWithTable:tableView];
            cell.model = _dataArray[indexPath.row];
            return cell;
        }
    return cell;
}
-(void)startCreate{
    ZZTCreationCartoonTypeViewController *view = [[ZZTCreationCartoonTypeViewController alloc] init];
    [self.navigationController pushViewController:view animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 280;
}
@end
