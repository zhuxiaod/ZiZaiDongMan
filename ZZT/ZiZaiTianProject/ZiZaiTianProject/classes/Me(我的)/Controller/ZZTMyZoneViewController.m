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
#import "ZZTMEXuHuaCell.h"
#import "ZZTZoneUpLoadViewController.h"

static const CGFloat MJDuration = 1.0;


static NSString *myZoneCell = @"myZoneCell";

@interface ZZTMyZoneViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView * tabelView;

@property (nonatomic,strong)NSMutableArray * dataArray;

@property (nonatomic,strong)NSString *pageNumber;

@property (nonatomic,strong)NSString *pageSize;

@property (nonatomic,assign)NSInteger total;

@property (nonatomic,strong) ZZTMyZoneHeaderView *zoneHeadView;

@property (nonatomic,assign) ZXDNavBar *navbar;

@property (nonatomic,strong) UserInfo *userData;

@property (nonatomic,strong) UIImageView *underLineView;

@end


NSString *zztMEXuHuaCell = @"zztMEXuHuaCell";

@implementation ZZTMyZoneViewController

/*
 两种情况
 1.为根视图时  影藏navBar
 2.不为根视图  push
 */

-(NSMutableArray *)dataArray{
    if(!_dataArray){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(void)setUser:(UserInfo *)user{
    _user = user;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.pageNumber = @"2";
    self.pageSize = @"5";
    
    [self setupContentView];
    
    //数据源

    //cell 1 编辑 跳编辑器
    //cell 2 时间 内容 图片
//    [self loadUserData];
//    [self loadData];
    [self setupMJRefresh];
    
    //上传图片
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"上传" target:self action:@selector(pushUploadView) titleColor:[UIColor whiteColor]];
    
    //NavBar
    [self setupNavBar];
    
    [self setupUnderLineView];
}

-(void)setupUnderLineView{
    //禁止滑动
    //潜水图
    UIImageView *underLineView = [[UIImageView alloc] init];
    [underLineView setImage:[UIImage imageNamed:@"me_zone_underLine"]];
    underLineView.contentMode = UIViewContentModeScaleAspectFill;
    _underLineView = underLineView;
    [self.view addSubview:underLineView];
    
    [underLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(SCREEN_HEIGHT * 0.46);
        make.right.left.bottom.equalTo(self.view);
    }];
    underLineView.hidden = YES;
    

}

-(void)setupNavBar{
    
    self.viewNavBar.showBottomLabel = NO;

    //返回
    [self.viewNavBar.leftButton setImage:[UIImage imageNamed:@"返回键"] forState:UIControlStateNormal];
    self.viewNavBar.leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 17);
    [self.viewNavBar.leftButton addTarget:self action:@selector(dismissVC) forControlEvents:UIControlEventTouchUpInside];
    self.viewNavBar.backgroundColor = [UIColor clearColor];
    
    //中
    SBStrokeLabel *lab = [[SBStrokeLabel alloc] init];
    lab.text = @"空间";

    [lab labOutline];
    [lab setTextColor:[UIColor whiteColor]];
    [self.viewNavBar addSubview:lab];
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.viewNavBar.centerButton.mas_top);
        make.bottom.equalTo(self.viewNavBar.centerButton.mas_bottom);
        make.centerX.equalTo(self.viewNavBar.centerButton);
        make.centerY.equalTo(self.viewNavBar.centerButton);
    }];
    
    if(self.viewNavBarHidden == YES){
        self.viewNavBar.hidden = YES;
    }
}

-(void)dismissVC{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setupContentView{
    //tabView
    _tabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Screen_Height) style:UITableViewStyleGrouped];
    _tabelView.delegate = self;
    _tabelView.dataSource = self;
    _tabelView.contentInset = UIEdgeInsetsMake(Height_TabbleViewInset, 0, 0, 0);
    _tabelView.backgroundColor = [UIColor whiteColor];
    [_tabelView registerClass:[ZZTMyZoneCell class] forCellReuseIdentifier:myZoneCell];
    [_tabelView registerClass:[ZZTMEXuHuaCell class] forCellReuseIdentifier:zztMEXuHuaCell];
    self.tabelView.separatorStyle = UITableViewCellEditingStyleNone;     //让tableview不显示分割线
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _tabelView.estimatedRowHeight = 0;
    _tabelView.estimatedSectionFooterHeight = 0;
    _tabelView.estimatedSectionHeaderHeight = 0;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.view addSubview:_tabelView];
}

//跳转上传页
-(void)pushUploadView{
    
    ZZTZoneUpLoadViewController *upLoadVC = [[ZZTZoneUpLoadViewController alloc] init];
    
    [self presentViewController:upLoadVC animated:YES completion:nil];
}

-(void)setupMJRefresh{
    
    self.tabelView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
        [self loadUserData];
    }];
    
    self.tabelView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreData];
    }];
    
}

-(void)loadMoreData{
    //请求世界数据
    NSDictionary *dic = @{
                          @"pageNum":self.pageNumber,
                          //                        @"pageNum":@"0",
                          @"pageSize":@"5",
                          //                          @"userId":[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]
                          //传什么id 显示谁的空间
                          @"userId":_userId
                          };
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    [manager POST:[ZZTAPI stringByAppendingString:@"circle/selUserRoom"] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [[EncryptionTools alloc] decry:responseObject[@"result"]];
        
        NSInteger total = [[dic objectForKey:@"total"] integerValue];
        self.total = total;
        
        NSArray *list = [dic objectForKey:@"list"];
        NSMutableArray *array = [ZZTMyZoneModel mj_objectArrayWithKeyValuesArray:list];
        
        [self.dataArray addObjectsFromArray:array];
        
        [self.tabelView reloadData];
        
        if(self.dataArray.count >= total){
            [self.tabelView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.tabelView.mj_footer endRefreshing];
            //page+size
            self.pageNumber = [NSString stringWithFormat:@"%ld",([self.pageNumber integerValue] + 1)];
            self.pageSize = [NSString stringWithFormat:@"%ld",([self.pageSize integerValue] + 5)];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tabelView.mj_footer endRefreshing];
    }];
}

-(void)loadData{

    //请求世界数据
    NSDictionary *dic = @{
                          @"pageNum":@"1",
//                        @"pageNum":@"0",
                          @"pageSize":self.pageSize,
//                          @"userId":[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]
                          //传什么id 显示谁的空间
                          @"userId":_userId
                          };
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    [manager POST:[ZZTAPI stringByAppendingString:@"circle/selUserRoom"] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [[EncryptionTools alloc] decry:responseObject[@"result"]];
        if(dic.count != 6){
            NSInteger total = [[dic objectForKey:@"total"] integerValue];
            self.total = total;
            
            NSArray *list = [dic objectForKey:@"list"];
            NSMutableArray *array = [ZZTMyZoneModel mj_objectArrayWithKeyValuesArray:list];
            
            self.dataArray = array;
            
            [self.tabelView reloadData];
            
            if(self.dataArray.count >= total){
                [self.tabelView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tabelView.mj_header endRefreshing];
            }
        }
        [self.tabelView.mj_header endRefreshing];
        //page+size
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tabelView.mj_header endRefreshing];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    self.tabelView.mj_footer.hidden = (_dataArray.count == 0);
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    ZZTMyZoneModel *model = _dataArray[indexPath.row];
    NSArray *imgs = [model.contentImg componentsSeparatedByString:@","];
    return  [ZZTMyZoneCell cellHeightWithStr:model.content imgs:imgs];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZZTMyZoneCell * cell = [tableView dequeueReusableCellWithIdentifier:myZoneCell forIndexPath:indexPath];
    cell.update = ^{
        [self loadData];
    };
    cell.LongPressBlock = ^(ZZTMyZoneModel *message) {
        [self reportUserData:message];
    };
    cell.model = _dataArray[indexPath.row];
    return cell;

}

-(void)reportUserData:(ZZTMyZoneModel *)messageData{
    //弹出举报框
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *reportBtn = [UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
//        NSLog(@"%@ : %@",messageData.nickName,messageData.content);
        [self gotoReportVCWithModel:messageData];

    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了取消");
    }];
    
    [actionSheet addAction:reportBtn];
    [actionSheet addAction:action2];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}

-(void)gotoReportVCWithModel:(ZZTMyZoneModel *)reportMessage{
    ZZTReportViewController *reportVC = [[ZZTReportViewController alloc] init];
    reportVC.reportData = reportMessage;
    [self.navigationController pushViewController:reportVC animated:YES];
}

-(void)startCreate{
    ZZTCreationCartoonTypeViewController *view = [[ZZTCreationCartoonTypeViewController alloc] init];
    [self.navigationController pushViewController:view animated:YES];
}

#pragma mark - headView
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //作者
    static NSString *zoneHeadViewIf = @"zoneHeadViewIf";
    self.zoneHeadView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:zoneHeadViewIf];
    //如果没有头视图
    if(!_zoneHeadView){
        _zoneHeadView = [[ZZTMyZoneHeaderView alloc] initWithReuseIdentifier:zoneHeadViewIf];
    }
//    UserInfo *user = [Utilities GetNSUserDefaults];
    self.zoneHeadView.user = self.userData;

    return _zoneHeadView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return SCREEN_HEIGHT * 0.36;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.tabelView.mj_header beginRefreshing];
    
    self.navigationController.navigationBar.alpha = 0;

    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

#pragma mark - lazy load
-(ZZTMyZoneHeaderView *)zoneHeadView{
    if(!_zoneHeadView){
        _zoneHeadView = [[ZZTMyZoneHeaderView alloc] initWithFrame:CGRectZero];
    }
    return _zoneHeadView;
}
//向下滑 显示不同navbar
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY < 64) {
        offsetY = 64;
    }
    
    CGFloat alpha = offsetY * 1 / 136.0;   // (200 - 64) / 136.0f
    if (alpha >= 1) {
        alpha = 0.5;
    }
    if(offsetY == 64){
        self.navbar.backgroundColor = [UIColor clearColor];
    }else{
        self.navbar.backgroundColor = [UIColor colorWithWhite:0 alpha:alpha];
    }
}

-(void)setUserId:(NSString *)userId{
    _userId = userId;
    //请求个人资料
    if([userId isEqualToString:@"0"]){
   
        //添加一张图片
        self.underLineView.hidden = NO;
        self.tabelView.scrollEnabled = NO;
    }else{
        self.underLineView.hidden = YES;
        self.tabelView.scrollEnabled = YES;
    }
   
    [self.tabelView.mj_header beginRefreshing];
}

-(void)loadUserData{
    NSDictionary *paramDict = @{
                                @"userId":_userId
                                };
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    [manager POST:[ZZTAPI stringByAppendingString:@"login/usersInfo"] parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [[EncryptionTools alloc] decry:responseObject[@"result"]];
        
        NSArray *array = [UserInfo mj_objectArrayWithKeyValuesArray:dic];
        if(array.count != 0){
            UserInfo *model = array[0];
            self.userData = model;
            self.zoneHeadView.user = model;
            [self.tabelView reloadData];
        }else{
            self.userData = nil;
            [self.tabelView reloadData];
        }
        [self.tabelView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tabelView.mj_header endRefreshing];
    }];
}
@end
