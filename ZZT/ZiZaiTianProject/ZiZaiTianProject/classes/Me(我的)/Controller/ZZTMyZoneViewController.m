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
#import "ZZTMyZoneHeaderView.h"
#import "ZZTZoneUpLoadViewController.h"
#import "ZZTZoneWordView.h"
#import "ZZTStatusViewModel.h"

static const CGFloat MJDuration = 1.0;


static NSString *myZoneCell = @"myZoneCell";

@interface ZZTMyZoneViewController ()<UITableViewDataSource,UITableViewDelegate,ZZTReportBtnDelegate>

@property (nonatomic,strong)UITableView * tabelView;

@property (nonatomic,strong)NSMutableArray * dataArray;

@property (nonatomic,strong)NSString *pageNumber;

@property (nonatomic,strong)NSString *pageSize;

@property (nonatomic,assign)NSInteger total;

@property (nonatomic,strong) ZZTMyZoneHeaderView *zoneHeadView;

@property (nonatomic,assign) ZXDNavBar *navbar;

@property (nonatomic,strong) UserInfo *userData;

@property (nonatomic,strong) UIImageView *underLineView;
//作品view
@property (nonatomic,strong) ZZTZoneWordView *zoneWordView;

@end


@implementation ZZTMyZoneViewController

/*
 两种情况
 1.为根视图时  影藏navBar
 2.不为根视图  push
 */
-(ZZTZoneWordView *)zoneWordView{
    if(_zoneWordView == nil){
        _zoneWordView = [[ZZTZoneWordView alloc] initWithFrame:CGRectZero];
    
    }
    return _zoneWordView;
}

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
    [self setupMJRefresh];
    
    //上传图片
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"上传" target:self action:@selector(pushUploadView) titleColor:[UIColor whiteColor]];
    
    //NavBar
    [self setupNavBar];
    
    [self setupUnderLineView];

  
}

#pragma mark - 空间作品数据
-(void)loadZoneWordDate{
    NSDictionary *dic = @{
                          @"userId":_userId,
                          @"ifrelease":@"1",
                          @"pageNum":@"1",
                          @"pageSize":@"999"
                          };
    [SBAFHTTPSessionManager.sharedManager loadPostRequest:@"cartoon/getAuthorCartoon" paramDict:dic finished:^(id responseObject, NSError *error) {
        if(error != nil){
            NSLog(@"%@",error);
            return;
        }
        NSDictionary *dic = [[EncryptionTools alloc] decry:responseObject[@"result"]];
        NSMutableArray *array = [ZZTCarttonDetailModel mj_objectArrayWithKeyValuesArray:dic[@"list"]];
        self.zoneWordView.dataArray = array;
        if(self.zoneWordView.dataArray.count == 0){
            self.zoneWordView.hidden = YES;
        }
        [self.tabelView reloadData];
    }];
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
    [self.viewNavBar.leftButton setImage:[UIImage imageNamed:@"bordBack"] forState:UIControlStateNormal];
    self.viewNavBar.leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 17);
    [self.viewNavBar.leftButton addTarget:self action:@selector(dismissVC) forControlEvents:UIControlEventTouchUpInside];
    self.viewNavBar.backgroundColor = [UIColor clearColor];
    
    //中
    SBStrokeLabel *lab = [[SBStrokeLabel alloc] init];
    lab.text = @"空间";

    [lab labOutline];
    [lab setTextColor:[UIColor whiteColor]];
    [self.viewNavBar addSubview:lab];
    [self.view bringSubviewToFront:self.viewNavBar];
    
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
    [_tabelView registerNib:[UINib nibWithNibName:@"ZZTMyZoneCell" bundle:nil] forCellReuseIdentifier:myZoneCell];
    [_tabelView registerClass:[ZZTZoneWordView class] forHeaderFooterViewReuseIdentifier:@"zoneWordView"];
    self.tabelView.separatorStyle = UITableViewCellEditingStyleNone;     //让tableview不显示分割线
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _tabelView.rowHeight = UITableViewAutomaticDimension;
    _tabelView.estimatedRowHeight = 200;
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
        [self loadZoneWordDate];
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
                          @"pageSize":@"5",
                          //传什么id 显示谁的空间
                          @"userId":_userId, @"toUserId":SBAFHTTPSessionManager.sharedManager.userID
                          };
    AFHTTPSessionManager *manager = [SBAFHTTPSessionManager getManager];
    [manager POST:[ZZTAPI stringByAppendingString:@"circle/selUserRoom"] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.tabelView.mj_footer endRefreshing];

        NSDictionary *dic = [[EncryptionTools alloc] decry:responseObject[@"result"]];
        
        NSInteger total = [[dic objectForKey:@"total"] integerValue];
        self.total = total;
        
        NSArray *list = [dic objectForKey:@"list"];
        NSMutableArray *array = [ZZTMyZoneModel mj_objectArrayWithKeyValuesArray:list];
        
        for (ZZTMyZoneModel *model in array) {
            ZZTStatusViewModel *viewModel = [ZZTStatusViewModel initViewModel:model];
            [self.dataArray addObject:viewModel];
        }
        //下载图片
        [self cacheImages:self.dataArray];
        if(self.dataArray.count >= total){
            [self.tabelView.mj_footer endRefreshingWithNoMoreData];
        }
        //page+size
        self.pageNumber = [NSString stringWithFormat:@"%ld",([self.pageNumber integerValue] + 1)];
        self.pageSize = [NSString stringWithFormat:@"%ld",([self.pageSize integerValue] + 5)];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tabelView.mj_footer endRefreshing];
    }];
}

-(void)loadData{

    //请求世界数据
    NSDictionary *dic = @{
                          @"pageNum":@"1",
                          @"pageSize":self.pageSize,

                          //传什么id 显示谁的空间
                          @"userId":_userId,
                          @"toUserId":SBAFHTTPSessionManager.sharedManager.userID
                          };
    [SBAFHTTPSessionManager.sharedManager loadPostRequest:@"circle/selUserRoom" paramDict:dic finished:^(id responseObject, NSError *error) {
        [self.tabelView.mj_header endRefreshing];
        if (error != nil) {
            NSLog(@"%@",error);
            return;
        }
        NSDictionary *dic = [[EncryptionTools alloc] decry:responseObject[@"result"]];
        if(dic.count != 6){
            NSInteger total = [[dic objectForKey:@"total"] integerValue];
            self.total = total;
            
            NSArray *list = [dic objectForKey:@"list"];
            NSMutableArray *array = [ZZTMyZoneModel mj_objectArrayWithKeyValuesArray:list];
            
            [self.dataArray removeAllObjects];
            for (ZZTMyZoneModel *model in array) {
                ZZTStatusViewModel *viewModel = [ZZTStatusViewModel initViewModel:model];
                [self.dataArray addObject:viewModel];
            }
            //下载图片
            [self cacheImages:self.dataArray];
            
            //如果数据数量为0 那么作品View的按钮设置为选中状态
            self.zoneWordView.isSpreadWordHeight = self.dataArray.count == 0?YES:NO;
            
            if(self.dataArray.count >= total){
                [self.tabelView.mj_footer endRefreshingWithNoMoreData];
            }
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
        
        [self.tabelView reloadData];
        
    });
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 0;
    }else{
        self.tabelView.mj_footer.hidden = (_dataArray.count == 0);
        return _dataArray.count;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    ZZTMyZoneCell *cell = [tableView dequeueReusableCellWithIdentifier:myZoneCell forIndexPath:indexPath];
    
    ZZTStatusViewModel *model = self.dataArray[indexPath.row];
    model.modelIndex = indexPath.row;
    cell.reportBtn.reportblock = ^(ZZTReportModel *model) {
        [self shieldingMessage:model.index];
    };
    cell.reloadDataBlock = ^{
        [self loadData];
    };
    
    cell.longPressBlock = ^(ZZTStatusViewModel *model) {
        //删除
        [self delMomment:model];
    };
//    cell.indexRow = indexPath.row;
//    cell.update = ^{
//        [self loadData];
//    };
//    cell.LongPressBlock = ^(ZZTMyZoneModel *message) {
//        //删除
//        [self delMomment:message];
//    };
//    cell.reportBtn.delegate = self;

//    model.index = indexPath.row;
    model.nickName = self.userData.nickName;
    cell.model = model;
    return cell;
}

#pragma mark - headView
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0){
        //作者
        static NSString *zoneHeadViewIf = @"zoneHeadViewIf";
        self.zoneHeadView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:zoneHeadViewIf];
        //如果没有头视图
        if(!_zoneHeadView){
            _zoneHeadView = [[ZZTMyZoneHeaderView alloc] initWithReuseIdentifier:zoneHeadViewIf];
        }
        
        self.zoneHeadView.user = self.userData;
        
        return _zoneHeadView;
    }else{
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return SCREEN_HEIGHT * 0.36;
    }else{
        return 0.1;
    }
}

#pragma mark - footerView
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(section == 0){
        //作品
        self.zoneWordView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"zoneWordView"];
        if(!_zoneWordView){
            _zoneWordView = [[ZZTZoneWordView alloc] initWithReuseIdentifier:@"zoneWordView"];
        }
        weakself(self);
        _zoneWordView.changeHeight = ^{
            [weakSelf.tabelView reloadData];
        };
        return _zoneWordView;
    }else{
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(self.zoneWordView.dataArray.count == 0){
        self.zoneWordView.hidden = YES;
        return 0.1;
    }
    return self.zoneWordView.viewHeight;
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
        alpha = 0.99;
    }
    
    if(offsetY == 64){
        UIColor *color = [UIColor clearColor];
        
        self.viewNavBar.backgroundImageView.image = [UIImage createImageWithColor:color];
        
        [self.viewNavBar.leftButton setImage:[UIImage imageNamed:@"bordBack"] forState:UIControlStateNormal];
        
    }else{
        UIColor *color = [UIColor colorWithWhite:1 alpha:alpha];

        self.viewNavBar.backgroundImageView.image = [UIImage createImageWithColor:color];
        
        [self.viewNavBar.leftButton setImage:[UIImage imageNamed:@"blackBack"] forState:UIControlStateNormal];
    }
}

-(void)setUserId:(NSString *)userId{
    _userId = userId;
    //请求个人资料
    if([userId integerValue] == [Utilities GetNSUserDefaults].id && [[Utilities GetNSUserDefaults].userType isEqualToString:@"3"]){
   
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
    AFHTTPSessionManager *manager = [SBAFHTTPSessionManager getManager];
    [manager POST:[ZZTAPI stringByAppendingString:@"login/usersInfo"] parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [[EncryptionTools alloc] decry:responseObject[@"result"]];
        
        UserInfo *model= [UserInfo mj_objectWithKeyValues:dic];

        self.userData = model;
        self.zoneHeadView.user = model;
        [self.tabelView reloadData];

        [self.tabelView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tabelView.mj_header endRefreshing];
    }];
}

-(void)delMomment:(ZZTStatusViewModel *)model
{
    //判断用户id
    if([self.userId integerValue] != [Utilities GetNSUserDefaults].id){
        return;
    }
    ZZTAlertController *actionSheet = [ZZTAlertController alertControllerWithTitle:@"是否删除这条动态" message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    [actionSheet addDefaultAction:@"删除" handler:^{
        //删除接口
        [self sendDelMommentRequest:model];
    }];
    
    [actionSheet addCancelAction:@"取消" handler:^{
        
    }];

    [self presentViewController:actionSheet animated:YES completion:nil];
}

-(void)sendDelMommentRequest:(ZZTStatusViewModel *)model{
    AFHTTPSessionManager *manager = [SBAFHTTPSessionManager getManager];
    NSDictionary *dic = @{@"topicId":model.statusId};
    [manager POST:[ZZTAPI stringByAppendingString:@"circle/delUserRoom"] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self loadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

    }];
}

-(void)shieldingMessage:(NSInteger)index{
    ZZTStatusViewModel *model = _dataArray[index];
    [_dataArray removeObject:model];
    [self.tabelView reloadData];
}




@end
